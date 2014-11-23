
# エフェクトクラス

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

ITEM_SCOPE = rpg.constants.ITEM_SCOPE

# ゲーム内の効果をまとめたクラス
class rpg.Effect

  # コンストラクタ
  constructor: (args={}) ->
    {
      @name
      @scope
      @effects
    } = {
      scope: {
        type: ITEM_SCOPE.TYPE.FRIEND
        range: ITEM_SCOPE.RANGE.ONE
        hp0: false
      }
      effects: []
    }.$extendAll args

  ###* スコープ range の確認
  * @param {rpg.Battler} user 使用者
  * @param {Array} target 対象者(rpg.Battler配列)
  * @return {boolean} スコープ外だったら、false
  * @private
  ###
  _checkScopeRange: (user, targets) ->
    (@scope.range == ITEM_SCOPE.RANGE.ONE and targets.length == 1) or
    (@scope.range == ITEM_SCOPE.RANGE.MULTI)

  ###* スコープ type の確認
  * @param {rpg.Battler} user 使用者
  * @param {rpg.Battler} target 対象者
  * @return {boolean} スコープ外だったら、false
  * @private
  ###
  _checkScopeType: (user, target) ->
    if @scope.type == ITEM_SCOPE.TYPE.FRIEND
      return user.iff(target)
    if @scope.type == ITEM_SCOPE.TYPE.ENEMY
      return ! user.iff(target)
    true

  ###* 効果メソッド
  * @param {rpg.Battler} user 使用者
  * @param {Array} target 対象者(rpg.Battler配列)
  * @param {Object} log 効果ログ情報
  * @return {boolean} 効果ある場合 true
  ###
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
    
    return false unless @_checkScopeRange(user, targets)
    for t in targets when @_checkScopeType(user, t)
      r = @runArray(user, t, @effects, log) or r
    r

  ###* 攻撃コンテキストの取得
  * @param {rpg.Battler} user 攻撃者
  * @return {Object} 攻撃コンテキスト
  ###
  attackContext: (user) ->
    atkcx = {
      damage: 0 # ダメージ値
      attrs: [] # ダメージ属性
    }
    for e in @effects
      for type, op of e
        if type is 'damage'
          atkcx.damage += rpg.utils.jsonExpression(op,user:user)
        if type is 'attrs'
          atkcx.attrs.push a for a in op
    return atkcx

  ###* ダメージ計算
  * @return {Object} ダメージコンテキスト
  ###
  damage: (user, target, log ={}) ->
    ret = {
      damage: 0 # ダメージ値
      attrs: [] # ダメージ属性
    }
    return ret


  runUser: (user, targets, effects, log) ->
    targets = if Array.isArray targets then targets else [targets]
    res = {}
    # TODO: effects.target 配列と、targets 配列を１：１で適用するパターンもほしいかも
    for target in targets
      @runArray user, target, effects.target, res
    log.targets = res.targets
    res = {}
    # 使用者が自分で、自分に影響がある場合
    @runArray user, user, effects.user, res
    log.users = res.targets

  runArray: (user, target, effects, log) ->
    r = false
    for e in effects
      for type, op of e
        r = @run type, user, target, op, log or r
    r
  run: (type, user, target, op, log) -> @_effects[type].call @, op, user, target, log
  hp: (user, target, op, log) -> @run 'hp', user, target, op, log
  mp: (user, target, op, log) -> @run 'mp', user, target, op, log

  # 能力変化系(hp/mp)関連エフェクト
  _effect_attr: (attr, op, user, target, log) ->
    r = false
    val = target[attr] # 変化前の値
    target[attr] += rpg.utils.jsonExpression(op,base:target[attr])
    val = target[attr] - val # 変化した量を計算
    r = val != 0 or r
    log.targets = [] unless log.targets?
    if r # 効果があったら結果を保存
      o = {}
      o.name = target.name
      o[attr] = val
      log.targets.push o # 結果に保存
    r

  _effects: {
    # 効果
    # 基本的に、effect 以外では、user と target の状態は変化させない。
    # （使ったアイテムを減らす等は、Actor側の処理で）
    # 参照はあり
    # user: rpg.Actor
    # target: rpg.Actor or Array<rpg.Actor>
    # return: 効果あり true
    default: (op, user, target, log) -> false

    # HP効果
    hp: (op, user, target, log) -> @_effect_attr('hp', op, user, target, log)
    # MP効果
    mp: (op, user, target, log) -> @_effect_attr('mp', op, user, target, log)
    # ステート効果
    state: (op, user, target, log) ->
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
  }
