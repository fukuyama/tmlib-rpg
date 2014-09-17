###*
* @file EquipItem.coffee
* 装備可能アイテムクラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# 装備可能アイテムクラス
class rpg.EquipItem extends rpg.Item

  ###*
  * コンストラクタ
  * @classdesc 装備可能アイテムクラス
  * @constructor rpg.EquipItem
  * @extends rpg.Item
  * @param {Object} args
  ###
  constructor: (args={}) ->
