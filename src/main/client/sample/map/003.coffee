require('../../../common/utils')
require('../../../common/constants')

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
  name: '003'
  width: xmax
  height: ymax
  tilewidth: 32
  tileheight: 32
  autotilesets: [
    {
      image: 'sample.autotile'
    }
  ]
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
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event001'
          width: 32
          height: 32
          properties:
            init: JSON.stringify([
              {
                spriteSheet: 'spritesheet.object001'
                transparent: true
                frame: 4
                direction:
                  fix: true
                mapX: 1
                mapY: 1
                pages: [
                  {
                    name: 'page1'
                    trigger: ['touched']
                    commands: [
                      {type:'message',params:['Hello!!']}
                    ]
                  }
                ]
              }
            ])
        }
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event002'
          width: 32
          height: 32
          properties:
            init: JSON.stringify([
              {
                spriteSheet: 'spritesheet.object001'
                transparent: true
                frame: 0
                direction:
                  fix: true
                mapX: 10
                mapY: 0
                pages: [
                  {
                    name: 'auto'
                    trigger: ['auto']
                    commands: [
                      {type:'message',params:['auto message']}
                      {type:'delete'}
                    ]
                  }
                ]
              }
            ])
        }
      ]
    }
  ]
}
