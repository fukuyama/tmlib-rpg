
# アイテムコンテナクラス

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

ITEM_CONTAINER = {}
  
# アイテムコンテナクラス
class rpg.ItemContainer

  # コンストラクタ
  constructor: (args={}) ->
    {
      @containerType
      @stack
    } = {
      containerType: 'maxCount'
      stack: false
    }.$extendAll args
    @items = [] # アイテム配列
    @stack_items = {} # スタックアイテム格納用ハッシュ
    @itemCount = 0
    @container = new ITEM_CONTAINER[@containerType](args)

    Object.defineProperty @, 'itemlistCount',
      get: -> @items.length

  # 入ってるかどうか
  contains: (item) ->
    res = false
    for i in @items when i.name is item.name
      res = true
      break
    res

  # 追加確認
  # return: 追加可能なら true
  addCheck: (item) -> @container.addCheck(@,item)

  # 追加
  add: (item) ->
    return false unless @addCheck(item)
    # スタック可能かどうか
    if @stack and item.stack
      # スタックを用意
      @stack_items[item.name] = [] unless @stack_items[item.name]?
      # アイテムをスタック
      @stack_items[item.name].push item
      # まだ入ってなければ、追加
      @items.push item unless @contains(item)
    else
      # スタックできない場合は追加するだけ
      @items.push item
    @itemCount += 1
    true

  # 削除
  remove: (item) ->
    # なかったら消さない
    return false unless @contains(item)
    if @stack and item.stack
      # スタックから削除
      i = @stack_items[item.name].indexOf(item)
      @stack_items[item.name].splice(i,1) if i >= 0
      # スタックが無かったら
      if @stack_items[item.name].length == 0
        # スタックも削除
        delete @stack_items[item.name]
        # アイテムからも削除
        i = @items.indexOf(item)
        @items.splice(i,1) if i >= 0
      # 削除対象が、アイテムリストに入ってる場合スタック内の物と入れ替える
      i = @items.indexOf(item)
      @items[i] = @stack_items[item.name][0] if i >= 0
    else
      # アイテムから削除
      # TODO: この場合、同じインスタンスじゃないと削除できないのはどうなんだろう？
      i = @items.indexOf(item)
      @items.splice(i,1) if i >= 0
    @itemCount -= 1
    true

  # 取得（コピーした配列）
  itemlist: () ->
    [].concat @items
  
  # 名前で取得
  find: (name) ->
    for v,i in @items when v.name is name
      return v
    return null

  # インデックスで取得
  getAt: (index) ->
    return null if typeof @items[index] is 'undefined'
    return @items[index]

class MaxCount
  # コンストラクタ
  constructor: (args={})->
    {
      @max
    } = {
      max: 0
    }.$extendAll args

  # 追加確認
  # return: 追加可能なら true
  addCheck: (c,item) ->
    return true if @max == 0
    # スタックコンテナの場合
    count = if c.stack then c.itemlistCount else c.itemCount
    count < @max

ITEM_CONTAINER.maxCount = MaxCount
