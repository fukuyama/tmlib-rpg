###*
* @file Troop.coffee
* トループクラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# トループクラス
class rpg.Troop

  ###*
  * コンストラクタ
  * @classdesc トループクラス
  * @constructor rpg.Troop
  * @param {Object} args
  ###
  constructor: (args={}) ->
    {
      @name
      @enemies
      @exp
    } = {
      name: 'troop 1'
      enemies: []
      exp: 0
    }.$extendAll(args)

  # TODO:落とすアイテムとかの処理が必要？
