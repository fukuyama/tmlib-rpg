require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Effect.coffee')
require('../../main/common/State.coffee')

SCOPE = rpg.constants.SCOPE

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Effect', ->

  rpg.system = rpg.system ? {}
  rpg.system.temp = rpg.system.temp ? {}
  rpg.system.db = rpg.system.db ? {}
  states = {
    'State1': new rpg.State({name:'State1'})
  }
  rpg.system.temp.battle = false

  rpg.system.db.state = (key) -> states[key]

  describe 'ヘルプテキスト', ->
    effect = null
    it 'default', ->
      effect = new rpg.Effect(url:'test01')
      effect.help.should.equal ''
    it 'set/get', ->
      effect = new rpg.Effect(url:'test01')
      effect.help.should.equal ''
      effect.help = 'help'
      effect.help.should.equal 'help'
      effect.help = 'help1'
      effect.help.should.equal 'help'
    it 'cache', ->
      effect = new rpg.Effect(url:'test01')
      effect.help.should.equal 'help'

  describe 'メッセージテンプレート', ->
    effect = null
    it 'default', ->
      effect = new rpg.Effect(url:'test02')
      effect.message.should.equal ''
    it 'set/get', ->
      effect = new rpg.Effect(url:'test02',message:{ok:[{type:'message',params:['test']}],ng:[]})
      effect.message.should.have.property 'ok'
      effect.message.ok.should.have.length 1
    it 'cache', ->
      effect = new rpg.Effect(url:'test02')
      effect.message.should.have.property 'ok'
      effect.message.ok.should.have.length 1
      effect = new rpg.Effect(url:'test03')
      effect.message.should.equal ''

  describe 'useableフラグ', ->
    effect = null
    it 'default', ->
      effect = new rpg.Effect()
      effect.usable.should.equal false
    it '戦闘時のみ使える効果のためにフラグ battle が設定できる', ->
      effect = new rpg.Effect(usable:true)
      rpg.system.temp.battle = false
      effect.usable.should.equal true, '戦闘じゃない時も使える'
      rpg.system.temp.battle = true
      effect.usable.should.equal true, '戦闘時も使える'
      effect = new rpg.Effect(usable:'battle')
      rpg.system.temp.battle = false
      effect.usable.should.equal false, '戦闘以外では使えない'
      rpg.system.temp.battle = true
      effect.usable.should.equal true, '戦闘時なので使える'

  describe '回復エフェクト', ->
    effect = null
    user = {
      name: 'user1'
      iff: -> true
      attackAttrs: -> []
    }
    targets = [
      {
        hp:50
        name:'user2'
        iff: -> true
      }
    ]
    it 'エフェクトの作成', ->
      effect = new rpg.Effect(
        user:
          effects:[
          ]
        target:
          effects:[
            {hp:10,attrs:['魔法','回復']}
          ]
      )
    it 'エフェクトの取得', ->
      cx = effect.effect(user,targets)
      cx.targets[0].hp.should.equal 10
      (cx.user isnt null).should.equal true
    it 'エフェクトの反映', ->
      targets[0].hp.should.equal 50
      log = {}
      effect.effectApply(user,targets,log)
      log.user.name.should.equal 'user1'
      log.targets[0].name.should.equal 'user2'
      log.targets[0].hp.should.equal 10
      targets[0].hp.should.equal 60

  describe '攻撃コンテキスト', ->
    effect = null
    user = {
      name: 'user1'
      patk: 100
      matk: 50
      iff: -> false
      attackAttrs: -> []
    }
    targets = [
      {
        hp:50
        name:'user2'
        pdef: 100
        iff: -> true
      }
    ]
    it '通常攻撃（物理）', ->
      effect = new rpg.Effect(
        scope: {
          type: SCOPE.TYPE.ENEMY
          range: SCOPE.RANGE.ONE
        }
        target:
          effects:[
            {hpdamage:[['user.patk','/',2],'-',['target.pdef','/',4]],attrs:['物理']}
          ]
      )
      atkcx = effect.effect(user,targets)
      atkcx.target.hpdamage.should.equal 25
      atkcx.target.attrs[0].should.equal '物理'

    it '魔法攻撃', ->
      effect = new rpg.Effect(
        name: '炎の矢'
        scope: {
          type: SCOPE.TYPE.ENEMY
          range: SCOPE.RANGE.ONE
        }
        target:
          effects:[
            {hpdamage:['user.matk','*',1.5],attrs:['魔法','炎']}
          ]
      )
      atkcx = effect.effect(user,targets)
      atkcx.target.hpdamage.should.equal 75
      atkcx.target.attrs[0].should.equal '魔法'
      atkcx.target.attrs[1].should.equal '炎'

  describe 'ステートエフェクト', ->
    effect = null
    user = {
      name: 'user1'
      atk: 100
      matk: 50
      iff: -> false
      attackAttrs: -> []
    }
    targets = [
      {
        hp:50
        name:'user2'
        iff: -> true
        states: []
      }
    ]
    it 'ステート追加', ->
      effect = new rpg.Effect(
        scope: {
          type: SCOPE.TYPE.ENEMY
          range: SCOPE.RANGE.ONE
        }
        target:
          effects:[
            {state: {type:'add',name:'State1'}}
          ]
      )
      target = targets[0]
      unless target.addState?
        target.addState = (state) ->
          target.states.push state
      log = {}
      effect.effectApply(user,targets,log)
      target.states[0].name.should.equal 'State1'
      log.user.name.should.equal 'user1'
      log.targets[0].name.should.equal 'user2'
      log.targets[0].state.name.should.equal 'State1'
      log.targets[0].state.type.should.equal 'add'
    it 'ステート削除する', ->
      effect = new rpg.Effect(
        scope: {
          type: SCOPE.TYPE.ENEMY
          range: SCOPE.RANGE.ONE
        }
        target:
          effects:[
            {state: {type:'remove',name:'State1'}}
          ]
      )
      target = targets[0]
      unless target.removeState?
        target.removeState = (state) ->
          state.name.should.equal 'State1'
          target.states.pop()
      log = {}
      effect.effectApply(user,targets,log)
      target.states.length.should.equal 0
      log.user.name.should.equal 'user1'
      log.targets[0].name.should.equal 'user2'
      log.targets[0].state.name.should.equal 'State1'
      log.targets[0].state.type.should.equal 'remove'

  describe '効果なしエフェクト', ->
    effect = new rpg.Effect(
      user:
        effects:[
        ]
      target:
        effects:[
          {hp:0,attrs:['魔法','回復']}
        ]
    )
    user = {
      name: 'user1'
      iff: -> true
      attackAttrs: -> []
    }
    targets = [
      {
        hp:50
        name:'user2'
        iff: -> true
      }
    ]
    it 'エフェクトの取得', ->
      cx = effect.effect(user,targets)
      cx.targets[0].hp.should.equal 0
      (cx.user isnt null).should.equal true
    it 'エフェクトの反映', ->
      log = {}
      r = effect.effectApply(user,targets,log)
      r.should.equal false
