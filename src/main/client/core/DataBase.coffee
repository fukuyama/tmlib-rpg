
# データベースクラス
tm.define 'rpg.DataBase',

  # 初期化
  init: (args={}) ->
    href = document.location.href
    i = href.lastIndexOf('/')
    {
      @baseUrl
      @dataPath
      @idformat
      # アイテム
      @itemPath
      @items
      # マップ
      @mapPath
      @maps

    } = {
      baseUrl: href.substr(0,i) + '/'
      dataPath: 'data/'
      idformat: '000'
      itemPath: 'item/'
      items: {}
      mapPath: 'map/'
      maps: {}
    }.$extend args
    
  loadAssets: (assets,onload) ->
    setTimeout(
      (->rpg.system.loadAsset(assets, onload)).bind @
      100
    )

  filename: (val) ->
    if typeof val is 'number'
      val = val.formatString @idformat
    val

  # アイテムURL
  itemUrl: (item) ->
    @baseUrl + @dataPath + @itemPath + @filename(item) + '.json'

  # アイテムデータ
  item: (items,func) ->
    assets = (@itemUrl(item) for item in items)
    onload = () ->
      items = []
      for asset in assets
        data = tm.asset.AssetManager.get(asset).data
        data.item = asset
        @items[data.item] = data
        type = data.type ? 'Item'
        items.push new rpg[type](data) if rpg[type]?
      func(items)
    @loadAssets assets, onload.bind @

  # マップURL
  mapUrl: (map) ->
    @baseUrl + @dataPath + @mapPath + @filename(map) + '.json'

  #　マップデータ
  map: (map,func) ->
    url = @mapUrl(map)
    if @maps[url]?
      func(new rpg.Map @maps[url])
      return
    onload = () ->
      data = tm.asset.AssetManager.get(url).data
      data.map = url
      @maps[data.map] = data
      @loadAssets(
        (tile.image for tile in data.tilesets)
        (->func(new rpg.Map(data))).bind @
      )
    @loadAssets [url], onload.bind @
