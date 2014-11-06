require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Effect.coffee')

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Effect', ->

  describe '汎用増減効果計算', ->
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

  describe 'value method', ->
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
    it 'hp', ->
      user1 = {hp: 100}
      user2 = {hp: 100}
      log = {}
      op = {type:'fix',val:10}
      rpg.effect.run 'hp', user1, user2, op, log
      user1.hp.should.equals 100
      user2.hp.should.equals 110
    it 'mp', ->
      user1 = {mp: 100}
      user2 = {mp: 100}
      log = {}
      op = {type:'fix',val:10}
      rpg.effect.run 'mp', user1, user2, op, log
      user1.mp.should.equals 100
      user2.mp.should.equals 110
    it 'hp method', ->
      user1 = {hp: 100}
      user2 = {hp: 100}
      log = {}
      op = {type:'fix',val:10}
      rpg.effect.hp user1, user2, op, log
      user1.hp.should.equals 100
      user2.hp.should.equals 110
    it 'mp method', ->
      user1 = {mp: 100}
      user2 = {mp: 100}
      log = {}
      op = {type:'fix',val:10}
      rpg.effect.mp user1, user2, op, log
      user1.mp.should.equals 100
      user2.mp.should.equals 110

  describe 'run array method', ->
    it 'hp method', ->
      user1 = {hp: 100}
      user2 = {hp: 100}
      log = {}
      efs = [
        {hp: {type:'fix',val:10}}
      ]
      rpg.effect.runArray user1, user2, efs, log
      user1.hp.should.equals 100
      user2.hp.should.equals 110

  describe 'run user method', ->
    it 'mp 2 を消費して、対象の hp を、10 回復する', ->
      user1 = {hp: 200, mp: 100}
      user2 = {hp: 150, mp: 120}
      log = {}
      op = {
        user: [
          {mp: {type:'fix',val:-2}}
        ]
        target: [
          {hp: {type:'fix',val:10}}
        ]
      }
      rpg.effect.runUser user1, user2, op, log
      user1.hp.should.equals 200
      user2.hp.should.equals 160
      user1.mp.should.equals 98
      user2.mp.should.equals 120
      log.targets[0].hp.should.equals 10
      log.users[0].mp.should.equals -2
    it.skip 'attack 効果', ->
      user1 = {hp: 200, mp: 100}
      user2 = {hp: 150, mp: 120}
      log = {}
      op = rpg.effect.create user1, user2, op, log
      rpg.effect.runUser user1, user2, op, log
      user1.hp.should.equals 200
      user2.hp.should.equals 160
      user1.mp.should.equals 98
      user2.mp.should.equals 120
      log.targets[0].hp.should.equals 10
      log.users[0].mp.should.equals -2
