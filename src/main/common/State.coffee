###*
* @file State.coffee
* ステートクラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# ステートクラス
class rpg.State

  ###*
  * コンストラクタ
  * @classdesc ステートクラス
  * @constructor rpg.State
  * @param {Object} args
  ###
  constructor: (args={}) ->
    {
      @url
      @name
      @action
      @think
      @valid
      @applyCount
      @overlap
      @abilities
      @guards
      @damages
      @attrs
      @applies
      @remove
      @cancel
    } = {
      url: ''       # ID(URL)
      name: ''      # 名前
      action: {}    # 行動可否
      think: true   # 行動を考える事が出来るかどうか（コマンドインプット）
      valid: true   # 有効無効フラグ
      applyCount: 0 # 更新回数
      overlap: 1    # 重複数
      abilities: [] # 能力変化
      guards: []    # ステートガード
      damages: []   # ダメージ変化
      attrs: []     # 属性ステート
      applies: []   # 定期実行系
      remove: {}    # 削除条件
      cancel: {}    # 相殺するステート情報
    }.$extendAll args
  
  ###* キャンセルステートがあるかどうか
  * @method rpg.State#hasCancel
  * @return {boolean} キャンセルステートがある場合 true
  ###
  hasCancel: ->
    if @cancel.states?
      return @cancel.states.length != 0
    false

  ###* 属性の取得
  * @method rpg.State#_attr
  * @param {Object} param
  * @param {String} param.type 攻撃属性か防御属性か ('attack'|'defence')
  * @param {Object} param.attackContext 攻撃コンテキスト
  * @return {Array} 属性の配列
  * @private
  ###
  _attr: (param={}) ->
    {type,attackContext} = param
    r = []
    for attr in @attrs when attr[type]?
      as = attr[type]
      cond = true
      if as.cond?
        cond = (a for a in attackContext.attrs when as.cond == a).length != 0
      if cond # 攻撃条件がある場合
        r.push as.attr
    r

  ###* 攻撃属性の取得
  * @method rpg.State#attackAttr
  * @param {Object} atkcx 攻撃コンテキスト
  * @return {Array} 属性の配列
  ###
  attackAttr: (atkcx) -> @_attr(type:'attack',attackContext:atkcx)

  ###* 防御属性の取得
  * @method rpg.State#defenceAttr
  * @param {Object} atkcx 攻撃コンテキスト
  * @return {Array} 属性の配列
  ###
  defenceAttr: (atkcx) -> @_attr(type:'defence',attackContext:atkcx)

  ###* ダメージ変化
  * @method rpg.State#_damage
  * @param {String} type 攻撃属性か防御属性か ('attack'|'defence')
  * @param {Object} atkcx 攻撃コンテキスト
  * @param {Array} 対象属性の配列
  * @return {number} ダメージ変化量
  * @private
  ###
  _damage: (type,atkcx,tgtattrs) ->
    r = 0
    for d in @damages when d[type]?
      ds = d[type]
      cond = true
      if ds.cond?
        cond = (a for a in atkcx.attrs when ds.cond == a).length != 0
      if cond # 攻撃条件がある場合
        if ds.attr? # 対象属性が指定されてる場合
          # 対象属性が指定属性に一致しているか見る
          for a in tgtattrs when ds.attr == a
            r += rpg.utils.jsonExpression(ds.exp, atkcx)
        else # 対象属性が指定されてない場合
          # すべて適用
          r += rpg.utils.jsonExpression(ds.exp, atkcx)
    r

  ###* 攻撃ダメージ変化
  * @method rpg.State#attackDamage
  * @param {Object} atkcx 攻撃コンテキスト
  * @param {Object} defcx 防御コンテキスト
  * @return {number} ダメージ変化量
  ###
  attackDamage: (atkcx,defcx) -> @_damage('attack',atkcx,defcx.attrs)

  ###* 防御ダメージ変化
  * @method rpg.State#defenceDamage
  * @param {Object} atkcx 攻撃コンテキスト
  * @param {Object} defcx 防御コンテキスト
  * @return {number} ダメージ変化量
  ###
  defenceDamage: (atkcx,defcx) -> @_damage('defence',atkcx,atkcx.attrs)

  ###* 能力変化
  * @method rpg.State#ability
  * @param {Object} param
  * @param {number} param.base 基本値
  * @param {String} param.ability 能力
  * @return {number} 能力変化量
  ###
  ability: (param={}) ->
    {ability,base} = param
    r = 0
    for a in @abilities when a[ability]?
      r += rpg.utils.jsonExpression(a[ability], {base:base,state:@})
    r
  
  ###* ステートガード
  * @method rpg.State#stateGuard
  * @param {Object} param
  * @param {number} param.base 基本値
  * @param {String} param.name ステート名
  * @return {number} ガード確率値
  ###
  stateGuard: (param={}) ->
    {name,base} = param
    r = 0
    for a in @guards when a[name]?
      r += rpg.utils.jsonExpression(a[name], {base:base,state:@})
    r

  ###* 定期変化
  * @method rpg.State#apply
  * @param {Object} param
  * @param {Object} param.target 変化対象オブジェクト
  ###
  apply: (param={}) ->
    {target} = param
    for ap in @applies
      for k,v of ap when target[k]?
        target[k] += rpg.utils.jsonExpression(v, {base:target[k],state:@})
    @applyCount += 1
    @
  
  ###* 行動確認
  * @method rpg.State#checkAction
  * @return {boolean} 行動できる場合 true
  ###
  checkAction: () ->
    if @action.rate?
      if @action.rate == 100
        return false
      if Math.random() * 100 <= @action.rate
        return false
    true
  
  ###* キャンセル確認
  * @method rpg.State#checkCancel
  * @param {rpg.State} state 相殺されるかどうか調べるステート
  * @return {boolean} 相殺されるステートの場合 true
  ###
  checkCancel: (state) ->
    if @hasCancel()
      for cs in @cancel.states
        if cs == state.name
          return true
    if state.hasCancel()
      return state.checkCancel @
    false

  ###* 追加確認
  * @method rpg.State#checkAddTo
  * @param {Object|Array} param
  * @param {Array} param.states ステートの配列
  * @return {boolean} 追加可能な場合 true
  ###
  checkAddTo: (param={}) ->
    states = param if param instanceof Array
    {states} = param unless states?
    return true unless states?
    return true if states.length == 0
    len = 0
    for s in states
      if s.name == @name
        len += 1
      if @checkCancel s
        return false
    return len < @overlap
    
  ###* 削除確認
  * @method rpg.State#checkRemove
  * @param {Object} param
  * @param {boolean} param.battleEnd 戦闘終了時 true
  * @param {Object} param.attack 攻撃コンテキスト
  * @return {boolean} 削除可能な場合 true
  ###
  checkRemove: (param={}) ->
    unless @valid
      return true
    {battleEnd,attack} = param
    # 解除確率がある場合
    if @remove.rate?
      if Math.random() * 100 > @remove.rate
        return false
    # 戦闘終了時解除
    if battleEnd? and @remove.battle?
      @valid = false
      return true
    # 被ダメージ時解除
    ra = @remove.attack
    if attack? and ra?
      atkcx = attack
      if atkcx.hp >= ra.hp
        for a in atkcx.attrs when a == ra.attr
          @valid = false
          return true
    # 時間解除
    if @remove.apply?
      if @applyCount >= @remove.apply
        @valid = false
        return true
    false

  ###* 相殺ステートを探す
  * @method rpg.State#findCancels
  * @param {Array} states
  ###
  findCancels: (states=[]) ->
    r = []
    for s in states when @checkCancel s
      r.push s
    r
