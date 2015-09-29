# スキルリスト

require './requires.coffee'

SCOPE = rpg.constants.SCOPE

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
      type: SCOPE.TYPE.FRIEND
      range: SCOPE.RANGE.ONE
    target:
      effects:[
        hp:    -10
        attrs: ['魔法','回復']
      ]
]
