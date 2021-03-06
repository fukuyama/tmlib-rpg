###*
* @file Item.coffee
* アイテムクラス
###


# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

{
  USABLE
} = rpg.constants

# アイテムクラス
class rpg.Item

  # コンストラクタ
  constructor: (args={}) ->
    {
      @url
      @type
      @name
      @price
      equip
      stack
      maxStack
      container
      @_effect
      @_counter
      @_container
      @_equip
      @_stack
      @_maxStack
    } = {
      url: ''       # ID(URL)
      name: ''      # 名前
      price: 1      # 価格
      equip: false  # 装備できるかどうか
      stack: false  # スタック可能かどうか
      maxStack: 99  # スタック可能な場合のスタック数
      container: null
      _effect: null
      _counter: null
      _container: null
    }.$extendAll args

    unless @_effect?
      @_effect = new rpg.Effect args

    unless @_effect._usable is USABLE.NONE
      unless @_counter?
        @_counter = new rpg.UsableCounter args

    unless @_container?
      if container?
        @_container = new rpg.ItemContainer container

    @_equip    = equip    unless @_equip?
    @_stack    = stack    unless @_stack?
    @_maxStack = maxStack unless @_maxStack?

  addItem: (item) ->
    return false unless @_container?
    @_container.add item

  hasItem: (item) ->
    return false unless @_container?
    @_container.contains item

  getItem: (args) ->
    return unless @_container?
    if typeof args is 'number'
      return @_container.getAt args
    if typeof args is 'string'
      return @_container.find args
    return

  eachItem: (f) ->
    return unless @_container?
    @_container.each f

  removeItem: (item) ->
    return false unless @_container?
    @_container.remove item

  clearItem: () ->
    return false unless @_container?
    @_container.clear()

  ###* 効果メソッド
  * @param {rpg.Battler} user 使用者
  * @param {Array} target 対象者(rpg.Battler配列)
  * @return {Object} 効果コンテキスト
  ###
  effect: (user,targets = []) -> @_effect.effect(user,targets)

  ###* 効果メソッド
  * @param {rpg.Battler} user 使用者
  * @param {Array} target 対象者(rpg.Battler配列)
  * @param {Object} log 効果ログ情報
  * @return {boolean} 効果ある場合 true
  ###
  effectApply: (user,targets = [],log = {}) -> @_effect.effectApply(user,targets,log)

  # 使う
  # user: rpg.Actor
  # target: rpg.Actor or Array<rpg.Actor>
  use: (user, target, log = {}) ->
    return false if @isLost() or not @usable
    r = @effectApply(user, [].concat(target), log)
    log.item = {name:@name}
    @_counter?.used r
    r

  isLost: -> @_counter?.isLost()

  reuse: -> @_counter?.reuse()

  isContainer: -> @_container?

Object.defineProperty rpg.Item.prototype, 'help',
  enumerable: true
  get: -> @_effect.help
  set: (h) -> @_effect.help = h

Object.defineProperty rpg.Item.prototype, 'message',
  enumerable: true
  get: -> @_effect.message
  set: (m) -> @_effect.message = m

Object.defineProperty rpg.Item.prototype, 'usable',
  enumerable: true
  get: -> @_effect.usable

Object.defineProperty rpg.Item.prototype, 'scope',
  enumerable: true
  get: -> @_effect.scope

Object.defineProperty rpg.Item.prototype, 'itemCount',
  enumerable: false
  get: -> @_container.itemCount
Object.defineProperty rpg.Item.prototype, 'itemlistCount',
  enumerable: false
  get: -> @_container.itemlistCount
Object.defineProperty rpg.Item.prototype, 'itemMax',
  enumerable: false
  set: (n) -> @_container.restriction.max = n
  get: -> @_container.restriction.max

Object.defineProperty rpg.Item.prototype, 'equip',
  enumerable: true
  get: -> @_equip
Object.defineProperty rpg.Item.prototype, 'stack',
  enumerable: true
  get: -> @_stack
Object.defineProperty rpg.Item.prototype, 'maxStack',
  enumerable: true
  get: -> @_maxStack
