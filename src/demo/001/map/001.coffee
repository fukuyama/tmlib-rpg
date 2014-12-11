path = require 'path'

base = path.dirname module.filename

require path.relative(base,'./src/main/common/constants')

MOVE_RESTRICTION = rpg.constants.MOVE_RESTRICTION

xmax = 640 / 32
ymax = 480 / 32
# dummy map data. テスト用
data = (->
  data = []
  for i in [0...(xmax*ymax)]
    data.push 0
  data
)()

module.exports = {
  name: '001'
  width: xmax
  height: ymax
  tilewidth: 32
  tileheight: 32
  tilesets: [
    {
      image: 'img/test_tileset.png'
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
    }
    {
      type: 'objectgroup'
      name: 'events'
      objects: [
      ]
    }
  ]
}
