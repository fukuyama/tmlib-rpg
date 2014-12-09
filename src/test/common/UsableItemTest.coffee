
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/State.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/ItemContainer.coffee')
require('../../main/common/UsableItem.coffee')
require('../../main/common/Effect.coffee')

ITEM_SCOPE = rpg.constants.ITEM_SCOPE

TEST_STATES = {
  'State1': new rpg.State({name:'State1'})
  'State2': new rpg.State({name:'State2'})
}
describe 'rpg.UsableItem', ->
  item = null
  log = null
  rpg.system = rpg.system ? {}
  rpg.system.temp = rpg.system.temp ? {}
  rpg.system.db = rpg.system.db ? {}
  
  describe '基本属性', ->
    it 'アイテムの初期化', ->
      item = new rpg.UsableItem()
    it '名前がある', ->
      (item.name is null).should.equal false
      item.name.should.equal ''
    it '名前を付ける', ->
      item.name = 'Name00'
      (item.name is null).should.equal false
      item.name.should.equal 'Name00'
    it '価格がある', ->
      (item.price is null).should.equal false
      item.price.should.equal 1
    it '価格を設定', ->
      item.price = 100
      item.price.should.equal 100
  describe '使った回数で使えなくなるアイテム', ->
    describe '１回使用するとなくなるアイテム', ->
      it '作成', ->
        item = new rpg.UsableItem(lost:{max:1})
        item.effect = () -> true
        item.isLost().should.equal false
      it 'アイテムを使用する', ->
        user = new rpg.Actor()
        target = new rpg.Actor()
        r = item.use user, target
        r.should.equal true
      it 'アイテムがロスト', ->
        item.isLost().should.equal true
    describe '２回使用するとなくなるアイテム', ->
      it '作成', ->
        item = new rpg.UsableItem(lost:{max:2})
        item.effect = () -> true
        item.isLost().should.equal false
      it 'アイテムを使用する１回目', ->
        user = new rpg.Actor()
        target = new rpg.Actor()
        r = item.use user, target
        r.should.equal true
      it 'アイテムがロストしない', ->
        item.isLost().should.equal false
      it 'アイテムを使用する２回目', ->
        user = new rpg.Actor()
        target = new rpg.Actor()
        r = item.use user, target
        r.should.equal true
      it 'アイテムがロスト', ->
        item.isLost().should.equal true
      it 'アイテムを使用する３回目。使用できない', ->
        user = new rpg.Actor()
        target = new rpg.Actor()
        r = item.use user, target
        r.should.equal false
    describe '使用終了したアイテムを復活させる', ->
      it '作成', ->
        item = new rpg.UsableItem(lost:{max:1})
        item.effect = () -> true
        item.isLost().should.equal false
      it 'アイテムを使用する', ->
        user = new rpg.Actor()
        target = new rpg.Actor()
        r = item.use user, target
        r.should.equal true
      it 'アイテムがロスト', ->
        item.isLost().should.equal true
      it '復活させるとロストしない', ->
        item.reuse()
        item.isLost().should.equal false
  describe '回復アイテムを使う（足りない場合）', ->
    it 'HPを１０回復する１度使えるアイテム', ->
      item = new rpg.UsableItem(
        lost:{max:1}
        target:
          effects:[
            {hp: -10}
          ]
      )
      item.isLost().should.equal false
    it '１１ダメージを受けてるので１０回復する', ->
      user = new rpg.Actor(name:'user')
      target = new rpg.Actor(name:'target')
      target.hp.should.equal target.maxhp
      target.hp -= 11
      target.hp.should.equal target.maxhp - 11
      r = item.use user, target
      r.should.equal true
      target.hp.should.equal target.maxhp - 1
    it 'アイテムがロスト', ->
      item.isLost().should.equal true
  describe '回復アイテムを使う（あふれる場合）', ->
    it 'HPを１０回復する１度使えるアイテム', ->
      item = new rpg.UsableItem(
        lost:{max:1}
        target:
          effects:[
            {hp: -10}
          ]
      )
      item.isLost().should.equal false
    it '９ダメージを受けてるので９回復して全快する', ->
      user = new rpg.Actor(name:'user')
      target = new rpg.Actor(name:'target')
      target.hp.should.equal target.maxhp
      target.hp -= 9
      target.hp.should.equal target.maxhp - 9
      log = {}
      r = item.use user, target, log
      r.should.equal true
      target.hp.should.equal target.maxhp
    it '結果確認', ->
      log.user.name.should.equal 'user'
      log.targets.length.should.equal 1
      log.targets[0].name.should.equal 'target'
      log.targets[0].hp.should.equal 9
    it 'アイテムがロスト', ->
      item.isLost().should.equal true
  describe '回復アイテムを使う（ぴったりの場合）', ->
    it 'HPを１０回復する１度使えるアイテム', ->
      item = new rpg.UsableItem(
        name: '10up'
        lost:{max:1}
        target:
          effects:[
            {hp: -10}
          ]
      )
      item.isLost().should.equal false
    it '１０ダメージを受けてるので１０回復して全快する', ->
      user = new rpg.Actor(name:'user')
      target = new rpg.Actor(name:'target')
      target.hp.should.equal target.maxhp
      target.hp -= 10
      target.hp.should.equal target.maxhp - 10
      log = {}
      r = item.use user, target, log
      r.should.equal true
      target.hp.should.equal target.maxhp
    it '結果確認', ->
      log.user.name.should.equal 'user'
      log.item.name.should.equal '10up'
      log.targets.length.should.equal 1
      log.targets[0].name.should.equal 'target'
      log.targets[0].hp.should.equal 10
    it 'アイテムがロスト', ->
      item.isLost().should.equal true
  describe '回復アイテムを使う（ダメージなしの場合）', ->
    it 'HPを１０回復する１度使えるアイテム', ->
      item = new rpg.UsableItem(
        lost:{max:1} # type: 'ok_count' (default)
        target:
          effects:[
            {hp: -10}
          ]
      )
      item.isLost().should.equal false
    it 'ダメージが無い場合は、アイテムは使用されない', ->
      user = new rpg.Actor(name:'user')
      target = new rpg.Actor(name:'target')
      target.hp.should.equal target.maxhp
      log = {}
      r = item.use user, target, log
      r.should.equal false
      target.hp.should.equal target.maxhp
    it '結果はなし', ->
      log.user.name.should.equal 'user'
      log.targets.length.should.equal 0
    it 'アイテムはロストしない', ->
      item.isLost().should.equal false
    it 'HPを１０回復する１度使えるアイテム（回復しなくてもロスト）', ->
      item = new rpg.UsableItem(
        lost:{type:'count',max:1}
        target:
          effects:[
            {hp: -10}
          ]
      )
      item.isLost().should.equal false
    it 'ダメージが無い場合は、アイテムは効果が無い', ->
      user = new rpg.Actor(name:'user')
      target = new rpg.Actor(name:'target')
      target.hp.should.equal target.maxhp
      log = {}
      r = item.use user, target, log
      r.should.equal false
      target.hp.should.equal target.maxhp
    it '結果はなし', ->
      log.user.name.should.equal 'user'
      log.targets.length.should.equal 0
    it 'アイテムはロストする', ->
      item.isLost().should.equal true
  describe 'MP回復アイテムを使う（足りない場合）', ->
    it 'MPを１０回復する１度使えるアイテム', ->
      item = new rpg.UsableItem(
        lost:{max:1}
        target:
          effects:[
            {mp: -10}
          ]
      )
      item.isLost().should.equal false
    it '１１ダメージを受けてるので１０回復する', ->
      user = new rpg.Actor(name:'user')
      target = new rpg.Actor(name:'target')
      target.mp.should.equal target.maxmp
      target.mp -= 11
      target.mp.should.equal target.maxmp - 11
      r = item.use user, target
      r.should.equal true
      target.mp.should.equal target.maxmp - 1
    it 'アイテムがロスト', ->
      item.isLost().should.equal true
  describe 'アイテムのスコープ', ->
    describe 'デフォルトは味方単体', ->
      it '初期化', ->
        item = new rpg.UsableItem()
      it '確認', ->
        item.scope.type.should.equal ITEM_SCOPE.TYPE.FRIEND
        item.scope.range.should.equal ITEM_SCOPE.RANGE.ONE
    describe '誰にでも使えるけど単体', ->
      it 'HPを１０回復する１度使えるアイテム', ->
        item = new rpg.UsableItem(
          lost:{max:1}
          scope:{
            type: ITEM_SCOPE.TYPE.ALL
            range: ITEM_SCOPE.RANGE.ONE
          }
          target:
            effects:[
              {hp: -10}
            ]
        )
        item.isLost().should.equal false
      it 'チームが違う人を回復させる', ->
        user = new rpg.Actor(name:'user',team:'a')
        target = new rpg.Actor(name:'target',team:'b')
        target.hp.should.equal target.maxhp
        target.hp -= 10
        target.hp.should.equal target.maxhp - 10
        log = {}
        r = item.use user, target, log
        r.should.equal true
        target.hp.should.equal target.maxhp
      it '結果確認', ->
        log.user.name.should.equal 'user'
        log.targets.length.should.equal 1
        log.targets[0].name.should.equal 'target'
        log.targets[0].hp.should.equal 10
      it 'アイテムはロスト', ->
        item.isLost().should.equal true
      it 'HPを１０回復する１度使えるアイテム', ->
        item = new rpg.UsableItem(
          lost:{max:1}
          scope:{
            type: ITEM_SCOPE.TYPE.ALL
            range: ITEM_SCOPE.RANGE.ONE
          }
          target:
            effects:[
              {hp: -10}
            ]
        )
        item.isLost().should.equal false
      it '複数の人を回復させようとすると使えない', ->
        user = new rpg.Actor(name:'user',team:'a')
        targets = []
        target = new rpg.Actor(name:'target1',team:'b')
        target.hp -= 10
        targets.push target
        target = new rpg.Actor(name:'target2',team:'b')
        target.hp -= 10
        targets.push target
        r = item.use user, targets
        r.should.equal false
        targets[0].hp.should.equal target.maxhp - 10
        targets[1].hp.should.equal target.maxhp - 10
    describe '味方にしか使えない単体アイテム', ->
      it 'HPを１０回復する１度使えるアイテム', ->
        item = new rpg.UsableItem(
          lost:{max:1}
          scope:{
            type: ITEM_SCOPE.TYPE.FRIEND
            range: ITEM_SCOPE.RANGE.ONE
          }
          target:
            effects:[
              {hp: -10}
            ]
        )
        item.isLost().should.equal false
      it 'チームが違う人には使えない', ->
        user = new rpg.Actor(name:'user',team:'a')
        target = new rpg.Actor(name:'target',team:'b')
        target.hp.should.equal target.maxhp
        target.hp -= 10
        target.hp.should.equal target.maxhp - 10
        r = item.use user, target
        r.should.equal false
        target.hp.should.equal target.maxhp - 10
      it 'チームが同じ人には使える', ->
        user = new rpg.Actor(name:'user',team:'a')
        target = new rpg.Actor(name:'target',team:'a')
        target.hp.should.equal target.maxhp
        target.hp -= 10
        target.hp.should.equal target.maxhp - 10
        r = item.use user, target
        r.should.equal true
        target.hp.should.equal target.maxhp
    describe '誰にでも複数人に使えるアイテム', ->
      it 'HPを１０回復する１度使えるアイテム', ->
        item = new rpg.UsableItem(
          lost:{max:1}
          scope:{
            type: ITEM_SCOPE.TYPE.ALL
            range: ITEM_SCOPE.RANGE.MULTI
          }
          target:
            effects:[
              {hp: -10}
            ]
        )
        item.isLost().should.equal false
      it 'チームが違っても複数の人を回復できる', ->
        user = new rpg.Actor(name:'user',team:'a')
        targets = []
        target = new rpg.Actor(name:'target1',team:'b')
        target.hp -= 10
        targets.push target
        target = new rpg.Actor(name:'target2',team:'a')
        target.hp -= 11
        targets.push target
        log = {}
        r = item.use user, targets, log
        r.should.equal true
        targets[0].hp.should.equal target.maxhp
        targets[1].hp.should.equal target.maxhp - 1
      it '結果確認', ->
        log.user.name.should.equal 'user'
        log.targets.length.should.equal 2
        log.targets[0].name.should.equal 'target1'
        log.targets[0].hp.should.equal 10
        log.targets[1].name.should.equal 'target2'
        log.targets[1].hp.should.equal 10
      it 'アイテムはロスト', ->
        item.isLost().should.equal true
    describe '味方の複数人に使えるアイテム', ->
      it 'HPを１０回復する１度使えるアイテム', ->
        item = new rpg.UsableItem(
          lost:{max:1}
          scope:{
            type: ITEM_SCOPE.TYPE.FRIEND
            range: ITEM_SCOPE.RANGE.MULTI
          }
          target:
            effects:[
              {hp: -10}
            ]
        )
        item.isLost().should.equal false
      it '対象に仲間が一人もいない場合は失敗する', ->
        user = new rpg.Actor(name:'user',team:'a')
        targets = []
        target = new rpg.Actor(name:'target1',team:'b')
        target.hp -= 10
        targets.push target
        target = new rpg.Actor(name:'target2',team:'b')
        target.hp -= 11
        targets.push target
        r = item.use user, targets
        r.should.equal false
        targets[0].hp.should.equal target.maxhp - 10
        targets[1].hp.should.equal target.maxhp - 11
      it '対象に仲間が居る場合は敵が含まれていても使用される', ->
        user = new rpg.Actor(name:'user',team:'a')
        targets = []
        target = new rpg.Actor(name:'target1',team:'b')
        target.hp -= 10
        targets.push target
        target = new rpg.Actor(name:'target2',team:'a')
        target.hp -= 11
        targets.push target
        target = new rpg.Actor(name:'target3',team:'b')
        target.hp -= 9
        targets.push target
        log = {}
        r = item.use user, targets, log
        r.should.equal true
        targets[0].hp.should.equal target.maxhp - 10
        targets[1].hp.should.equal target.maxhp - 1
        targets[2].hp.should.equal target.maxhp - 9
      it '結果確認', ->
        log.user.name.should.equal 'user'
        log.targets.length.should.equal 1
        log.targets[0].name.should.equal 'target2'
        log.targets[0].hp.should.equal 10
      it 'アイテムはロスト', ->
        item.isLost().should.equal true
      it 'HPを１０回復する１度使えるアイテム', ->
        item = new rpg.UsableItem(
          lost:{max:1}
          scope:{
            type: ITEM_SCOPE.TYPE.FRIEND
            range: ITEM_SCOPE.RANGE.MULTI
          }
          target:
            effects:[
              {hp: -10}
            ]
        )
        item.isLost().should.equal false
      it '全員味方なので全員が回復する', ->
        user = new rpg.Actor(name:'user',team:'a')
        targets = []
        target = new rpg.Actor(name:'target1',team:'a')
        target.hp -= 10
        targets.push target
        target = new rpg.Actor(name:'target2',team:'a')
        target.hp -= 11
        targets.push target
        target = new rpg.Actor(name:'target3',team:'a')
        target.hp -= 9
        targets.push target
        log = {}
        r = item.use user, targets, log
        r.should.equal true
        targets[0].hp.should.equal target.maxhp
        targets[1].hp.should.equal target.maxhp - 1
        targets[2].hp.should.equal target.maxhp
      it '結果確認', ->
        log.user.name.should.equal 'user'
        log.targets.length.should.equal 3
        log.targets[0].name.should.equal 'target1'
        log.targets[0].hp.should.equal 10
        log.targets[1].name.should.equal 'target2'
        log.targets[1].hp.should.equal 10
        log.targets[2].name.should.equal 'target3'
        log.targets[2].hp.should.equal 9
      it 'アイテムはロスト', ->
        item.isLost().should.equal true

  describe 'ステート変化', ->
    describe 'ステート付加アイテム', ->
      it '作成', ->
        item = new rpg.UsableItem(
          target:
            effects:[
              {state: {type:'add',name:'State1'}}
            ]
        )
        item.isLost().should.equal false
      it '使うとステートが追加される', ->
        rpg.system.db.state = (name) -> TEST_STATES[name]
        target = new rpg.Actor(name:'target1',team:'a')
        target.states.length.should.equal 0
        user = new rpg.Actor(name:'user',team:'a')
        log = {}
        r = item.use user, target, log
        r.should.equal true
        target.states.length.should.equal 1
      it '結果確認', ->
        log.user.name.should.equal 'user'
        log.targets.length.should.equal 1
        log.targets[0].name.should.equal 'target1'
        log.targets[0].state.type.should.equal 'add'
        log.targets[0].state.name.should.equal 'State1'

    describe 'ステート解除アイテム', ->
      it '作成', ->
        item = new rpg.UsableItem(
          target:
            effects:[
              {state: {type:'remove',name:'State1'}}
            ]
        )
        item.isLost().should.equal false
      it '使うとステートが削除される（名前で指定）', ->
        target = new rpg.Actor(name:'target1',team:'a')
        target.addState(new rpg.State(name:'State1'))
        target.states.length.should.equal 1
        user = new rpg.Actor(name:'user',team:'a')
        log = {}
        r = item.use user, target, log
        r.should.equal true
        target.states.length.should.equal 0
      it '結果確認', ->
        log.user.name.should.equal 'user'
        log.targets.length.should.equal 1
        log.targets[0].name.should.equal 'target1'
        log.targets[0].state.type.should.equal 'remove'
        log.targets[0].state.name.should.equal 'State1'
    describe 'ステート解除アイテム（複数のステートから１つ解除）', ->
      it '作成', ->
        item = new rpg.UsableItem(
          target:
            effects:[
              {state: {type:'remove',name:'State2'}}
            ]
        )
        item.isLost().should.equal false
      it '使うとステートが削除される（名前で指定）', ->
        target = new rpg.Actor(name:'target1',team:'a')
        target.addState(new rpg.State(name:'State1'))
        target.states.length.should.equal 1
        target.addState(new rpg.State(name:'State2'))
        target.states.length.should.equal 2
        user = new rpg.Actor(name:'user',team:'a')
        log = {}
        r = item.use user, target, log
        r.should.equal true
        target.states.length.should.equal 1
      it '結果確認', ->
        log.user.name.should.equal 'user'
        log.targets.length.should.equal 1
        log.targets[0].name.should.equal 'target1'
        log.targets[0].state.type.should.equal 'remove'
        log.targets[0].state.name.should.equal 'State2'
