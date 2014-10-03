
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
      @help
      @message
      usable
      equip
      stack
      maxStack
      container
      @_container
    } = {
      url: ''       # ID(URL)
      name: ''      # 名前
      price: 1      # 価格
      help: null    # ヘルプテキスト
      message: null # ログメッセージテンプレート
      usable: false # 使えるかどうか
      equip: false  # 装備できるかどうか
      stack: false  # スタック可能かどうか
      maxStack: 99  # スタック可能な場合のスタック数
      container: null
      _container: null
    }.$extendAll args
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

    if typeof usable is 'string'
      Object.defineProperty @, 'usable',
        enumerable: true
        get: -> @['usable_'+usable].call(@)
    else
      Object.defineProperty @, 'usable',
        enumerable: true
        get: -> usable
    Object.defineProperty @, 'equip',
      enumerable: true
      get: -> equip
    Object.defineProperty @, 'stack',
      enumerable: true
      get: -> stack
    Object.defineProperty @, 'maxStack',
      enumerable: true
      get: -> maxStack

  # 戦闘中のみ使えるかどうか。戦闘中だと true
  usable_battle: -> rpg.system.temp.battle

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

  # ヘルプテキストのキャッシュ
  @_helpCache = {}
  # メッセージテンプレートのキャッシュ
  @_messageCache = {}

Object.defineProperty rpg.Item.prototype, 'help',
  enumerable: true
  get: ->
    rpg.Item._helpCache[@url] ? ''
  set: (h) ->
    return if rpg.Item._helpCache[@url]?
    return unless h?
    rpg.Item._helpCache[@url] = h

Object.defineProperty rpg.Item.prototype, 'message',
  enumerable: true
  get: ->
    rpg.Item._messageCache[@url] ? ''
  set: (msg) ->
    return if rpg.Item._messageCache[@url]?
    return unless msg?
    rpg.Item._messageCache[@url] = msg
