
# アイテムクラス

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

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
      @_container
    } = {
      url: ''       # ID(URL)
      name: ''      # 名前
      price: 1      # 価格
      equip: false  # 装備できるかどうか
      stack: false  # スタック可能かどうか
      maxStack: 99  # スタック可能な場合のスタック数
      container: null
      _container: null
    }.$extendAll args
    # FIXME:Effectもurlでキャッシュできるか？
    @_effect = new rpg.Effect args
    # コンテナがある場合設定
    if container? and not @_container?
      if container.constructor.name == 'Object'
        @_container = new rpg.ItemContainer(container)
    if @_container?
      Object.defineProperty @, 'itemCount',
        get: -> @_container.itemCount
      Object.defineProperty @, 'itemlistCount',
        get: -> @_container.itemlistCount
      if @_container.restriction?.max?
        Object.defineProperty @, 'itemMax',
          set: (n) -> @_container.restriction.max = n
          get: -> @_container.restriction.max

    Object.defineProperty @, 'equip',
      enumerable: true
      get: -> equip
    Object.defineProperty @, 'stack',
      enumerable: true
      get: -> stack
    Object.defineProperty @, 'maxStack',
      enumerable: true
      get: -> maxStack

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
