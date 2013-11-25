# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

MOVE_RESTRICTION = rpg.constants.MOVE_RESTRICTION

# dummy map data. テスト用
data = (->
  data = []
  x = y = 30
  for i in [0...(x*y)]
    r = Math.floor(Math.random() * 100)
    if r < 20
      data.push Math.floor(Math.random() * 15)
    else
      data.push 0
  data
)()
for x in [4..6]
  for y in [4..6]
    data[x+y*30] = 0
for x in [4..6]
  for y in [9..11]
    data[x+y*30] = 0
for x in [9..11]
  for y in [9..11]
    data[x+y*30] = 1
for x in [0..29]
  for y in [0,1,2]
    data[x+y*30] = 0
t = 2
for x in [0..29] when x % 2 == 1 and t <= 15
  for y in [1]
    data[x+y*30] = t++


ASSETS =
  'sample.map':
    type: 'json'
    src:
      mapSheet: 'sample.mapsheet'
  'sample.tileset': 'img/test_tileset.png'
  #'sample.autotile': 'img/sample_tileset.png'
  'sample.mapsheet':
    type: 'tmx'
    src:
      width: 30
      height: 30
      tilewidth: 32
      tileheight: 32
      autotilesets: [
        {
          image: 'sample.autotile'
          autoid: 1 # オートタイルにするタイルID
          tileid: [10,11] # オートタイルの隣接対象になるタイルID
        }
      ]
      tilesets: [
        {
          image: 'sample.tileset'
          restriction: [
            MOVE_RESTRICTION.ALLOK
            MOVE_RESTRICTION.ALLNG
            MOVE_RESTRICTION.UPOK
            MOVE_RESTRICTION.DOWNOK
            MOVE_RESTRICTION.LEFTOK
            MOVE_RESTRICTION.RIGHTOK
            MOVE_RESTRICTION.HORIZON
            MOVE_RESTRICTION.VERTICAL
            MOVE_RESTRICTION.CORNER1
            MOVE_RESTRICTION.CORNER3
            MOVE_RESTRICTION.CORNER7
            MOVE_RESTRICTION.CORNER9
            MOVE_RESTRICTION.UPNG
            MOVE_RESTRICTION.DOWNNG
            MOVE_RESTRICTION.LEFTNG
            MOVE_RESTRICTION.RIGHTNG
          ]
        }
      ]
      layers: [
        {
          type: 'layer'
          name: 'layer1'
          data: data
        },{
          type: 'objectgroup'
          name: 'events'
          objects: [
            {
              type: 'rpg.SpriteCharacter'
              properties:
                init: JSON.stringify([
                    {
                      mapX: 5
                      mapY: 10
                      moveRoute: [
                        {name: 'moveRundom'}
                        {name: 'moveLoop'}
                      ]
                    }
                ])
              width: 32
              height: 32
            },
            {
              type: 'rpg.SpriteCharacter'
              name: 'Event001'
              properties:
                init: JSON.stringify([
                    {
                      mapX: 7
                      mapY: 10
                      moveRoute: [
                        {name: 'moveRundom'}
                        {name: 'moveLoop'}
                      ]
                      pages: [
                        {
                          name: 'page1'
                          condition: [
                          ]
                          trigger: [
                            'talk'
                          ]
                          commands: [
                            {
                              type:'message'
                              params:[
                                'TEST1'
                              ]
                            },
                            {
                              type:'message'
                              params:[
                                'TEST2'
                              ]
                            }
                          ]
                        }
                      ]
                    }
                ])
              width: 32
              height: 32
            }
          ]
        }
      ]

@SAMPLE_SYSTEM_LOAD_ASSETS = @SAMPLE_SYSTEM_LOAD_ASSETS ? []
@SAMPLE_SYSTEM_LOAD_ASSETS.push ASSETS

exports.ASSETS = ASSETS if not window?

class rpg.Map

  constructor: (args={}) ->
    @setup(args)

  setup: (args={}) ->
    {
      @mapSheet
    } = {}.$extendAll(ASSETS['sample.map'].src).$extendAll(args)
    
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
