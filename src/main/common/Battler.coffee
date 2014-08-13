###*
* @file Battler.coffee
* バトラークラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# バトラークラス
class rpg.Battler

  ###*
  * コンストラクタ
  * @classdesc バトラークラス
  *　ゲーム内に現れるキャラクターデータのクラス（アクターとエネミーの基底クラス）
  *　各キャラクター（アクターとエネミー含む）の基本的な能力を提供する。
  *　ゲーム初期状態でのデータは、json で管理（読み込みは外部で…）
  * @constructor rpg.Battler
  * @param {Object} args
  ###
  constructor: (args={}) ->
    @setup(args)

  ###* プロパティ追加用内部メソッド
  * @method rpg.Battler#_addProperties
  * @param {Object} p getter/setter用プロパティ
  * @param {String} name プロパティ名
  * @param {Any} defaultval プロパティのデフォルト値
  * @private
  ###
  _addProperties: (p,name,defaultval) ->
    get = -> if p[name]? then p[name] else defaultval
    set = (v) -> p[name] = v
    Object.defineProperty @,name,
      enumerable: false
      get: get.bind @
      set: set.bind @

  ###* args を使って初期化する
  * @method rpg.Battler#setup
  * @param {Object} args
  ###
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
        basehp: 10 # HP
        basemp: 10 # MP
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

  ###* ステート追加
  * @method rpg.Battler#addState
  * @param {rpg.State} args
  * @return this
  ###
  addState: (state) ->
    # 追加確認
    if state.checkAddTo @states
      @states.push state
    else
      # 相殺確認
      r = state.findCancels @states
      if r.length > 0
        @removeState r
    @

  ###* ステート削除
  * @method rpg.Battler#removeState
  * @param {String|Array|rpg.State} args ステート(名)かステート(名)のリスト
  * @return this
  ###
  removeState: (args) ->
    name = args if typeof args is 'string'
    name = args.name if typeof args is 'object'
    if name?
      @states = (s for s in @states when s.name != name)
    else if args instanceof Array
      @removeState a for a in args
    @

  ###* 敵味方識別
  * 味方だと true を返す
  * チームが違うと敵
  * IFFは、思いをくまない。呪文とかの対象になるかどうかなので実際につかうかどうかはプレイヤー判断。
  * かけたくない相手でも、状況的にかかる相手ならかかる。
  * @method rpg.Battler#iff
  * @param {rpg.Battler} battler 識別対象バトラー
  ###
  iff: (battler) ->
    r = false
    r = battler.team == @team unless r
    # 混乱していると敵？魅了された場合は？
    r

  ###* １ターンもしくは、１歩ごとに実行される処理
  * @method rpg.Battler#apply
  ###
  apply: () ->
    s.apply(target:@) for s in @states
    @

  ###* アイテムを使う
  * @method rpg.Battler#useItem
  * @param {rpg.Item} 使用するアイテム
  * @param {rpg.Battler|Array} アイテムを使用する対象
  ###
  useItem: (item, target) ->
    item.use @, target
