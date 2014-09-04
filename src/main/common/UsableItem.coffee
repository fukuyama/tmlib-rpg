
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
          r = @['effect_'+effectType].call(@, param, user, t, log) or r
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

  # 効果
  # 基本的に、effect 以外では、user と target の状態は変化させない。
  # （使ったアイテムを減らす等は、Actor側の処理で）
  # 参照はあり
  # user: rpg.Actor
  # target: rpg.Actor or Array<rpg.Actor>
  # return: 効果あり true
  effect_default: (op, user, target, log) -> false

  # ダメージ（回復）関連エフェクト
  effect_damage: (op, user, target, log) ->
    r = false
    attr = op.attr
    val = target[attr] # 変化前の値
    target[attr] += rpg.utils.effectVal(target[attr],op)
    val = target[attr] - val # 変化した量を計算
    r = val != 0 or r
    if r # 効果があったら結果を保存
      o = {}
      o.name = target.name
      o[attr] = val
      log.targets.push o # 結果に保存
    r

  # HP効果
  effect_hp: (op, user, target, log) ->
    op.attr = 'hp'
    @effect_damage(op, user, target, log)

  # MP効果
  effect_mp: (op, user, target, log) ->
    op.attr = 'mp'
    @effect_damage(op, user, target, log)

  # ステート効果
  effect_state: (op, user, target, log) ->
    # TODO: 確率(rate)をつける？
    if op.type == 'add'
      state = rpg.system.db.state(op.name)
      target.addState(state)
      log.targets.push state: {
        name: target.name
        type: 'add'
        state: state.name
      }
      return true
    if op.type == 'remove'
      target.removeState(name:op.name)
      log.targets.push state: {
        name: target.name
        type: 'remove'
        state: op.name
      }
      return true
    false

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
