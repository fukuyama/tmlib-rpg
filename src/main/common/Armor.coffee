###*
* @file Armor.coffee
* 防具クラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# 防具クラス
class rpg.Armor extends rpg.EquipItem

  ###*
  * コンストラクタ
  * @classdesc 防具クラス
  * @constructor rpg.Armor
  * @extends rpg.EquipItem
  * @param {Object} args
  ###
  constructor: (args={}) ->
