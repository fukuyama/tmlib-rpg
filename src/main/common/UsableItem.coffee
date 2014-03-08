
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
      effectType
      effect
      lostType
      lost
    } = {
      scope: {
        type: ITEM_SCOPE.TYPE.ACTOR
        count: ITEM_SCOPE.COUNT.ONE
        hp0: false
      }
      effectType: 'default'
      effect : {}
      lostType: 'count'
      lost: {max: 1}
    }.$extendAll args
    # 効果メソッド
    @effect = @['effect_'+effectType].bind @, effect
    # 消費確認メソッド
    @isLost = @['lost_'+lostType].bind @, lost

    @count = 0 # 使用回数
    @miss_count = 0 # 使用失敗回数

  # 使う
  # user: rpg.Actor
  # target: rpg.Actor or Array<rpg.Actor>
  use: (user, target) ->
    return false if @isLost()
    result = @effect(user, target)
    if result then @count += 1 else @miss_count += 1
    result

  # 効果
  # 基本的に、effect 以外では、user と target の状態は変化させない。
  # （使ったアイテムを減らす等は、Actor側の処理で）
  # 参照はあり
  # user: rpg.Actor
  # target: rpg.Actor or Array<rpg.Actor>
  # return: 効果あり true
  effect_default: (op, user, target) -> false

  # 回復効果
  effect_cure: (op, user, target) ->
    target = @scopeFilter target
  
  scopeFilter: (target) ->
    res = [].concat target
    #if @scope.type == ITEM_SCOPE.TYPE.ONE

  # lost_xxx のメソッドは、使用回数等の消費する条件を判定するためのもので
  # アイテムの状態を変更しちゃだめ。

  # 回数制限の消費アイテム
  # 使い終わってたら true
  lost_count: (args) ->　(args.max <= @count)
