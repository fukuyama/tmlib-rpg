require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Skill.coffee')

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Skill', ->

  describe '通常攻撃', ->
    it '素手', ->
      skill = rpg.Skill(
        name: '攻撃'
        effects: [
          {damage:{type:'+',val:'user.patk'}}
          {damage:{type:'*',val:4}}
          {damage:{type:'-',val:'target.pdef'}}
          {damage:{type:'*',val:2}}
        ]
      )
      # rpg.utils.jsonExpression を使う
