###*
* @file DataBase.coffee
* データベース
* 今は、json を取るだけだけど、ＤＢ関連をまとめる？
* 基本的に、json とかの管理は、tmlib がしてくれるので、ここでは、クラスインスタンスへの変換（マッピング）をする
* そのまま引数にしてインスタンス化するだけだけど…
###

tm.define 'rpg.DataBase',
  ###* ベースURL
  * @var {String} rpg.DataBase#baseUrl
  ###
  ###* IDフォーマット
  * @var {String} rpg.DataBase#idformat
  ###

  ###* コンストラクタ
  * @classdesc データベースクラス
  * @constructor rpg.DataBase
  * @param {Object} args
  * @param {string} args.path.data データパス
  * @param {string} args.path.item アイテムパス
  * @param {string} args.path.map マップパス
  * @param {string} args.path.state ステートパス
  ###
  init: (args={}) ->
    href = document.location.href
    i = href.lastIndexOf('/')
    {
      @baseUrl
      @idformat
      path
    } = {
      baseUrl: href.substr(0,i) + '/'
      idformat: '000'
      path:
        data:   'data/'
        item:   'item/'
        weapon: 'weapon/'
        armor:  'armor/'
        map:    'map/'
        state:  'state/'
        actor:  'actor/'
    }.$extend args

    # メタ インタフェース
    @_metaif = {
      item:
        url: @_dataUrl.bind @, path.data + path.item
        create: @_create.bind @, 'Item'
      weapon:
        url: @_dataUrl.bind @, path.data + path.weapon
        create: @_create.bind @, 'Weapon'
      armor:
        url: @_dataUrl.bind @, path.data + path.armor
        create: @_create.bind @, 'Armor'
      actor:
        url: @_dataUrl.bind @, path.data + path.actor
        create: @_create.bind @, 'Actor'
    }

    # preload 用 公開メソッド
    @preloadItem   = @_preload.bind @, 'item'
    @preloadWeapon = @_preload.bind @, 'weapon'
    @preloadArmor  = @_preload.bind @, 'armor'
    @preloadActor  = @_preload.bind @, 'actor'

    @mapUrl   = @_dataUrl.bind @, path.data + path.map
    @stateUrl = @_dataUrl.bind @, path.data + path.state

    @_states = {} # ステートのキャッシュ

  _create: (klass,data) -> new rpg[data.type ? klass](data)

  ###* ファイル名の作成
  * @memberof rpg.DataBase#
  * @param {String|Number} val
  * @return {String} データのファイル名
  * @private
  ###
  _filename: (val) ->
    if typeof val is 'number'
      val = val.formatString @idformat
    val

  ###* データ読み込み用URLの作成
  * @memberof rpg.DataBase#
  * @param {String} path
  * @param {String|Number} [id]
  * @return {String} データをロードするためのURL
  * @private
  ###
  _dataUrl: (path, id=0) -> @baseUrl + path + @_filename(id) + '.json'

  _preload: (key,ids,func) ->
    mgr = tm.asset.Manager
    urls = for id in ids then @_metaif[key].url id
    if func?
      list = for url in urls when mgr.get(url)?
        @_metaif[key].create mgr.get(url).data
      if list.length == ids.length
        func(list)
        return
      onload = () ->
        list = []
        for url in urls
          m = mgr.get(url)
          if m?
            data = m.data
            data.url = url
            list.push @_metaif[key].create data
        if list.length != 0
          func(list)
      rpg.system.loadAssets urls, onload.bind @
    else
      rpg.system.loadAssets urls
    return

  ###* マップデータの読み込み
  * @memberof rpg.DataBase#
  * @param {Number|String} mapid マップID か ファイル名
  * @param {rpg.DataBase~mapcallback} func 読み込み後のコールバック関数
  ###
  preloadMap: (mapid,func) ->
    mgr = tm.asset.Manager
    url = @mapUrl mapid
    if mgr.get(url)?
      func(new rpg.Map(mgr.get(url).data))
      return
    onload = () ->
      m = mgr.get(url)
      if m?
        data = m.data
        func(new rpg.Map(data))
    rpg.system.loadAssets url, onload.bind @
    rpg.system.scene.on 'progress', (e) ->
      if e.key == url
        data = mgr.get(url).data
        data.url = url
        for tile in data.tilesets
          @addAssets tile.image
    return

  ###* ステートを作成
  * @memberof rpg.DataBase#
  * @param {Object} data ステート初期化用Object
  * @return {rpg.State}　ステートオブジェクト
  ###
  createState: (data) ->
    type = data.type ? 'State'
    return new rpg[type](data)

  ###* ステートの取得
  * @memberof rpg.DataBase#
  * @param {String|Number} name ステート名かID
  * @return {rpg.State} ステートオブジェクト
  ###
  state: (name) ->
    if typeof name is 'number'
      @createState(tm.asset.Manager.get(@stateUrl(name)).data)
    else
      @createState(tm.asset.Manager.get(@_states[name]).data)

  ###* ステートの読み込み
  * @memberof rpg.DataBase#
  * @param {Array} ids ステートデータのID / ファイル名の配列
  * @param {rpg.DataBase~statecallback} func 読み込み後のコールバック関数
  ###
  preloadStates: (ids,func) ->
    mgr = tm.asset.Manager
    urls = (@stateUrl(id) for id in ids)
    states = (@createState(mgr.get(a).data) for a in urls when mgr.get(a)?)
    if states.length == ids.length
      func(states)
      return
    onload = () ->
      states = []
      for url in urls
        data = mgr.get(url).data
        data.url = url
        states.push @createState(data)
        @registState(data)
      func(states)
    rpg.system.loadAssets urls, onload.bind @
    return

  ###* ステートの登録
  * @memberof rpg.DataBase#
  * @param {Object} data rpg.State を作成するための json data
  ###
  registState: (data) ->
    data.type = 'State' unless data.type?
    unless tm.asset.Manager.get(data.url)?
      tm.asset.Manager.set data.url, data:data
    unless @_states[data.name]?
      @_states[data.name] = data.url
    return

  ###* まとめてアイテムのロード
  * @memberof rpg.DataBase#
  * @param {Object} args
  * @param {rpg.DataBase~preloaditemscallback} callback
  ###
  preloadItems: (args,callback) ->
    {
      items
      weapons
      armors
    } = {
      items: []
      weapons: []
      armors: []
    }.$extend args
    endCount = 0
    endCount++ if items.length != 0
    endCount++ if weapons.length != 0
    endCount++ if armors.length != 0
    count = 0
    allitems = []
    _loadcheck = (items) ->
      count += 1
      allitems = allitems.concat items
      if count == endCount
        callback(allitems)
    @preloadItem   items,   _loadcheck if items.length != 0
    @preloadWeapon weapons, _loadcheck if weapons.length != 0
    @preloadArmor  armors,  _loadcheck if armors.length != 0


###* ステート読み込み時のコールバック関数
* @callback rpg.DataBase~statecallback
* @param {Array} states 読み込んだステートデータ(json)
###

###* マップ読み込み時のコールバック関数
* @callback rpg.DataBase~mapcallback
* @param {rpg.Map} map 読み込んだマップデータ(json)
###

###* アイテム読み込み時のコールバック関数
* @callback rpg.DataBase~itemcallback
* @param {Array} items 読み込んだアイテムデータ(json)
###
