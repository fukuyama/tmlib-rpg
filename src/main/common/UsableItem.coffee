
# 使用可能アイテムクラス

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

ITEM_SCOPE = rpg.constants.ITEM_SCOPE

# 使用可能アイテムクラス
class rpg.UsableItem extends rpg.Item

  # コンストラクタ
  constructor: (args={}) ->
    args = {
      usable: true # 使えるかどうか
    }.$extendAll args
    super args
    {
      @scope
      @effects
      @lost
    } = {
      scope: {
        type: ITEM_SCOPE.TYPE.FRIEND
        range: ITEM_SCOPE.RANGE.ONE
        hp0: false
      }
      effects: []
      lost: {type:'ok_count',max: 1}
    }.$extendAll args
    # 消費確認メソッド
    @isLost = @['lost_'+@lost.type].bind @, @lost
    # 再利用メソッド（lostを打ち消す）
    @reuse = @['reuse_'+@lost.type].bind @, @lost
    
    @reset()

  reset: ->
    @count = 0 # 使用回数
    @ok_count = 0 # 使用成功回数
    @ng_count = 0 # 使用失敗回数
  
  # スコープ range の確認
  # スコープ外だったら、false
  checkScopeRange: (user, targets) ->
    (@scope.range == ITEM_SCOPE.RANGE.ONE and targets.length == 1) or
    (@scope.range == ITEM_SCOPE.RANGE.MULTI)

  # スコープ type の確認
  # スコープ外だったら、false
  checkScopeType: (user, target) ->
    if @scope.type == ITEM_SCOPE.TYPE.FRIEND
      return user.iff(target)
    if @scope.type == ITEM_SCOPE.TYPE.ENEMY
      return ! user.iff(target)
    true

  # 効果メソッド
  effect: (user,targets = [],log = {}) ->
    r = false
    log.user = {
      name: user.name # 使った人
    }
    log.item = {
      name: @name
    }
    log.targets = [] # 誰がどれくらい回復したか
    # TODO: effect と target の組み合わせのリザルトをどうするか…悩み中
    
    return false unless @checkScopeRange(user, targets)
    for t in targets when @checkScopeType(user, t)
      for effect in @effects
        for effectType, param of effect
          r = rpg.effect.run(effectType, param, user, t, log) or r
          #r = @['effect_'+effectType].call(@, param, user, t, log) or r
    r

  # 使う
  # user: rpg.Actor
  # target: rpg.Actor or Array<rpg.Actor>
  use: (user, target, log = {}) ->
    return false if @isLost()
    r = @effect(user, [].concat(target), log)
    if r then @ok_count += 1 else @miss_count += 1
    @count += 1
    r

  # lost_xxx のメソッドは、使用回数等の消費する条件を判定するためのもので
  # アイテムの状態を変更しちゃだめ。

  # 使用回数で消費（成功失敗関係なし）
  lost_count: (args) ->　(args.max <= @count)

  # 成功回数で消費
  lost_ok_count: (args) ->　(args.max <= @ok_count)

  # 失敗回数で消費
  lost_ng_count: (args) ->　(args.max <= @ng_count)

  # 再利用
  reuse_count: (args) -> @reset()

  reuse_ok_count: (args) -> @reset()

  reuse_ng_count: (args) -> @reset()
