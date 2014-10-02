# 武器リスト

require('../../common/utils')
require('../../common/constants')

IDF = '000'
id = 0
weapon = (args) ->
  id += 1
  {
    type: 'Weapon'
    weapon: id.formatString IDF
  }.$extendAll args

module.exports = [
  weapon
    name: '片手剣'
    equips: ['right_hand']
    patk: 10
  weapon
    name: '片手斧'
    equips: ['right_hand']
    patk: 13
  weapon
    name: '棍棒'
    equips: ['right_hand']
    patk: 9
  weapon
    name: '杖'
    equips: ['right_hand']
    patk: 5
]
