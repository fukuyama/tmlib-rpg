
# 使用可能アイテムクラス

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# 使用可能アイテムクラス
class rpg.UsableCounter

  # コンストラクタ
  constructor: (args={}) ->
    {
      @lost
    } = {
      lost: {type:'ok_count',max: 1}
    }.$extendAll args
    # 消費確認メソッド
    @isLost = @['_lost_' + @lost.type].bind @, @lost
    # 再利用メソッド（lostを打ち消す）
    @reuse = @['_reuse_' + @lost.type].bind @, @lost
    
    @_reset()

  # 使う
  # r: 使用結果
  used: (r) ->
    if r then @ok_count += 1 else @ng_count += 1
    @count += 1
    r

  _reset: ->
    @count = 0 # 使用回数
    @ok_count = 0 # 使用成功回数
    @ng_count = 0 # 使用失敗回数

  # 使用回数で消費（成功失敗関係なし）
  _lost_count: (args) ->　(args.max <= @count)

  # 成功回数で消費
  _lost_ok_count: (args) ->　(args.max <= @ok_count)

  # 失敗回数で消費
  _lost_ng_count: (args) ->　(args.max <= @ng_count)

  # 再利用
  _reuse_count: (args) -> @_reset()

  _reuse_ok_count: (args) -> @_reset()

  _reuse_ng_count: (args) -> @_reset()
