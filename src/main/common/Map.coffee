# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

MOVE_RESTRICTION = rpg.constants.MOVE_RESTRICTION

class rpg.Map

  constructor: (args={}) ->
    @setup(args)

  setup: (@mapSheet={}) ->
    # マップ幅
    Object.defineProperty @, 'width',
      get: -> @mapSheet.width
    # マップ高さ
    Object.defineProperty @, 'height',
      get: -> @mapSheet.height

  #　マップ範囲内かどうか
  isValid: (x, y) -> 0 <= x and x < @width and 0 <= y and y < @height

  # 移動可能判定
  isPassable: (x, y, d, character = null) ->
    r = @_restriction(x,y,character)
    r[d / 2 - 1]

  # 移動制限情報の取得
  _restriction: (x, y, character = null) ->
    # プレイヤーの位置確認
    res = @_restrictionPlayer(x, y, character)
    return res if res isnt null
    # イベントから見つかったらそれを返す
    res = @_restrictionEvent(x, y, character)
    return res if res isnt null
    # TODO: マップ固有情報から見つかったらそれを返す

    # タイルセットから
    res = @_restrictionTileset(x, y)
    return res if res isnt null
    MOVE_RESTRICTION.ALLOK

  _restrictionTileset: (x, y) ->
    i = @mapSheet.layers.length - 1
    while i >= 0
      layer = @mapSheet.layers[i--]
      if layer.type == 'layer'
        tileid = layer.data[x + y * @width]
        if tileid >= 0
          return @mapSheet.tilesets[0].restriction[tileid]
    null

  _restrictionEvent: (x, y, character = null) ->
    event = @findCharacter(x, y, character)
    if event isnt null then MOVE_RESTRICTION.ALLNG else null

  _restrictionPlayer: (x, y, character = null) ->
    pc = @findPlayer(x, y, character)
    if pc isnt null then MOVE_RESTRICTION.ALLNG else null

  # 座標位置のプレイヤーを検索
  # character: 検索を行ったキャラクター
  findPlayer: (x, y, character = null) ->
    pc = rpg.system.player.character
    if pc? and
    pc isnt character and
    pc.mapX == x and pc.mapY == y
      pc
    else
      null

  # 座標位置のキャラクターを検索
  # character: 検索を行ったキャラクター
  findCharacter: (x, y, character = null) ->
    # プレイヤー位置確認
    pc = @findPlayer(x, y, character)
    return pc if pc isnt null
    # イベント位置確認
    for event in @events when event isnt character
      if event.mapX == x and event.mapY == y
        return event
    null

rpg.Map.preload = (loader, param, asset) ->
  for tile in param.tilesets
    key = tile.image
    src = rpg.system.assets[key]
    src = key unless src?
    loader.preload(key, src)
