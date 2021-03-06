
# エフェクトクラス

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

{
  SCOPE
  USABLE
} = rpg.constants

### ゲーム内の効果をまとめたクラス
user/target の Battler オブジェクトに対しての
rpg.utils.jsonExpression のリストを反映する

message は、イベントコマンドのリスト
message:
  ok: [] # 効果があった場合のイベントコマンド
  ng: [] # 効果が無かった場合のイベントコマンド
TODO: 基本的に戦闘時とフィールド時で同じイベントで良いか？

###
class rpg.Effect

  # コンストラクタ
  constructor: (args={}) ->
    {
      @url
      @help
      @message
      usable
      @scope
      @_usable
      @_effect
    } = {
      url:     'url' # ID(URL)
      help:    null  # ヘルプテキスト
      message: null  # ログメッセージテンプレート
      usable: USABLE.NONE # 戦闘中かマップ上で使えるかどうか
      scope:
        type: SCOPE.TYPE.FRIEND
        range: SCOPE.RANGE.ONE
        hp0: false
      _usable: null
      _effect: null
    }.$extendAll args

    unless @_usable?
      @_usable = usable

    # rpg.utils.jsonExpression に使用する式の集合
    unless @_effect?
      @_effect = {}
      for n in ['user','target','users','targets'] when args[n]?
        @_effect[n] = args[n]

  ###* スコープ range の確認
  * @param {rpg.Battler} user 使用者
  * @param {Array} target 対象者(rpg.Battler配列)
  * @return {boolean} スコープ外だったら、false
  * @private
  ###
  _checkScopeRange: (user, targets) ->
    (@scope.range == SCOPE.RANGE.ONE and targets.length == 1) or
    (@scope.range == SCOPE.RANGE.MULTI)

  ###* スコープ type の確認
  * @param {rpg.Battler} user 使用者
  * @param {rpg.Battler} target 対象者
  * @return {boolean} スコープ外だったら、false
  * @private
  ###
  _checkScopeType: (user, target) ->
    if @scope.type == SCOPE.TYPE.FRIEND
      return user.iff(target)
    if @scope.type == SCOPE.TYPE.ENEMY
      return ! user.iff(target)
    true

  ###* コンテキスト作成
  * @param {Object} cx コンテキスト
  * @param {Array} effects エフェクト配列
  * @param {Object} param 計算時のパラメータ
  * @return {Object} コンテキスト
  ###
  _makeContext: (cx,effects,param) ->
    for e in effects
      for type, op of e
        if type is 'attrs'
          cx.attrs.push a for a in op
        else if type is 'state'
          cx.states = [] unless cx.states?
          cx.states.push op
        else
          n = rpg.utils.jsonExpression(op,param)
          if cx[type]? then cx[type] += n else cx[type] = n
    return cx

  ###* 効果メソッド
  * @param {rpg.Battler} user 使用者
  * @param {Array} target 対象者(rpg.Battler配列)
  * @param {Object} log 効果ログ情報
  * @return {Object} 結果
  ###
  effect: (user,targets = []) ->
    cx = {
      user:
        attrs: []
      targets: []
    }
    param = {
      user: user
      targets: targets
    }
    return cx unless @_checkScopeRange(user, targets)
    # 使用者に対する効果
    if @_effect.user?
      @_makeContext(cx.user,@_effect.user.effects,param)
    # 対象者に対する効果
    if @_effect.target?
      for t in targets when @_checkScopeType(user, t)
        param.target = t
        cxt = {attrs:[]}
        @_makeContext(cxt,@_effect.target.effects,param)
        for a in user.attackAttrs(cxt)
          cxt.attrs.push a
        cx.targets.push cxt
        cx.target = cxt
    return cx

  effectApply: (user,targets = [],log = {},cx = null) ->
    r = false
    log.user = {
      name: user.name # 使った人
    }
    log.targets = [] # 誰がどれくらいの効果だったか
    # TODO: effect と target の組み合わせのリザルトをどうするか…悩み中
    return r unless @_checkScopeRange(user, targets)
    cx = @effect(user,targets) unless cx?
    i = 0
    for t in targets when @_checkScopeType(user, t)
      r = @contextApply(t, cx.targets[i], log) or r
      i++
    @contextApply(user, cx.user) if r
    r

  contextApply: (target,atkcx,log={user:{},targets:[]}) ->
    r = false
    defcx = {attrs:target.attrs}
    # TODO: 属性効果の適用
    for type, val of atkcx when type isnt 'attrs'
      if type is 'states'
        for op in val
          # TODO: 確率(rate)をつける？
          if op.type == 'add'
            state = rpg.system.db.state(op.name)
            target.addState(state)
            log.targets.push {
              name: target.name
              state:
                type: 'add'
                name: op.name
            }
            r = true
          if op.type == 'remove'
            target.removeState(name:op.name)
            log.targets.push {
              name: target.name
              state:
                type: 'remove'
                name: op.name
            }
            r = true
      else
        val = Math.round val
        m = type.match /(.*)damage/
        if m?
          type = m[1]
          val *= -1
        v1 = target[type]
        target[type] += val
        val = target[type] - v1
        if val != 0
          lt = {name:target.name}
          if log.targets.length == 0
            log.targets.push lt
          t = log.targets[log.targets.length - 1]
          if lt.name is t.name
            lt = t
          else
            log.targets.push lt
          lt[type] = if lt[type]? then lt[type] - val else val
          r = true
    r


_uf = []
_uf[USABLE.NONE]    = -> false
_uf[USABLE.ALL]     = -> true
_uf[USABLE.MAP]     = -> not rpg.system.temp.battle
_uf[USABLE.BATTLE]  = -> rpg.system.temp.battle
Object.defineProperty rpg.Effect.prototype, 'usable',
  enumerable: false
  get: -> _uf[@_usable].call @

### ヘルプテキストのキャッシュ
Effectインスタンスの url をキーに、help をキャッシュする（上書きなし）
###
_helpCache = {}
Object.defineProperty rpg.Effect.prototype, 'help',
  enumerable: true
  get: ->
    _helpCache[@url] ? ''
  set: (h) ->
    unless h?
      return
    unless _helpCache[@url]?
      _helpCache[@url] = h

### メッセージテンプレートのキャッシュ
Effectインスタンスの url をキーに、message をキャッシュする（上書きなし）
###
_messageCache = {}
Object.defineProperty rpg.Effect.prototype, 'message',
  enumerable: true
  get: ->
    _messageCache[@url] ? ''
  set: (msg) ->
    unless msg?
      return
    unless _messageCache[@url]?
      _messageCache[@url] = msg
