require('../../../common/utils')
require('../../../common/constants')

MOVE_RESTRICTION = rpg.constants.MOVE_RESTRICTION

# dummy map data. テスト用
data = (->
  data = []
  x = y = 30
  for i in [0...(x*y)]
    data.push 0
  data
)()

module.exports = {
  name: '002'
  width: 30
  height: 30
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
                frame: 2
                direction:
                  fix: true
                mapX: 5
                mapY: 5
                pages: [
                  {
                    name: 'page1'
                    trigger: ['touched']
                    commands: [
                      {type:'setup_transition'}
                      {type:'move_map',params:[1,20,10,2]}
                      {type:'start_transition'}
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
                frame: 2
                direction:
                  fix: true
                mapX: 6
                mapY: 5
                pages: [
                  {
                    name: 'page1'
                    trigger: ['touched']
                    commands: [
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
