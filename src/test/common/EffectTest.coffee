require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Effect.coffee')

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

  describe '攻撃コンテキスト', ->
    it '通常攻撃（物理）', ->
      effect = new rpg.Effect(effects:[
        {damage:['user.atk','*',2],attrs:['物理']}
      ])
      user = {
        atk: 100
      }
      atkcx = effect.attackContext(user)
      atkcx.damage.should.equals 200
      atkcx.attrs[0].should.equals '物理'

