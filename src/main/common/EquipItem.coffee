###*
* @file EquipItem.coffee
* 装備可能アイテムクラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

ABILITY_KEYS = [
  'str'
  'vit'
  'dex'
  'agi'
  'int'
  'sen'
  'luc'
  'cha'
  'basehp'
  'basemp'
  'patk'
  'pdef'
  'matk'
  'mcur'
  'mdef'
]

# 装備可能アイテムクラス
class rpg.EquipItem extends rpg.Item

  ###*
  * コンストラクタ
  * @classdesc 装備可能アイテムクラス
  * @constructor rpg.EquipItem
  * @extends rpg.Item
  * @param {Object} args
  * @param {Array} args.abilities effect value のオプション配列
  ###
  constructor: (args={}) ->
    args.equip = true
    super args
    {
      abilities
      @equips
      @required
      @equipOff
      @states
      price
    } = {
      abilities: []
      equips: [] # 装備場所
      required: [] # 装備条件
      equipOff: true # 装備解除フラグ
      states: [] # 装備時ステート
    }.$extendAll args
    for k in ABILITY_KEYS
      if args[k]?
        a = {}
        a[k] = args[k]
        abilities.push a
    @_ability_state = new rpg.State abilities:abilities
    # 価格が設定されてなかったら自動計算
    unless price?
      price = 0
      # TODO: とりあえず版。あとで、計算方法を検討～
      for k in ABILITY_KEYS
        price += @[k] * 50
      @price = price

  ###* 装備可能判定（場所）
  * @method rpg.EquipItem#checkEquips
  * @param {Array} equips これから装備する場所の情報
  * @return {boolean} 装備可能ならtrue
  ###
  checkEquips: (equips=[]) ->
    if Array.isArray equips
      return false unless equips.length == @equips.length
      r = true
      for e in equips
        r = @checkEquip(e) and r
      return r
    else
      return false unless @equips.length == 1
      return @checkEquip equips
    return false
  checkEquip: (equip) ->
    for e in @equips when e == equip
      return true
    return false

  ###* 装備解除判定（場所）
  * @method rpg.EquipItem#checkEquipOff
  * @param {rpg.Battler} battler バトラー
  * @return {boolean} 装備解除可能ならtrue
  ###
  checkEquipOff: (battler) ->
    # 呪われ装備
    return @equipOff

  ###* 装備可能判定（条件）
  * @method rpg.EquipItem#checkRequired
  * @param {rpg.Battler} battler バトラー
  * @return {boolean} 装備可能ならtrue
  ###
  checkRequired: (batller) ->
    r = true
    for req in @required
      r = rpg.utils.jsonExpression(req, batller) and r
    return r

  ###* 能力変化
  * @method rpg.EquipItem#ability
  * @param {Object} param
  * @param {number} param.base 基本値
  * @param {String} param.ability 能力
  * @return {number} 計算結果
  ###
  ability: -> @_ability_state.ability.apply @_ability_state, arguments

# 装備の能力を見る時に使う（バトラーのability計算に含まれるので、戦闘計算では、以下のメソッドは使用しない。）
for k in ABILITY_KEYS
  (
    (nm) ->
      Object.defineProperty rpg.EquipItem.prototype, nm,
        enumerable: true
        get: -> @ability base:0, ability: nm
  ) k

Object.defineProperty rpg.EquipItem.prototype, 'position',
  enumerable: true
  get: -> @equips[0]
