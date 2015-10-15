# トループリスト

require './requires.coffee'

IDF = '000'
id = 1
troop = (args) ->
  id += 1
  ids = id.formatString IDF
  {
    troop: ids
    name: 'troop'+ids
  }.$extendAll args

module.exports = [
  troop
    enemies: [1,1]
  troop
    enemies: [1,1,1]
  troop
    enemies: [1,1,1,1]
]
