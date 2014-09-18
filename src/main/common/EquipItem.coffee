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
    super args
    {
      @abilities
    } = {
      abilities: []
    } = args

  ###* 能力変化
  * @method rpg.State#ability
  * @param {Object} param
  * @param {number} param.base 基本値
  * @param {String} param.ability 能力
  * @return {number} ダメージ変化量
  ###
  ability: (param={}) ->
    {ability,base} = param
    r = 0
    for a in @abilities when a[ability]?
      r += rpg.effect.value(base,a[ability])
    r
