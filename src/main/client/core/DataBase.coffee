###*
* @file DataBase.coffee
* データベース
* 今は、json を取るだけだけど、ＤＢ関連をまとめる？
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
  ###
  init: (args={}) ->
    href = document.location.href
    i = href.lastIndexOf('/')
    {
      @baseUrl
      @idformat
      dataPath   # データパス
      itemPath   # アイテムパス
      mapPath    # マップパス
      statePath  # ステートパス
    } = {
      baseUrl: href.substr(0,i) + '/'
      idformat: '000'
      dataPath: 'data/'
      itemPath: 'item'
      mapPath: 'map'
      statePath: 'state'
    }.$extend args
    
    @itemUrl = @_dataUrl.bind(@,dataPath + itemPath)
    @mapUrl = @_dataUrl.bind(@,dataPath + mapPath)
    @stateUrl = @_dataUrl.bind(@,dataPath + statePath)

    @_states = {} # ステートのキャッシュ

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
  _dataUrl: (path, id) ->
    if id?
      @baseUrl + path + '/' + @_filename(id) + '.json'
    else
      @baseUrl + path + '.json'

  ###* アイテムデータの作成
  * @memberof rpg.DataBase#
  * @param {Object} data アイテム初期化用Object
  * @return {rpg.State} アイテムオブジェクト
  ###
  createItem: (data) ->
    type = data.type ? 'Item'
    return new rpg[type](data)

  ###* アイテムデータの読み込み
  * @memberof rpg.DataBase#
  * @param {Array} ids アイテムデータのID / ファイル名の配列
  * @param {rpg.DataBase~itemcallback} func 読み込み後のコールバック関数
  ###
  preloadItem: (ids,func) ->
    mgr = tm.asset.Manager
    urls = (@itemUrl(id) for id in ids)
    items = (@createItem(mgr.get(a).data) for a in urls when mgr.get(a)?)
    if items.length == ids.length
      func(items)
      return
    onload = () ->
      items = []
      for url in urls
        data = mgr.get(url).data
        data.url = url
        items.push @createItem(data)
      func(items)
    rpg.system.loadAssets urls, onload.bind @
    return

  ###* マップデータの読み込み
  * @memberof rpg.DataBase#
  * @param {Number|String} mapid マップID か ファイル名
  * @param {rpg.DataBase~mapcallback} func 読み込み後のコールバック関数
  ###
  preloadMap: (mapid,func) ->
    mgr = tm.asset.Manager
    url = @mapUrl(mapid)
    if mgr.get(url)?
      func(new rpg.Map(mgr.get(url).data))
      return
    load = () ->
      data = mgr.get(url).data
      func(new rpg.Map(data))
    rpg.system.loadAssets url
    rpg.system.scene.on 'load', load.bind @
    rpg.system.scene.on 'progress', (e) ->
      if e.key == url
        data = mgr.get(url).data
        data.url = url
        @nextAssets = tile.image for tile in data.tilesets
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
