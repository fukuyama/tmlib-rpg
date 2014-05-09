
# バトラークラス
#
#　ゲーム内に現れるキャラクターデータのクラス（アクターとエネミーの基底クラス）
#　各キャラクター（アクターとエネミー含む）の基本的な能力を提供する。
#　ゲーム初期状態でのデータは、json で管理（読み込みは外部で…）
#

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# バトラークラス
class rpg.Battler

  _addProperties: (p,name,defaultval) ->
    get = -> if p[name]? then p[name] else defaultval
    set = (v) -> p[name] = v
    Object.defineProperty @,name,
      enumerable: false
      get: get.bind @
      set: set.bind @

  constructor: (args={}) ->
    @setup(args)

  setup: (args={}) ->
    {
      _base
      base
      @properties
      states
    } = {
      _base: null
      base: {
        str: 10 # ちから
        vit: 10 # たいりょく
        dex: 10 # きようさ
        agi: 10 # すばやさ
        int: 10 # かしこさ
        sen: 10 # かんせい
        luc: 10 # うんのよさ
        cha: 10 # みりょく
        basehp: 10
        basemp: 10
      }
      properties: {}
      states: []
    }.$extendAll(args)
    @_base = _base ? base # _base が指定されたらそちらを優先

    @addProperties = @_addProperties.bind(@,@properties)
    @addProperties('name', '？？？')
    @addProperties('team', '？？？')

    {
      @name
      @team
    } = {}.$extendAll(@properties).$extendAll(args)

    # TODO: あとでバフ計算が必要になると思う
    _ability = (nm) ->
      r = @_base[nm]
      for s in states
        r += s.ability(base:@_base[nm], ability:nm)
      r

    for nm of @_base
      Object.defineProperty @, nm,
        enumerable: false
        get: _ability.bind(@,nm)

    Object.defineProperty @, 'patk',
      enumerable: false
      get: -> Math.floor(@str + @dex / 2)
    Object.defineProperty @, 'pdef',
      enumerable: false
      get: -> Math.floor(@vit + @agi / 2)
    Object.defineProperty @, 'matk',
      enumerable: false
      get: -> Math.floor(@int + @sen / 2)
    Object.defineProperty @, 'mcur',
      enumerable: false
      get: -> Math.floor(@sen + @int / 2)
    Object.defineProperty @, 'mdef',
      enumerable: false
      get: -> Math.floor(@luc / 2 + @sen / 2 + @int / 2)

    Object.defineProperty @, 'maxhp',
      enumerable: false
      get: -> Math.floor(@basehp + @vit + @str / 2 + @luc / 2)
    Object.defineProperty @, 'maxmp',
      enumerable: false
      get: -> Math.floor(@basemp + @int / 2 + @sen / 2 + @luc / 2)

    _currenthp = @maxhp
    _currentmp = @maxmp

    Object.defineProperty @, 'hp',
      enumerable: true
      get: -> _currenthp
      set: (n) ->
        n = @maxhp if n > @maxhp
        _currenthp = n
    Object.defineProperty @, 'mp',
      enumerable: true
      get: -> _currentmp
      set: (n) ->
        n = @maxmp if n > @maxmp
        _currentmp = n

    Object.defineProperty @, 'states',
      enumerable: true
      get: -> states
      set: (s) -> states = s

  # ステート追加
  addState: (state) ->
    # 追加確認
    if state.checkAddTo @states
      @states.push state
    else
      # 相殺確認
      r = state.findCancels @states
      if r.length > 0
        @removeState states:r
    @

  # ステート削除
  removeState: (param={}) ->
    {name,states}=param
    if name?
      t = []
      for s in @states when s.name != name
        t.push s
      @states = t
    @

  # 敵味方識別
  # 味方だと true を返す
  # チームが違うと敵
  # IFFは、思いをくまない。呪文とかの対象になるかどうかなので実際につかうかどうかはプレイヤー判断。
  # かけたくない相手でも、状況的にかかる相手ならかかる。
  iff: (battler) ->
    r = false
    r = battler.team == @team unless r
    # 混乱していると敵？魅了された場合は？
    r

  # １ターンもしくは、１歩ごとに実行される処理
  apply: () ->
    s.apply(target:@) for s in @states
    @

  # アイテムを使う
  useItem: (item, target) ->
    item.use @, target
