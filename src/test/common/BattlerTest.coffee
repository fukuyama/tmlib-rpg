require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Effect.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/State.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/ItemContainer.coffee')
require('../../main/common/UsableItem.coffee')
require('../../main/common/EquipItem.coffee')
require('../../main/common/Weapon.coffee')
require('../../main/common/Armor.coffee')

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Battler', () ->
  battler = null
  describe 'バトラー生成', ->
    it '生成するとデフォルト値で初期化される', ->
      battler = new rpg.Battler()
    it '初期化されている', ->
      battler.name.should.equal '？？？'
      battler.str.should.equal 10
      battler.vit.should.equal 10
      battler.dex.should.equal 10
      battler.agi.should.equal 10
      battler.int.should.equal 10
      battler.sen.should.equal 10
      battler.luc.should.equal 10
      battler.cha.should.equal 10
      battler.basehp.should.equal 10
      battler.basemp.should.equal 10
    it 'セーブロード', ->
      json = rpg.utils.createJsonData(battler)
      b = rpg.utils.createRpgObject(json)
      b.name.should.equal '？？？'
      b.str.should.equal 10
      b.vit.should.equal 10
      b.dex.should.equal 10
      b.agi.should.equal 10
      b.int.should.equal 10
      b.sen.should.equal 10
      b.luc.should.equal 10
      b.cha.should.equal 10
      b.basehp.should.equal 10
      b.basemp.should.equal 10
  describe 'バトラー初期化', ->
    it '初期値を指定', ->
      battler = new rpg.Battler(
        name: 'ああああ'
        base:
          str: 11
          vit: 12
          dex: 13
          agi: 14
          int: 15
          sen: 16
          luc: 17
          cha: 18
          basehp: 19
          basemp: 20
      )
    it '初期化されている', ->
      battler.name.should.equal 'ああああ'
      battler.str.should.equal 11
      battler.vit.should.equal 12
      battler.dex.should.equal 13
      battler.agi.should.equal 14
      battler.int.should.equal 15
      battler.sen.should.equal 16
      battler.luc.should.equal 17
      battler.cha.should.equal 18
      battler.basehp.should.equal 19
      battler.basemp.should.equal 20
    it 'セーブロード', ->
      json = rpg.utils.createJsonData(battler)
      b = rpg.utils.createRpgObject(json)
      b.name.should.equal 'ああああ'
      b.str.should.equal 11
      b.vit.should.equal 12
      b.dex.should.equal 13
      b.agi.should.equal 14
      b.int.should.equal 15
      b.sen.should.equal 16
      b.luc.should.equal 17
      b.cha.should.equal 18
      b.basehp.should.equal 19
      b.basemp.should.equal 20
  describe '各パラメータを取得する', ->
    it '初期化', ->
      battler = new rpg.Battler(
        base:
          str: 18
          vit: 17
          dex: 16
          agi: 15
          int: 14
          sen: 13
          luc: 12
          cha: 11
          basehp: 10
          basemp: 9
      )
    it '攻撃力を取得', ->
      battler.patk.should.equal 26
    it '防御力を取得', ->
      battler.pdef.should.equal 24
    it '攻撃魔力を取得', ->
      battler.matk.should.equal 20
    it '回復魔力を取得', ->
      battler.mcur.should.equal 20
    it '魔力防御力を取得', ->
      battler.mdef.should.equal 19

    it '最大ヒットポイントを取得', ->
      battler.maxhp.should.equal 42
    it '最大マジックポイントを取得', ->
      battler.maxmp.should.equal 28

    it 'カレントヒットポイントを取得', ->
      battler.hp.should.equal 42
    it 'カレントマジックポイントを取得', ->
      battler.mp.should.equal 28

  describe 'プロパティ操作', ->
    battler = new rpg.Battler()
    it 'hpの増減', ->
      battler.hp.should.equal battler.maxhp
      battler.hp -= 10
      battler.hp.should.equal battler.maxhp - 10
    it 'hpの増減 maxhp 以上にはできない', ->
      battler.hp.should.equal battler.maxhp - 10
      battler.hp += 20
      battler.hp.should.equal battler.maxhp

  describe '敵味方識別', ->
    it '同じチームの場合は味方', ->
      b1 = new rpg.Battler(team:'a')
      b2 = new rpg.Battler(team:'a')
      (b1.iff b2).should.equal true
      (b2.iff b1).should.equal true
    it '違うチームの場合は敵', ->
      b1 = new rpg.Battler(team:'a')
      b2 = new rpg.Battler(team:'b')
      (b1.iff b2).should.equal false
      (b2.iff b1).should.equal false

  describe 'ステート', ->
    describe '基本', ->
      it '追加', ->
        battler = new rpg.Battler()
        battler.states.length.should.equal 0
        battler.addState new rpg.State(name:'State1')
        battler.states.length.should.equal 1
      it '削除', ->
        battler.states.length.should.equal 1
        battler.removeState name:'State1'
        battler.states.length.should.equal 0
      it '追加 state2', ->
        battler.states.length.should.equal 0
        battler.addState new rpg.State(name:'State2')
        battler.states.length.should.equal 1
      it '削除 state2', ->
        battler.states.length.should.equal 1
        battler.removeState 'State2'
        battler.states.length.should.equal 0
      it '複数追加', ->
        battler.states.length.should.equal 0
        battler.addState new rpg.State(name:'State1')
        battler.addState new rpg.State(name:'State2')
        battler.addState new rpg.State(name:'State3')
        battler.states.length.should.equal 3
      it '複数削除', ->
        t = [
          new rpg.State(name:'State1')
          new rpg.State(name:'State3')
        ]
        battler.removeState t
        battler.states.length.should.equal 1
      it '複数追加2', ->
        battler.states.length.should.equal 1
        battler.addState new rpg.State(name:'State4')
        battler.addState new rpg.State(name:'State5')
        battler.addState new rpg.State(name:'State6')
        battler.states.length.should.equal 4
      it '複数削除2', ->
        battler.removeState ["State1","State2","State5"]
        battler.states.length.should.equal 2
      it '能力変化ステート', ->
        battler = new rpg.Battler()
        battler.str.should.equal 10
        battler.dex.should.equal 10
        battler.addState new rpg.State(name:'ability up 1',abilities:[
          {str:{type:'fix',val:2}}
          {dex:{type:'fix',val:3}}
        ])
        battler.str.should.equal 12
        battler.dex.should.equal 13
    describe '毒', ->
      it 'ステート追加', ->
        battler = new rpg.Battler()
        state = new rpg.State(name:'毒',applies:[
          {hp:{type:'fix',val:-1}}
        ])
        battler.addState state
      it 'セーブロード', ->
        json = rpg.utils.createJsonData(battler)
        battler = rpg.utils.createRpgObject(json)
      it '１ターン経過するとＨＰが減る', ->
        battler.hp.should.equal 30
        battler.apply()
        battler.hp.should.equal 29
      it '２ターン経過するとＨＰが減る', ->
        battler.apply()
        battler.hp.should.equal 28
      it 'アイテムで解毒', ->
        battler.states.length.should.equal 1
        item = new rpg.UsableItem(name:'どくけし',effects:[
          {state:{type:'remove',name:'毒'}}
        ])
        battler.useItem(item,battler)
        battler.states.length.should.equal 0
      it '３ターン目は解毒されて減らない', ->
        battler.apply()
        battler.hp.should.equal 28
    describe '相殺ステート', ->
      it '力アップステート追加', ->
        battler = new rpg.Battler(base:{str:10})
        battler.states.length.should.equal 0
        state = new rpg.State {
          name:'力アップ'
          abilities:[
            {str:{type:'fix',val:5}}
          ]
          cancel:{
            states:['力ダウン']
          }
        }
        battler.addState state
        battler.str.should.equal 15
        battler.states.length.should.equal 1
      it '力ダウンステート追加で相殺する', ->
        battler.states.length.should.equal 1
        state = new rpg.State {
          name:'力ダウン'
          abilities:[
            {str:{type:'fix',val:-4}}
          ]
          cancel:{
            states:['力アップ']
          }
        }
        battler.addState state
        battler.str.should.equal 10
        battler.states.length.should.equal 0


  describe '装備関連', ->
    describe '武器', ->
      it '武器を装備する', ->
        weapon = new rpg.Weapon
          name: 'weapon001'
          patk: 100 # 攻撃力
        battler = new rpg.Battler
        battler.weapon = weapon
        battler.patk.should.equal 115
      it '力が上がる武器', ->
        weapon = new rpg.Weapon
          name: 'weapon001'
          patk: 100 # 攻撃力
          str: 5 # 力が5アップ
        battler = new rpg.Battler
        battler.weapon = weapon
        battler.patk.should.equal 120
