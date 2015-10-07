
# アイテムコンテナクラス

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# コンテナ制約クラスの管理用
ITEM_RESTRICTION = {}

# アイテムコンテナクラス
class rpg.ItemContainer

  # コンストラクタ
  constructor: (args={}) ->
    {
      @containerType
      @stack
      @restriction
      @itemCount
      @_listItems
      @_stackItems
    } = {
      containerType: 'maxCount'
      stack: false
      restriction: null
      itemCount: 0
      _listItems: []
      _stackItems: {}
    }.$extendAll args

    unless @restriction?
      @restriction = ITEM_RESTRICTION[@containerType](args)

  # クリア
  clear: () ->
    @_listItems = []
    @_stackItems = {}
    @itemCount = 0
    true

  # 入ってるかどうか
  contains: (item) -> @_listItems.some (o) -> o.name is item.name

  # 追加確認
  # return: 追加可能なら true
  addCheck: (item) -> @restriction.addCheck(@,item)

  # 追加
  add: (item) ->
    return false unless @addCheck(item)
    # スタック可能かどうか
    if @stack and item.stack
      # スタックを用意
      @_stackItems[item.name] = 0 unless @_stackItems[item.name]?
      # アイテムをスタック
      @_stackItems[item.name] += 1
      # まだ入ってなければ、追加
      @_listItems.push item unless @contains(item)
      # スタック数確認
      if item.maxStack > 0
        n1 = Math.ceil(@_stackItems[item.name] / item.maxStack)
        n2 = @_listItems.reduce (
          (n,o) ->
            if o.name is item.name
              return n + 1
            else
              return n
        ), 0
        if n1 > n2
          @_listItems.push item
    else
      # スタックできない場合は追加するだけ
      @_listItems.push item
    @itemCount += 1
    true

  # 削除確認
  # return: 削除可能なら true
  removeCheck: (item) -> @restriction.removeCheck(@,item)

  # 削除
  remove: (item) ->
    # 削除確認
    return false unless @removeCheck(item)
    # なかったら消さない(名前で確認)
    return false unless @contains(item)
    if @stack and item.stack
      # インスタンスが無かったら削除しない
      if @_listItems.indexOf(item) < 0
        return false
      # スタックから削除
      @_stackItems[item.name] -= 1
      # スタックが無かったら
      if @_stackItems[item.name] == 0
        # スタックも削除
        delete @_stackItems[item.name]
        # アイテムからも削除
        i = @_listItems.indexOf(item)
        @_listItems.splice(i,1) if i >= 0
      # スタック数確認
      if item.maxStack > 0 and @_stackItems[item.name]?
        n1 = Math.ceil(@_stackItems[item.name] / item.maxStack)
        l = (ii for i,ii in @_listItems when i.name is item.name)
        n2 = l.length
        if n1 < n2
          # アイテムから削除
          i = l[l.length - 1]
          @_listItems.splice(i,1) if i >= 0
      # 再使用メソッドがあったら再利用化
      if item.reuse?
        item.reuse()
    else
      # アイテムから削除
      i = @_listItems.indexOf(item)
      if i >= 0
        @_listItems.splice(i,1)
      else
        return false # インスタンスがなかったら削除失敗
    @itemCount -= 1
    true

  # リスト処理
  each: (f) ->
    f.call(null,i) for i in @_listItems

  # 名前で取得
  find: (name) ->
    for v,i in @_listItems when v.name is name
      return v
    return

  # インデックスで取得
  # 無い場合は、undefined
  getAt: (index) ->
    return @_listItems[index]

Object.defineProperty rpg.ItemContainer.prototype, 'itemlistCount',
  enumerable: false
  get: -> @_listItems.length

# コンテナ制約クラス（個数バージョン）
class rpg.MaxCountItemContainer
  # コンストラクタ
  constructor: (args={})->
    {
      @max
    } = {
      max: -1 # マイナスだと無限
    }.$extendAll args

  # 追加確認
  # return: 追加可能なら true
  addCheck: (c,item) ->
    return true if @max < 0
    #if c.stack
    #  return c.itemlistCount < @max
    #else
    #  return c.itemCount < @max
    # 通常コンテナ／スタックコンテナの場合分け
    if c.stack
      # アイテム自体がスタック可能かどうか
      if item.stack
        # アイテムが既にスタックされてるかどうか
        if c._stackItems[item.name]?
          n = 0
          if item.maxStack > 0
            # スタック時、１つ増えた場合のアイテム欄増加数
            n = Math.ceil((c._stackItems[item.name] + 1) / item.maxStack)
            n -= 1
          return c.itemlistCount + n <= @max
        else
          return c.itemlistCount < @max
      else
        return c.itemlistCount < @max
    else
      return c.itemCount < @max

  # 削除確認
  # return: 削除可能なら true
  removeCheck: (c,item) -> true

ITEM_RESTRICTION.maxCount = (args) -> new rpg.MaxCountItemContainer(args)
