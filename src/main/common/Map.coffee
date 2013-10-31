# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# 移動制限定数、移動できる方向が true
# 方向は [2,4,6,8] の位置パラメータ
# VXAce にならって乗り物も入れるか…？
MOVE_RESTRICTION = {
  ALLOK: [true,true,true,true]
  UPOK: [false,false,false,true]
  DOWNOK: [true,false,false,false]
  LEFTOK: [false,true,false,false]
  RIGHTOK: [false,false,true,false]
  ALLNG: [false,false,false,false]
  HORIZON: [false,true,true,false]
  VERTICAL: [true,false,false,true]
  CORNER1: [false,false,true,true]
  CORNER3: [false,true,false,true]
  CORNER7: [true,false,true,false]
  CORNER9: [true,true,false,false]
  UPNG: [true,true,true,false]
  DOWNNG: [false,true,true,true]
  LEFTNG: [true,false,true,true]
  RIGHTNG: [true,true,false,true]
}

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
                      mapY: 5
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
  isPassable: (x, y, d) ->
    r = @_restriction(x,y)
    r[d / 2 - 1]

  # 移動制限情報の取得
  _restriction: (x, y) ->
    # TODO: イベントから見つかったらそれを返す
    # TODO: マップ固有情報から見つかったらそれを返す
    # タイルセットから
    @_restrictionTileset(x, y)

  _restrictionTileset: (x, y) ->
    i = @mapSheet.layers.length - 1
    while i >= 0
      layer = @mapSheet.layers[i--]
      if layer.type == 'layer'
        tileid = layer.data[x + y * @width]
        if tileid >= 0
          return @mapSheet.tilesets[0].restriction[tileid]
    MOVE_RESTRICTION.PASS
