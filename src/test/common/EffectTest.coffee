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
    it 'hp method', ->
      user1 = {hp: 100}
      user2 = {hp: 100}
      log = {}
      op = {type:'fix',val:10}
      rpg.effect.hp user1, user2, op, log
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
    it 'mp method', ->
      user1 = {mp: 100}
      user2 = {mp: 100}
      log = {}
      op = {type:'fix',val:10}
      rpg.effect.mp user1, user2, op, log
      user1.mp.should.equals 100
      user2.mp.should.equals 110
