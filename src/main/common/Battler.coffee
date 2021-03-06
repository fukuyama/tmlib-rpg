###*
* @file Battler.coffee
* バトラークラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


BASE_ABILITIES = rpg.constants.BASE_ABILITIES

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
      @states
      skills
      @equips
      @equipsFix
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
      skills: []
      equips: {
        left_hand: null # 左手
        right_hand: null # 右手
        head: null # 頭
        upper_body: null # 体上
        lower_body: null # 体下
        arms: null # 腕
        legs: null # 脚
      }
      equipsFix: [] # 装備固定
    }.$extendAll(args)
    @_base = _base ? base # _base が指定されたらそちらを優先

    @addProperties = @_addProperties.bind(@,@properties)
    @addProperties('name', '？？？')
    @addProperties('team', '？？？')

    {
      @name
      @team
      @character
    } = {}.$extendAll(@properties).$extendAll(args)

    @_currenthp = @maxhp
    @_currentmp = @maxmp

    @skills = []
    load_skills = []
    for skill,i in skills
      if skill instanceof rpg.Skill
        @skills.push skill
      else
        load_skills.push skill
    loaded = args.loaded
    if load_skills.length != 0
      rpg.system?.db?.preloadSkill load_skills, ((skills) ->
        for skill in skills
          @skills.push skill
        loaded() if loaded?
        return
      ).bind @
    else
      loaded() if loaded?
    return

  ###* 能力計算
  * @method rpg.Battler#addState
  * @param {number} base 基準値
  * @param {string} nm 計算する能力名
  * @return {number} 計算結果
  * @private
  ###
  _ability: (base, nm) ->
    r = base
    # 装備アイテム
    for k, v of @equips when v?
      r += v.ability(base:base, ability:nm)
    # ステート
    for s in @states
      r += s.ability(base:base, ability:nm)
    r

  ###* 戦闘コマンドが入力可能か？
  * アクターかエネミーのクラスで上書きされる
  * @method rpg.Battler#isActionInput
  * @return {boolean} 入力可能ならtrue
  ###
  isActionInput: ->
    return true

  getStates: (state) ->
    if typeof state is 'string'
      state = rpg.system.db.state state
    return (s for s in @states when s.name is state.name)

  ###* ステート追加
  * @method rpg.Battler#addState
  * @param {rpg.State} args
  * @return this
  ###
  addState: (state) ->
    if typeof state is 'string'
      state = rpg.system.db.state state
    # 追加確認
    if state.checkAddTo @states
      @states.push state
    else
      # 相殺確認
      r = state.findCancels @states
      if r.length > 0
        @removeState r[0]
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
      states1 = []
      states2 = []
      for s in @states
        if s.name is name
          states1.push s
        else
          states2.push s
      states1.pop()
      @states = states2.concat states1
    else if args instanceof Array
      @removeState a for a in args
    @

  ###* 攻撃属性
  * @param {Object} atkcx 攻撃コンテキスト
  * @return {Array} 属性配列
  ###
  attackAttrs: (atkcx) ->
    # TODO: キャッシュした方が良いかも
    r = []
    for s in @states
      for a in s.attackAttr atkcx
        r.push a
    return r

  ###* 防御属性
  * @param {Object} atkcx 攻撃コンテキスト
  * @return {Array} 属性配列
  ###
  defenceAttrs: (atkcx) ->
    # TODO: キャッシュした方が良いかも
    r = []
    for s in @states
      for a in s.defenceAttr atkcx
        r.push a
    return r


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
  * @return {boolean} 使用した場合、true
  ###
  useItem: (item, target, log={}) ->
    item.use @, target, log

  ###* 装備確認
  * @method rpg.Battler#checkEquip
  * @param {string} equip 装備部位
  * @param {rpg.Item} item 装備するアイテム
  * @return {boolean} 装備可能な場合、true
  ###
  checkEquip: (equip, item) ->
    # 装備アイテムかどうか
    return false unless item instanceof rpg.EquipItem
    # 装備アイテムを装備するのに必要な部位が空いているかどうか
    for e in item.equips when @equips[e]?
      # 空いてない場合、装備が外せるかどうか
      return false unless @checkEquipOff e # １つでも外せない部位があるとダメ
    # アイテム自体が装備可能か調べる
    return item.checkEquip(equip) and item.checkRequired(@)

  ###* 装備解除確認
  * @method rpg.Battler#checkEquipOff
  * @param {string} equip 装備部位
  * @return {boolean} 装備が外せる場合、true
  ###
  checkEquipOff: (equip) ->
    # 元々装備してない部位の場合は、装備解除する必要なし。
    return true unless @equips[equip]?
    # 装備部位が固定化された部位の場合は、はずせない。
    return false for e in @equipsFix when e == equip
    # 呪われた装備等、装備の条件により外せない。
    return false unless @equips[equip].checkEquipOff(@)
    return true

  ###* 装備処理
  * @method rpg.Battler#_equipItem
  * @param {string} pos 装備部位
  * @param {rpg.EquipItem} item 装備アイテム。外す場合は、null
  * @private
  ###
  _equipItem: (pos,item=null) ->
    # 装備部位の装備が外せるかどうか
    return unless @checkEquipOff pos
    if item is null
      # 装備を外す
      @_equipItemOff pos
      return
    # 外せる場合いったん装備をはずす
    t = @equips[pos]
    @_equipItemOff pos
    # 装備条件確認
    if @checkEquip pos, item
      # 装備しようとしている部位を必要としている他の部位に装備された物がある場合それを外す
      for e1, v of @equips when v?
        for e2 in v.equips when pos is e2
          if @checkEquipOff e1
            @_equipItemOff e1
      # 両手武器等、複数個所で装備する物は、他の部位の装備をはずす
      for e in item.equips
        @_equipItemOff e
      # 装備可能な場合は、それを装備
      @_equipItemOn pos, item
    else
      # 装備できない場合は、元の装備に戻す
      @_equipItemOn pos, t
    return

  ###* 装備する
  * @param {string} pos 装備部位
  ###
  _equipItemOn: (pos, item) ->
    if item?
      @equips[pos] = item
      @addState s for s in item.states

  ###* 装備外す
  * @param {string} pos 装備部位
  ###
  _equipItemOff: (pos) ->
    if @equips[pos]?
      @removeState s for s in @equips[pos].states
    @equips[pos] = null

