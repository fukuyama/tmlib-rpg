require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/State.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Effect.coffee')

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.State', () ->
  state = null
  battler = null
  describe '基本処理', ->
    it '初期化', ->
      state = new rpg.State()
      state.name.should.equal ''
    it '思考不能', ->
      state.think.should.equal true
    it '能力変化形（パッシブ的なやつ）', ->
      state.ability base:10, ability:'hp'
    it '定期変化するようなステート', ->
      battler = new rpg.Battler()
      state.apply battler:battler

  describe 'セーブロード', ->
    it 'データ変換確認', ->
      state = new rpg.State(name:'State01')
      json = rpg.utils.createJsonData(state)
      s = rpg.utils.createRpgObject(json)
      s.name.should.equal 'State01'

  describe '能力変化形', ->
    describe '固定値増減', ->
      it '力が１０あがるステート', ->
        state = new rpg.State(name:'State1',abilities:[
          {str:10}
        ])
      it 'データ変換確認', ->
        json = rpg.utils.createJsonData(state)
        s = rpg.utils.createRpgObject(json)
        s.name.should.equal 'State1'
        s.abilities[0].str.should.equal 10
      it 'baseを無視する', ->
        r = state.ability base:20, ability:'str'
        r.should.equal 10
        r = state.ability base:10, ability:'str'
        r.should.equal 10
      it '能力が違う場合は 0', ->
        r = state.ability base:10, ability:'vit'
        r.should.equal 0
    describe '割合増減', ->
      it '力が１０％あがるステート', ->
        state = new rpg.State(name:'State1',abilities:[
          {str:['base','/',10]}
        ])
      it 'baseから算出する 10% up', ->
        r = state.ability base:20, ability:'str'
        r.should.equal 2
        r = state.ability base:10, ability:'str'
        r.should.equal 1
      it '能力が違う場合は 0', ->
        r = state.ability base:10, ability:'vit'
        r.should.equal 0
      it '力が５０％下がるステート（半減する', ->
        state = new rpg.State(name:'State1',abilities:[
          {str:['base','*',[-50,'/',100]]}
        ])
      it 'baseから算出する 50% down', ->
        r = state.ability base:20, ability:'str'
        r.should.equal -10
        r = state.ability base:10, ability:'str'
        r.should.equal -5
      it '能力が違う場合は 0', ->
        r = state.ability base:10, ability:'vit'
        r.should.equal 0

  describe 'ステート追加確認', ->
    describe 'ステートリストなし', ->
      it '引数が無い場合は、true', ->
        state1 = new rpg.State(name:'State1',overlap:1)
        r = state1.checkAddTo()
        r.should.equal true
      it '空のステートリストには追加できる', ->
        states = []
        state1 = new rpg.State(name:'State1',overlap:1)
        r = state1.checkAddTo states:states
        r.should.equal true
    describe '重複数制限', ->
      it '重複数１の同ステートは、追加できない', ->
        states = [new rpg.State(name:'State1',overlap:1)]
        state1 = new rpg.State(name:'State1',overlap:1)
        r = state1.checkAddTo states:states
        r.should.equal false
      it '重複数１の別ステートは、追加できる', ->
        states = [new rpg.State(name:'State1',overlap:1)]
        state1 = new rpg.State(name:'State2',overlap:1)
        r = state1.checkAddTo states:states
        r.should.equal true
      it '重複数２の同ステートは、２つ追加できる。３つ目で失敗', ->
        states = []
        state1 = new rpg.State(name:'State1',overlap:2)
        r = state1.checkAddTo states:states
        r.should.equal true
        states.push state1
        state1 = new rpg.State(name:'State1',overlap:2)
        r = state1.checkAddTo states:states
        r.should.equal true
        states.push state1
        state1 = new rpg.State(name:'State1',overlap:2)
        r = state1.checkAddTo states:states
        r.should.equal false
    describe '相殺ステート', ->
      it '相殺ステート作成', ->
        state = new rpg.State(name:'State1',overlap:1,cancel:{
          states: []
        })
        state.hasCancel().should.equal false
        state = new rpg.State(name:'State1',overlap:1,cancel:{
          states: ['State2']
        })
        state.hasCancel().should.equal true
        state = new rpg.State(name:'State2',overlap:1)
        state.hasCancel().should.equal false
      it '相殺ステートがリストにある場合は、追加できない。', ->
        states = []
        state1 = new rpg.State(name:'State1')
        r = state1.checkAddTo states:states
        r.should.equal true
        states.push state1
        state1 = new rpg.State(name:'State2',cancel:{
          states: ['State4']
        })
        r = state1.checkAddTo states:states
        r.should.equal true
        states.push state1
        state1 = new rpg.State(name:'State3')
        r = state1.checkAddTo states:states
        r.should.equal true
        states.push state1
        state1 = new rpg.State(name:'State4')
        r = state1.checkAddTo states:states
        r.should.equal false
        states.push state1
      it '相殺ステート対象のステートがリストにある場合は、追加できない。', ->
        states = []
        state1 = new rpg.State(name:'State1')
        r = state1.checkAddTo states:states
        r.should.equal true
        states.push state1
        state1 = new rpg.State(name:'State2')
        r = state1.checkAddTo states:states
        r.should.equal true
        states.push state1
        state1 = new rpg.State(name:'State3')
        r = state1.checkAddTo states:states
        r.should.equal true
        states.push state1
        state1 = new rpg.State(name:'State4',cancel:{
          states:['State2']
        })
        r = state1.checkAddTo states:states
        r.should.equal false
        states.push state1
      it '相殺ステートの取得（リスト内から相殺あり）', ->
        state = new rpg.State(name:'StateCancel')
        states = []
        states.push new rpg.State(name:'State1')
        states.push new rpg.State(name:'State2',cancel:{
          states:['StateCancel']
        })
        states.push new rpg.State(name:'State3')
        r = state.findCancels(states)
        r.length.should.equal 1
        r[0].name.should.equal 'State2'
      it '相殺ステートの取得（リスト内に相殺対象）', ->
        state = new rpg.State(name:'State',cancel:{
          states:['StateCancel']
        })
        states = []
        states.push new rpg.State(name:'State1')
        states.push new rpg.State(name:'StateCancel')
        states.push new rpg.State(name:'State3')
        r = state.findCancels(states)
        r.length.should.equal 1
        r[0].name.should.equal 'StateCancel'

  describe 'ダメージ変化形', ->
    describe '攻撃側', ->
      atkcx = null
      defcx = null
      describe '属性キラー系', ->
        it '通常攻撃ダメージ100を、炎属性の相手にあたえる', ->
          atkcx = {hp:100,attrs:['物理']}
          defcx = {attrs:['炎']}
        it '炎属性に対して５０％アップのダメージステート', ->
          state = new rpg.State(name:'State1',damages:[
            {attack:{exp:['hp','/',2],attr:'炎',cond:'物理'}}
          ])
        it '増加ダメージ量が５０', ->
          state.attackDamage(atkcx,defcx).should.equal 50
        it '炎属性が無ければ増加量は0', ->
          defcx = {attrs:[]}
          state.attackDamage(atkcx,defcx).should.equal 0
        it '水属性の場合増加量は0', ->
          defcx = {attrs:['水']}
          state.attackDamage(atkcx,defcx).should.equal 0
      describe '物理ダメージを倍化するステート', ->
        it '通常攻撃ダメージ100を、炎属性の相手にあたえる', ->
          atkcx = {hp:100,attrs:['物理']}
          defcx = {attrs:['炎']}
        it 'ダメージが倍になるステート、大抵の対象が持つ物理属性で判定', ->
          state = new rpg.State(name:'State1',damages:[
            {attack:{exp:'hp',cond:'物理'}}
          ])
        it '増加ダメージ量が100', ->
          state.attackDamage(atkcx,defcx).should.equal 100
        it '炎属性が無くても、100', ->
          defcx = {attrs:[]}
          state.attackDamage(atkcx,defcx).should.equal 100
        it '水属性の場合でも100', ->
          defcx = {attrs:['水']}
          state.attackDamage(atkcx,defcx).should.equal 100
        it '魔法攻撃ダメージ100を、炎属性の相手にあたえる', ->
          atkcx = {hp:100,attrs:['魔法']}
          defcx = {attrs:['炎']}
        it '攻撃属性が合って無いので増加ダメージ量が0', ->
          state.attackDamage(atkcx,defcx).should.equal 0
      describe 'すべてのダメージを倍化するステート', ->
        it '通常攻撃ダメージ50を、炎属性の相手にあたえる', ->
          atkcx = {hp:50,attrs:['物理']}
          defcx = {attrs:['炎']}
        it 'ダメージが倍になるステート、大抵の対象が持つ物理属性で判定', ->
          state = new rpg.State(name:'State1',damages:[
            {attack:{exp:'hp'}}
          ])
        it '増加ダメージ量が50', ->
          state.attackDamage(atkcx,defcx).should.equal 50
        it '炎属性が無くても、50', ->
          defcx = {attrs:[]}
          state.attackDamage(atkcx,defcx).should.equal 50
        it '水属性の場合でも50', ->
          defcx = {attrs:['水']}
          state.attackDamage(atkcx,defcx).should.equal 50
        it '物理属性が無くても倍化', ->
          defcx = {attrs:[]}
          state.attackDamage(atkcx,defcx).should.equal 50
        it '魔法攻撃ダメージ50を、炎属性の相手にあたえる', ->
          atkcx = {hp:120,attrs:['魔法']}
          defcx = {attrs:['炎']}
        it '攻撃属性が合って無くても 120', ->
          state.attackDamage(atkcx,defcx).should.equal 120
      describe '攻撃に属性を付加するためのステート', ->
        it '炎属性を物理攻撃に追加するステート', ->
          state = new rpg.State(name:'State1',attrs:[
            {attack:{attr:'炎',cond:'物理'}}
          ])
        it 'ステートから物理攻撃時の属性を取得', ->
          atkcx = {hp:100,attrs:['物理']}
          attr = state.attackAttr(atkcx)
          attr.length.should.equal 1
          attr[0].should.equal '炎'
        it '魔法攻撃には付加されない', ->
          atkcx = {hp:100,attrs:['魔法']}
          attr = state.attackAttr(atkcx)
          attr.length.should.equal 0
        it '炎属性を魔法攻撃に追加するステート', ->
          state = new rpg.State(name:'State1',attrs:[
            {attack:{attr:'炎',cond:'魔法'}}
          ])
        it '物理攻撃には付加されない', ->
          atkcx = {hp:100,attrs:['物理']}
          attr = state.attackAttr(atkcx)
          attr.length.should.equal 0
        it '魔法攻撃には付加される', ->
          atkcx = {hp:100,attrs:['魔法']}
          attr = state.attackAttr(atkcx)
          attr.length.should.equal 1
          attr[0].should.equal '炎'
        it '炎属性を全攻撃に追加するステート', ->
          state = new rpg.State(name:'State1',attrs:[
            {attack:{attr:'炎'}}
          ])
        it 'ステートから物理攻撃時の属性を取得', ->
          atkcx = {hp:100,attrs:['物理']}
          attr = state.attackAttr(atkcx)
          attr.length.should.equal 1
          attr[0].should.equal '炎'
        it '魔法攻撃にも付加される', ->
          atkcx = {hp:100,attrs:['魔法']}
          attr = state.attackAttr(atkcx)
          attr.length.should.equal 1
          attr[0].should.equal '炎'
    describe '防御側', ->
      atkcx = null
      defcx = null
      describe 'ダメージ値変化', ->
        it '一律１０ダメージカット（無属性ダメージ）', ->
          atkcx = {hp:100,attrs:[]}
          defcx = {attrs:[]}
          state = new rpg.State(name:'State1',damages:[
            {defence:{exp:10}}
          ])
        it 'ダメージカットが10', ->
          state.defenceDamage(atkcx,defcx).should.equal 10
        it '物理攻撃でもカット10', ->
          atkcx = {hp:100,attrs:['物理']}
          state.defenceDamage(atkcx,defcx).should.equal 10
        it '魔法攻撃でもカット10', ->
          atkcx = {hp:100,attrs:['魔法']}
          state.defenceDamage(atkcx,defcx).should.equal 10
        it 'ダメージ量に関係なくカット10', ->
          atkcx = {hp:5,attrs:[]}
          state.defenceDamage(atkcx,defcx).should.equal 10
      describe '炎属性の攻撃を半減させるステート', ->
        it '炎属性半減ステート', ->
          state = new rpg.State(name:'State1',damages:[
            {defence:{exp:['hp','/',2],attr:'炎'}}
          ])
        it '防御側属性なし', ->
          defcx = {attrs:[]}
        it '炎属性ダメージ（物理）は半減', ->
          atkcx = {hp:100,attrs:['炎','物理']}
          state.defenceDamage(atkcx,defcx).should.equal 50
        it '炎属性ダメージ（魔法）は半減', ->
          atkcx = {hp:100,attrs:['炎','魔法']}
          state.defenceDamage(atkcx,defcx).should.equal 50
        it '水属性ダメージは半減しない', ->
          atkcx = {hp:100,attrs:['水','物理']}
          state.defenceDamage(atkcx,defcx).should.equal 0
          atkcx = {hp:100,attrs:['水','魔法']}
          state.defenceDamage(atkcx,defcx).should.equal 0
        it '物理攻撃のみはカットなし', ->
          atkcx = {hp:100,attrs:['物理']}
          state.defenceDamage(atkcx,defcx).should.equal 0
        it '魔法攻撃のみはカットなし', ->
          atkcx = {hp:100,attrs:['魔法']}
          state.defenceDamage(atkcx,defcx).should.equal 0
        it '炎属性半減ステート（物理のみ）', ->
          state = new rpg.State(name:'State1',damages:[
            {defence:{exp:['hp','/',2],attr:'炎',cond:'物理'}}
          ])
        it '防御側属性なし', ->
          defcx = {attrs:[]}
        it '炎属性ダメージ（物理）は半減', ->
          atkcx = {hp:100,attrs:['炎','物理']}
          state.defenceDamage(atkcx,defcx).should.equal 50
        it '水属性ダメージ（物理）は半減しない', ->
          atkcx = {hp:100,attrs:['水','物理']}
          state.defenceDamage(atkcx,defcx).should.equal 0
        it '炎属性ダメージ（魔法）は半減できない', ->
          atkcx = {hp:100,attrs:['炎','魔法']}
          state.defenceDamage(atkcx,defcx).should.equal 0
        it '物理攻撃のみはカットなし', ->
          atkcx = {hp:100,attrs:['物理']}
          state.defenceDamage(atkcx,defcx).should.equal 0
        it '魔法攻撃のみはカットなし', ->
          atkcx = {hp:100,attrs:['魔法']}
          state.defenceDamage(atkcx,defcx).should.equal 0
        it '炎属性半減ステート（魔法のみ）', ->
          state = new rpg.State(name:'State1',damages:[
            {defence:{exp:['hp','/',2],attr:'炎',cond:'魔法'}}
          ])
        it '防御側属性なし', ->
          defcx = {attrs:[]}
        it '炎属性ダメージ（物理）は半減できない', ->
          atkcx = {hp:100,attrs:['炎','物理']}
          state.defenceDamage(atkcx,defcx).should.equal 0
        it '炎属性ダメージ（魔法）は半減', ->
          atkcx = {hp:100,attrs:['炎','魔法']}
          state.defenceDamage(atkcx,defcx).should.equal 50
        it '水属性ダメージ（魔法）は半減しない', ->
          atkcx = {hp:100,attrs:['水','魔法']}
          state.defenceDamage(atkcx,defcx).should.equal 0
        it '物理攻撃のみはカットなし', ->
          atkcx = {hp:100,attrs:['物理']}
          state.defenceDamage(atkcx,defcx).should.equal 0
        it '魔法攻撃のみはカットなし', ->
          atkcx = {hp:100,attrs:['魔法']}
          state.defenceDamage(atkcx,defcx).should.equal 0
      describe '防御属性を付加するためのステート', ->
        describe '対物理攻撃', ->
          it '炎属性を物理攻撃に追加するステート', ->
            state = new rpg.State(name:'State1',attrs:[
              {defence:{attr:'炎',cond:'物理'}}
            ])
          it 'ステートから物理攻撃時の属性を取得', ->
            atkcx = {hp:100,attrs:['物理']}
            attr = state.defenceAttr(atkcx)
            attr.length.should.equal 1
            attr[0].should.equal '炎'
          it '魔法攻撃には付加されない', ->
            atkcx = {hp:100,attrs:['魔法']}
            attr = state.defenceAttr(atkcx)
            attr.length.should.equal 0
        describe '対魔法攻撃', ->
          it '炎属性を魔法攻撃に追加するステート', ->
            state = new rpg.State(name:'State1',attrs:[
              {defence:{attr:'炎',cond:'魔法'}}
            ])
          it '物理攻撃には付加されない', ->
            atkcx = {hp:100,attrs:['物理']}
            attr = state.defenceAttr(atkcx)
            attr.length.should.equal 0
          it '魔法攻撃には付加される', ->
            atkcx = {hp:100,attrs:['魔法']}
            attr = state.defenceAttr(atkcx)
            attr.length.should.equal 1
            attr[0].should.equal '炎'
        describe '対象攻撃なし', ->
          it '炎属性を全攻撃に追加するステート', ->
            state = new rpg.State(name:'State1',attrs:[
              {defence:{attr:'炎'}}
            ])
          it 'ステートから物理攻撃時の属性を取得', ->
            atkcx = {hp:100,attrs:['物理']}
            attr = state.defenceAttr(atkcx)
            attr.length.should.equal 1
            attr[0].should.equal '炎'
          it '魔法攻撃にも付加される', ->
            atkcx = {hp:100,attrs:['魔法']}
            attr = state.defenceAttr(atkcx)
            attr.length.should.equal 1
            attr[0].should.equal '炎'

  describe 'ステートガード系', ->
    describe '毒ガードを付加するステート', ->
      it '毒を10%ガード', ->
        state = new rpg.State(name:'毒ガード',guards:[
          {'毒':10}
        ])
      it 'カード率を取得', ->
        r = state.stateGuard(name:'毒')
        r.should.equal 10

  describe '定期実行系', ->
    describe '状態異常ステート毒', ->
      it '毒のステート', ->
        state = new rpg.State(name:'毒',applies:[
          {hp:-10}
        ])
      it '毒のステートを実行', ->
        # TODO: attack context にする必要があるかも
        data = {hp:100}
        state.apply(target:data)
        data.hp.should.equal 90

  describe '解除条件', ->
    describe '10ターンで消えるステート', ->
      it '作成', ->
        state = new rpg.State(name:'State1',remove:{
          apply:10
        })
        state.valid.should.equal true
      it '10回 apply すると、削除', ->
        n = 0
        for i in [0 ... 10]
          state.checkRemove().should.equal false
          state.apply({})
          state.valid.should.equal true
          n += 1
        n.should.equal 10
        state.checkRemove().should.equal true
        state.valid.should.equal false
    describe '戦闘終了時に消えるステート', ->
      it '作成 戦闘中のみのステート', ->
        state = new rpg.State(name:'State1',remove:{
          battle:true
        })
        state.valid.should.equal true
      it '削除チェック（戦闘中）', ->
        state.checkRemove().should.equal false
        state.valid.should.equal true
      it '削除チェック（戦闘終了時）', ->
        state.checkRemove(battleEnd:true).should.equal true
        state.valid.should.equal false
      it '削除チェック（戦闘終了後にもう一度）', ->
        state.checkRemove().should.equal true
        state.valid.should.equal false
    describe '衝撃（物理攻撃）で消えるステート', ->
      it '作成 hpにダメージが１以上で解除', ->
        state = new rpg.State(name:'State1',remove:{
          attack:{exp:['hp','>=',1],attr:'物理'}
        })
        state.valid.should.equal true
      it '魔法ダメージを受ける', ->
        atkcx = {hp:100,attrs:['魔法']}
        state.checkRemove(attack:atkcx).should.equal false
        state.valid.should.equal true
      it '物理ダメージを受ける', ->
        atkcx = {hp:100,attrs:['物理']}
        state.checkRemove(attack:atkcx).should.equal true
        state.valid.should.equal false
      it '物理ダメージ後に魔法ダメージをもう一度', ->
        atkcx = {hp:100,attrs:['魔法']}
        state.checkRemove(attack:atkcx).should.equal true
        state.valid.should.equal false
    describe '衝撃（物理攻撃）を受けた時に一定確率で消えるステート', ->
      it '８０％で解除されるステート', ->
        state = new rpg.State(name:'State1',remove:{
          attack:{exp:['hp','>=',1],attr:'物理'}
          rate: 80
        })
        state.valid.should.equal true
      it '物理ダメージを２００回あたえて確率を確かめる', ->
        atkcx = {hp:200,attrs:['物理']}
        n = 0
        for i in [0 ... 200] when state.checkRemove(attack:atkcx)
          n += 1
          state.valid = true # 強制的にリセット
        (70*2 < n and n < 90*2).should.equal true
        
  describe '行動不能系', ->
    describe '行動が一切できないステート', ->
      it '行動不能ステート', ->
        # TODO: コマンド入力は、どうしよ？ 100 だとできないはず
        state = new rpg.State(name:'State1',action:{
          rate: 100
        })
        state.valid.should.equal true
      it '行動できない', ->
        state.checkAction().should.equal false
    describe '一定確率で行動できないステート', ->
      it '80%行動不能ステート', ->
        state = new rpg.State(name:'State1',action:{
          rate: 80
        })
        state.valid.should.equal true
      it '８割行動できない 行動できるのが20%', ->
        n = 0
        for i in [0 ... 200] when state.checkAction()
          n += 1
        (30 < n and n < 50).should.equal true
