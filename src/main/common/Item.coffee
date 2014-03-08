
# アイテムクラス

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# アイテムクラス
class rpg.Item

  # コンストラクタ
  constructor: (args={}) ->
    {
      @item
      @type
      @name
      @price
      usable
      equip
      stack
      maxStack
      container
    } = {
      item: ''      # ID(URL)
      name: ''      # 名前
      price: 1      # 価格
      usable: false # 使えるかどうか
      equip: false  # 装備できるかどうか
      stack: false  # スタック可能かどうか
      maxStack: 99  # スタック可能な場合のスタック数
      container: null
    }.$extendAll args
    # コンテナがある場合設定
    unless container is null
      @container = new rpg.ItemContainer(container)
      Object.defineProperty @, 'itemCount',
        get: (-> @container.itemCount).bind(@)
      Object.defineProperty @, 'itemlistCount',
        get: (-> @container.itemlistCount).bind(@)

    if typeof usable is 'string'
      Object.defineProperty @, 'usable', get: -> @['usable_'+usable].call(@)
    else
      Object.defineProperty @, 'usable', get: -> usable
    Object.defineProperty @, 'equip', get: -> equip
    Object.defineProperty @, 'stack', get: -> stack
    Object.defineProperty @, 'maxStack', get: -> maxStack

  # 戦闘中のみ使えるかどうか。戦闘中だと true
  usable_battle: -> rpg.system.temp.battle

  addItem: (item) ->
    return unless @container?
    @container.add item

  hasItem: (item) ->
    return unless @container?
    @container.contains item

  getItem: (index) ->
    return unless @container?
    @container.getAt index

  removeItem: (item) ->
    return unless @container?
    @container.remove item
