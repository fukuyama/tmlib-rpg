###*
* @file Weapon.coffee
* 武器クラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# 武器クラス
class rpg.Weapon extends rpg.EquipItem

  ###*
  * コンストラクタ
  * @classdesc 武器クラス
  * @constructor rpg.Weapon
  * @extends rpg.EquipItem
  * @param {Object} args
  ###
  constructor: (args={}) ->
