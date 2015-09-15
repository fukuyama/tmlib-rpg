# アニメーションリスト

require './requires.coffee'

IDF = '000'
id = 0
animation = (args) ->
  id += 1
  animationid = id.formatString IDF
  {
    type: 'Animation'
    animation: animationid
  }.$extendAll args

module.exports = [
  animation
    name: 'test001'
    
]
