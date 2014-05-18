
# データベースクラス
tm.define 'rpg.DataBase',

  # 初期化
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
    
    # アイテムURL
    @itemUrl = @dataUrl.bind(@,dataPath + itemPath)
    # マップURL
    @mapUrl = @dataUrl.bind(@,dataPath + mapPath)
    # ステートURL
    @stateUrl = @dataUrl.bind(@,dataPath + statePath)
    @states = {}

  filename: (val) ->
    if typeof val is 'number'
      val = val.formatString @idformat
    val

  # dataURL
  dataUrl: (path, id) ->
    if id?
      @baseUrl + path + '/' + @filename(id) + '.json'
    else
      @baseUrl + path + '.json'

  # アイテム作成
  createItem: (data) ->
    type = data.type ? 'Item'
    return new rpg[type](data)

  # アイテム一覧
  # TODO:いらないかも、全部取るのは難しい
  itemlist: (func) ->
    assets = [@itemUrl()]
    onload = () ->
      items = mgr.get(assets[0]).data
      func(items)
    rpg.system.loadAssets assets, onload.bind @

  # アイテムデータ
  item: (ids,func) ->
    mgr = tm.asset.Manager
    assets = (@itemUrl(id) for id in ids)
    items = (@createItem(mgr.get(a).data) for a in assets when mgr.get(a)?)
    if items.length == ids.length
      func(items)
      return
    onload = () ->
      items = []
      for asset in assets
        data = mgr.get(asset).data
        data.item = asset
        items.push @createItem(data)
      func(items)
    rpg.system.loadAssets assets, onload.bind @

  #　マップデータ
  map: (mapid,func) ->
    mgr = tm.asset.Manager
    url = @mapUrl(mapid)
    if mgr.get(mapid)?
      func(new rpg.Map(mgr.get(mapid).data))
      return
    onload = () ->
      data = mgr.get(url).data
      data.map = url
      rpg.system.loadAssets(
        (tile.image for tile in data.tilesets)
        (->func(new rpg.Map(data))).bind @
      )
    rpg.system.loadAssets [url], onload.bind @

  # ステート作成
  createState: (data) ->
    type = data.type ? 'State'
    return new rpg[type](data)

  # ステートデータ
  state: (ids,func) ->
    mgr = tm.asset.Manager
    if typeof ids is 'string'
      if func?
        return func [@createState(mgr.get(@states[ids]).data)]
      else
        return @createState(mgr.get(@states[ids]).data)
    else if typeof ids is 'number'
      ids = [ids]
    assets = (@stateUrl(id) for id in ids)
    states = (@createState(mgr.get(a).data) for a in assets when mgr.get(a)?)
    if states.length == ids.length
      func(states)
      return
    onload = () ->
      states = []
      for asset in assets
        data = mgr.get(asset).data
        data.state = asset
        states.push @createState(data)
        unless @states[data.name]?
          @states[data.name] = data.state
      func(states)
    rpg.system.loadAssets assets, onload.bind @
