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
      rpg.system.db.preloadSkill [0,1], (skills) -> done()
  describe '初期化', ->
    it '引数無し', ->
      ai = new rpg.ai.RandomAI()
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
