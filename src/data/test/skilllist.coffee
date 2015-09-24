# スキルリスト

require './requires.coffee'

SKILL_SCOPE = rpg.constants.SKILL_SCOPE

IDF = '000'
id = 1
skill = (args) ->
  id += 1
  {
    type: 'Skill'
    skill: id.formatString IDF
  }.$extendAll args

module.exports = [
  skill
    name: '回復'
    help: '回復'
    scope:
      type: SKILL_SCOPE.TYPE.FRIEND
      range: SKILL_SCOPE.RANGE.ONE
    target:
      effects:[
        hp:    -10
        attrs: ['魔法','回復']
      ]
]
