
# 使用可能アイテムクラス

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# 使用可能アイテムクラス
class rpg.UsableItem extends rpg.Item

  # コンストラクタ
  constructor: (args={}) ->
    args = {
      usable: true # 使えるかどうか
    }.$extendAll args
    super args
    {
      lost
      @lostParam
    } = {
      lost: 'count'
      lostParam: 1
    }.$extendAll args
    @lostFunc = @['lost_'+lost]
    @count = 0 # 使用回数
    @miss_count = 0 # 使用失敗回数

  # 効果
  # user: rpg.Actor
  # target: rpg.Actor or Array<rpg.Actor>
  # return: 効果あり true
  effect: (user, target) -> false

  # 使う
  # user: rpg.Actor
  # target: rpg.Actor or Array<rpg.Actor>
  use: (user, target) ->
    return false unless @isAvailable(user, target)
    result = @effect(user, target)
    result ? @count += 1 : @miss_count += 1
    @lost(user)
    result

  # 消費処理
  # user: rpg.Actor
  lost: (user) ->
    if @lostFunc()
      user.lostItem(@)

  # 利用できるかどうか
  isAvailable: (user,target)->
    # TODO: return false if user.hasItem(@)
    return false if @lostFunc()

  # lost_xxx のメソッドは、使用回数等の消費する条件を判定するためのもので
  # アイテムの状態を変更しちゃだめ。

  # 回数制限の消費アイテム
  lost_count: ->　(@lostParam <= @count)
