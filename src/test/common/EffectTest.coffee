require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Effect.coffee')
require('../../main/common/State.coffee')

ITEM_SCOPE = rpg.constants.ITEM_SCOPE

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Effect', ->

  rpg.system = rpg.system ? {}
  rpg.system.temp = rpg.system.temp ? {}
  rpg.system.db = rpg.system.db ? {}
  states = {
    'State1': new rpg.State({name:'State1'})
  }

  rpg.system.db.state = (key) -> states[key]

  describe '回復エフェクト', ->
    effect = null
    user = {
      name: 'user1'
      iff: -> true
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
            {hp:-10,attrs:['魔法','回復']}
          ]
      )
    it 'エフェクトの取得', ->
      cx = effect.effect(user,targets)
      cx.targets[0].hp.should.equals -10
      (cx.user isnt null).should.equals true
    it 'エフェクトの反映', ->
      targets[0].hp.should.equals 50
      log = {}
      effect.effectApply(user,targets,log)
      log.user.name.should.equals 'user1'
      log.targets[0].name.should.equals 'user2'
      log.targets[0].hp.should.equals 10
      targets[0].hp.should.equals 60

  describe '攻撃コンテキスト', ->
    effect = null
    user = {
      name: 'user1'
      atk: 100
      matk: 50
      iff: -> false
    }
    targets = [
      {
        hp:50
        name:'user2'
        iff: -> true
      }
    ]
    it '通常攻撃（物理）', ->
      effect = new rpg.Effect(
        scope: {
          type: ITEM_SCOPE.TYPE.ENEMY
          range: ITEM_SCOPE.RANGE.ONE
        }
        target:
          effects:[
            {hp:['user.atk','*',2],attrs:['物理']}
          ]
      )
      atkcx = effect.effect(user,targets)
      atkcx.target.hp.should.equals 200
      atkcx.target.attrs[0].should.equals '物理'

    it '魔法攻撃', ->
      effect = new rpg.Effect(
        name: '炎の矢'
        scope: {
          type: ITEM_SCOPE.TYPE.ENEMY
          range: ITEM_SCOPE.RANGE.ONE
        }
        target:
          effects:[
            {hp:['user.matk','*',1.5],attrs:['魔法','炎']}
          ]
      )
      atkcx = effect.effect(user,targets)
      atkcx.target.hp.should.equals 75
      atkcx.target.attrs[0].should.equals '魔法'

  describe 'ステートエフェクト', ->
    effect = null
    user = {
      name: 'user1'
      atk: 100
      matk: 50
      iff: -> false
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
          type: ITEM_SCOPE.TYPE.ENEMY
          range: ITEM_SCOPE.RANGE.ONE
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
      effect.effectApply(user,targets)
      target.states[0].name.should.equals 'State1'
    it 'ステート削除する', ->
      effect = new rpg.Effect(
        scope: {
          type: ITEM_SCOPE.TYPE.ENEMY
          range: ITEM_SCOPE.RANGE.ONE
        }
        target:
          effects:[
            {state: {type:'remove',name:'State1'}}
          ]
      )
      target = targets[0]
      unless target.removeState?
        target.removeState = (state) ->
          state.name.should.equals 'State1'
          target.states.pop()
      effect.effectApply(user,targets)
      target.states.length.should.equals 0

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
      cx.targets[0].hp.should.equals 0
      (cx.user isnt null).should.equals true
    it 'エフェクトの反映', ->
      log = {}
      r = effect.effectApply(user,targets,log)
      r.should.equals false
