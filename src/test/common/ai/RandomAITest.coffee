require('chai').should()

require('../../../main/common/utils.coffee')
require('../../../main/common/constants.coffee')

require('../../../main/common/Skill.coffee')
require('../../../main/common/Effect.coffee')

require('../../../main/common/ai/RandomAI.coffee')

require('../System.coffee')

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.ai.RandomAI', () ->
  ai = null
  describe 'ＤＢ初期化', ->
    it 'load', (done) ->
      rpg.system.db.preloadSkill [0,1,2], (skills) -> done()
  describe '初期化', ->
    it '引数無し', ->
      ai = new rpg.ai.RandomAI()
  describe '条件のテスト', ->
    it 'スキル１つ', ->
      ai = new rpg.ai.RandomAI(
        actions: [
          {skill:1}
        ]
      )
      action = ai.makeAction(
        battler: null
        targets: []
        friends: []
        turn: 1
      )
      action.skill.name.should.equals '攻撃'
    it 'セーブロード', ->
      json = rpg.utils.createJsonData(ai)
      ai = rpg.utils.createRpgObject(json)
      action = ai.makeAction(
        battler: null
        targets: []
        friends: []
        turn: 1
      )
      action.skill.name.should.equals '攻撃'
    it '１ターン目は攻撃', ->
      ai = new rpg.ai.RandomAI(
        actions: [
          {
            cond:
              op: '>='
              turn: 2
            skill:2
          }
          {
            skill:1
          }
        ]
      )
      action = ai.makeAction(
        battler: null
        targets: []
        friends: []
        turn: 1
      )
      action.skill.name.should.equals '攻撃'
    it '２ターン以降に回復を使用スキルが候補に入る', ->
      actions = []
      for i in [0..10]
        action = ai.makeAction(
          battler: null
          targets: []
          friends: []
          turn: 2
        )
        actions.push action if 0 > actions.indexOf action
      actions.length.should.equals 2
