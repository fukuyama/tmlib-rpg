# 防具リスト

require './requires.coffee'

IDF = '000'
id = 0
armor = (args) ->
  id += 1
  {
    type: 'Armor'
    armor: id.formatString IDF
  }.$extendAll args

module.exports = [
  armor
    name: '兜'
    equips: ['head']
    pdef: 5
  armor
    name: '鎧上'
    equips: ['upper_body']
    pdef: 10
  armor
    name: '鎧下'
    equips: ['lower_body']
    pdef: 8
  armor
    name: '小手'
    equips: ['arms']
    pdef: 4
  armor
    name: '靴'
    equips: ['legs']
    pdef: 4
  armor
    name: '盾'
    equips: ['right_hand']
    pdef: 5
]
