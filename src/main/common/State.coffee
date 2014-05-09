
# ステートクラス
#

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# ステートクラス
class rpg.State

  # 初期化
  constructor: (args={}) ->
    {
      @state
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
      state: ''     # ID(URL)
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
  
  # キャンセルステートがあるかどうか
  hasCancel: ->
    if @cancel.states?
      return @cancel.states.length != 0
    false

  # 属性の取得
  attr: (param={}) ->
    {type,attackContext}=param
    r = []
    for att in @attrs when att[type]?
      as = att[type]
      cond = true
      if as.cond?
        cond = (a for a in attackContext.attrs when as.cond == a).length != 0
      if cond # 攻撃条件がある場合
        r.push as.attr
    r
  attackAttr: (atkcx) -> @attr(type:'attack',attackContext:atkcx)
  defenceAttr: (atkcx) -> @attr(type:'defence',attackContext:atkcx)

  # ダメージ変化
  damage: (type,atkcx,tgtattrs) ->
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
            r += rpg.utils.effectVal(atkcx.damage,ds)
        else # 対象属性が指定されてない場合
          # すべて適用
          r += rpg.utils.effectVal(atkcx.damage,ds)
    r
  attackDamage: (atkcx,defcx) -> @damage('attack',atkcx,defcx.attrs)
  defenceDamage: (atkcx,defcx) -> @damage('defence',atkcx,atkcx.attrs)

  # 能力変化
  ability: (param={}) ->
    r = 0
    for a in @abilities when a[param.ability]?
      r += rpg.utils.effectVal(param.base,a[param.ability])
    r
  
  # ステートガード
  stateGuard: (param={}) ->
    r = 0
    for a in @guards when a[param.name]?
      r += rpg.utils.effectVal(param.base,a[param.name])
    r

  # 定期変化
  apply: (param={}) ->
    {target}=param
    for ap in @applies
      for k,v of ap when target[k]?
        target[k] += rpg.utils.effectVal(target[k],v)
    @applyCount += 1
    @
  
  # 行動確認
  # 行動できない場合 false
  checkAction: () ->
    if @action.rate?
      if @action.rate == 100
        return false
      if Math.random() * 100 <= @action.rate
        return false
    true
  
  # キャンセル確認
  checkCancel: (state) ->
    if @hasCancel()
      for cs in @cancel.states
        if cs == state.name
          return true
    if state.hasCancel()
      return state.checkCancel @
    false

  # 追加確認
  checkAddTo: (param={}) ->
    {states} = param
    return true unless states?
    return true if states.length == 0
    len = 0
    for s in states
      if s.name == @name
        len += 1
      if @checkCancel s
        return false
    return false if len >= @overlap
    true
    
  # 削除チェック
  checkRemove: (param={}) ->
    unless @valid
      return true
    {battleEnd,attack}=param
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
      if atkcx.damage >= ra.damage
        for a in atkcx.attrs when a == ra.attr
          @valid = false
          return true
    # 時間解除
    if @remove.apply?
      if @applyCount >= @remove.apply
        @valid = false
        return true
    false

  # 相殺ステートを探す
  findCancels: (states=[]) ->
    r = []
    for s in states when @checkCancel s
      r.push s
    r
