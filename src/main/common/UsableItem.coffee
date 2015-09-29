
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
      @lost
    } = {
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

  ###* 効果メソッド
  * @param {rpg.Battler} user 使用者
  * @param {Array} target 対象者(rpg.Battler配列)
  * @return {Object} 効果コンテキスト
  ###
  effect: (user,targets = []) ->
    @_effect.effect(user,targets)

  ###* 効果メソッド
  * @param {rpg.Battler} user 使用者
  * @param {Array} target 対象者(rpg.Battler配列)
  * @param {Object} log 効果ログ情報
  * @return {boolean} 効果ある場合 true
  ###
  effectApply: (user,targets = [],log = {}) ->
    @_effect.effectApply(user,targets,log)

  # 使う
  # user: rpg.Actor
  # target: rpg.Actor or Array<rpg.Actor>
  use: (user, target, log = {}) ->
    return false if @isLost()
    r = @effectApply(user, [].concat(target), log)
    log.item = {name:@name}
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

Object.defineProperty rpg.UsableItem.prototype, 'scope',
  enumerable: true
  get: -> @_effect.scope
