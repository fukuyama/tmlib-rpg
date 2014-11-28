require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Effect.coffee')

ITEM_SCOPE = rpg.constants.ITEM_SCOPE

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Effect', ->

  describe.skip '汎用増減効果計算', ->
    it '固定値での増減', ->
      r = rpg.effect.value 10, {type:'fix',val:20}
      r.should.equal 20
      r = rpg.effect.value 10, {type:'fix',val:-4}
      r.should.equal -4
    it '率での増減', ->
      r = rpg.effect.value 50, {type:'rate',val:20}
      r.should.equal 10
      r = rpg.effect.value 10, {type:'rate',val:-10}
      r.should.equal -1
    it '半減', ->
      r = rpg.effect.value 88, {type:'rate',val:-50}
      r.should.equal -44

  describe.skip 'value method', ->
    it 'default', ->
      n = rpg.effect.value 10
      n.should.equals 10
      n = rpg.effect.value 20
      n.should.equals 10
      n = rpg.effect.value -5
      n.should.equals 10
    it 'fix value', ->
      efv = {type:'fix',val:20}
      n = rpg.effect.value 10, efv
      n.should.equals 20
      n = rpg.effect.value 20, efv
      n.should.equals 20
      n = rpg.effect.value -5, efv
      n.should.equals 20

  describe 'run method', ->
    effect = null
    it 'hp', ->
      effect = new rpg.Effect()
      user1 = {hp: 100}
      user2 = {hp: 100}
      log = {}
      op = 10
      effect.run 'hp', user1, user2, op, log
      user1.hp.should.equals 100
      user2.hp.should.equals 110
    it 'mp', ->
      effect = new rpg.Effect()
      user1 = {mp: 100}
      user2 = {mp: 100}
      log = {}
      op = 10
      effect.run 'mp', user1, user2, op, log
      user1.mp.should.equals 100
      user2.mp.should.equals 110
    it 'hp method', ->
      effect = new rpg.Effect()
      user1 = {hp: 100}
      user2 = {hp: 100}
      log = {}
      op = 10
      effect.hp user1, user2, op, log
      user1.hp.should.equals 100
      user2.hp.should.equals 110
    it 'mp method', ->
      effect = new rpg.Effect()
      user1 = {mp: 100}
      user2 = {mp: 100}
      log = {}
      op = 10
      effect.mp user1, user2, op, log
      user1.mp.should.equals 100
      user2.mp.should.equals 110

  describe 'run array method', ->
    it 'hp method', ->
      effect = new rpg.Effect()
      user1 = {hp: 100}
      user2 = {hp: 100}
      log = {}
      efs = [
        {hp: 10}
      ]
      effect.runArray user1, user2, efs, log
      user1.hp.should.equals 100
      user2.hp.should.equals 110

  describe 'run user method', ->
    it 'mp 2 を消費して、対象の hp を、10 回復する', ->
      effect = new rpg.Effect()
      user1 = {hp: 200, mp: 100}
      user2 = {hp: 150, mp: 120}
      log = {}
      op = {
        user: [
          {mp: -2}
        ]
        target: [
          {hp: 10}
        ]
      }
      effect.runUser user1, user2, op, log
      user1.hp.should.equals 200
      user2.hp.should.equals 160
      user1.mp.should.equals 98
      user2.mp.should.equals 120
      log.targets[0].hp.should.equals 10
      log.users[0].mp.should.equals -2

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
      log.targets[0].hp.should.equals -10
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