for ability in BASE_ABILITIES
  ((nm) ->
    Object.defineProperty rpg.Battler.prototype, nm,
      enumerable: false
      get: -> @_ability @_base[nm], nm
  )(ability)

Object.defineProperty rpg.Battler.prototype, 'patk',
  enumerable: false
  get: -> @_ability Math.floor(@str + @dex / 2), 'patk'
Object.defineProperty rpg.Battler.prototype, 'pdef',
  enumerable: false
  get: -> @_ability Math.floor(@vit + @agi / 2), 'pdef'
Object.defineProperty rpg.Battler.prototype, 'matk',
  enumerable: false
  get: -> @_ability Math.floor(@int + @sen / 2), 'matk'
Object.defineProperty rpg.Battler.prototype, 'mcur',
  enumerable: false
  get: -> @_ability Math.floor(@sen + @int / 2), 'mcur'
Object.defineProperty rpg.Battler.prototype, 'mdef',
  enumerable: false
  get: -> @_ability Math.floor(@luc / 2 + @sen / 2 + @int / 2), 'mdef'

Object.defineProperty rpg.Battler.prototype, 'maxhp',
  enumerable: false
  get: -> @_ability Math.floor(@basehp + @vit + @str / 2 + @luc / 2), 'maxhp'
Object.defineProperty rpg.Battler.prototype, 'maxmp',
  enumerable: false
  get: -> @_ability Math.floor(@basemp + @int / 2 + @sen / 2 + @luc / 2), 'maxmp'

Object.defineProperty rpg.Battler.prototype, 'hp',
  enumerable: true
  get: -> @_currenthp
  set: (n) ->
    n = @maxhp if n > @maxhp
    @_currenthp = n
Object.defineProperty rpg.Battler.prototype, 'mp',
  enumerable: true
  get: -> @_currentmp
  set: (n) ->
    n = @maxmp if n > @maxmp
    @_currentmp = n

# TODO: 両手は必要だけど、利き手はする？
EQUIP_POS = [
  {right_hand: 'weapon'}
  {left_hand: 'shield'}
  {left_hand: 'left_hand'}
  {right_hand: 'right_hand'}
  {head: 'head'}
  {upper_body: 'upper_body'}
  {lower_body: 'lower_body'}
  {arms: 'arms'}
  {legs: 'legs'}
]

for data in EQUIP_POS
  ((args) ->
    for k, v of args
      Object.defineProperty rpg.Battler.prototype, v,
        enumerable: false
        get: ->
          @equips[k]
        set: (item) ->
          @_equipItem k, item
  )(data)
