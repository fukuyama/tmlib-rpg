# スキルリスト

require './requires.coffee'

SCOPE = rpg.constants.SCOPE

IDF = '000'
id = 1
skill = (args) ->
  id += 1
  {
    skill: id.formatString IDF
  }.$extendAll args

module.exports = [
  skill
    name: 'キュアI'
    help: '対象のＨＰを小回復'
    scope:
      type: SCOPE.TYPE.ALL
      range: SCOPE.RANGE.ONE
    user:
      effects:[
        mp: -4
      ]
    target:
      effects:[
        hp:    [[30,'+',[1,'random',5]],'+',['user.mcur','/',10]]
        attrs: ['魔法','回復']
      ]
  skill
    name: 'キュアII'
    help: '対象のＨＰを中回復'
    scope:
      type: SCOPE.TYPE.ALL
      range: SCOPE.RANGE.ONE
    user:
      effects:[
        mp: -8
      ]
    target:
      effects:[
        hp:    [[90,'+',[1,'random',10]],'+',['user.mcur','/',10]]
        attrs: ['魔法','回復']
      ]
  skill
    name: 'キュアIII'
    help: '対象のＨＰを大回復'
    scope:
      type: SCOPE.TYPE.ALL
      range: SCOPE.RANGE.ONE
    user:
      effects:[
        mp: -16
      ]
    target:
      effects:[
        hp:    [[270,'+',[1,'random',20]],'+',['user.mcur','/',10]]
        attrs: ['魔法','回復']
      ]
]
