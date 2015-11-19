path = require 'path'
base = path.dirname module.filename
require path.relative(base,'./src/main/common/utils')
require path.relative(base,'./src/main/common/constants')

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
for x in [9..11]
  for y in [5..6]
    data[x+y*30] = 0
for x in [19..21]
  for y in [4..6]
    data[x+y*30] = 0
for x in [0..29]
  for y in [0,1,2]
    data[x+y*30] = 0
t = 2
for x in [0..29] when x % 2 == 1 and t <= 15
  for y in [1]
    data[x+y*30] = t++

data[1+5*30]=17
data[0+3*30]=0

module.exports = {
  name: '001'
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
  encounts: [
    {
      rect:
        left: 0
        top: 0
        right: 10
        bottom: 3
      troops: [2]
      step: 10
      rate: 50
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
    {
      image: 'img/test_tileset.png'
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
          name: 'Event001'
          properties:
            init: JSON.stringify([
              {
                spriteSheet: 'spritesheet.hiyoko'
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
        }
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event002'
          properties:
            init: JSON.stringify([
              {
                spriteSheet: 'spritesheet.hiyoko'
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
                          'ほえほえ'
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
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event003'
          width: 32
          height: 32
          properties:
            init: JSON.stringify([
              {
                spriteSheet: 'spritesheet.hiyoko'
                mapX: 10
                mapY: 5
                pages: [
                  {
                    name: 'page1'
                    trigger: ['talk']
                    commands: [
                      {
                        type:'message'
                        params: [
                          'ほえほえ'
                        ]
                      }
                    ]
                  }
                ]
              }
            ])
        }
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event003b'
          width: 32
          height: 32
          properties:
            init: JSON.stringify([
              {
                spriteSheet: 'spritesheet.hiyoko'
                mapX: 10
                mapY: 6
                pages: [
                  {
                    name: 'page1'
                    trigger: ['talk']
                    commands: [
                      {type:'option',params:[{
                        message:
                          close: off
                      }]}
                      {
                        type:'message'
                        params: [
                          'ほえほえ'
                        ]
                      }
                      {type:'select',params:[['はい','いいえ']]}
                      {type:'block',params:[
                        {type:'message',params:['はい']}
                        {type:'break'}
                      ]}
                      {type:'block',params:[
                        {type:'message',params:['いいえ']}
                      ]}
                      {type:'end'}
                      {type:'option',params:[{
                        message:
                          close: on
                      }]}
                    ]
                  }
                ]
              }
            ])
        }
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event003c'
          width: 32
          height: 32
          properties:
            init: JSON.stringify([
              {
                spriteSheet: 'spritesheet.hiyoko'
                mapX: 11
                mapY: 6
                pages: [
                  {
                    name: 'page1'
                    trigger: ['talk']
                    commands: [
                      {
                        type:'message'
                        params: [
                          'ほえほえ'
                        ]
                      }
                      {type:'select',params:[['はい','いいえ']]}
                      {type:'block',params:[
                        {type:'message',params:['はい']}
                        {type:'break'}
                      ]}
                      {type:'block',params:[
                        {type:'message',params:['いいえ']}
                      ]}
                      {type:'end'}
                    ]
                  }
                ]
              }
            ])
        }
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event004'
          width: 32
          height: 32
          properties:
            init: JSON.stringify([
              {
                spriteSheet: 'spritesheet.hiyoko'
                mapX: 11
                mapY: 5
                pages: [
                  {
                    name: 'page1'
                    trigger: ['talk']
                    commands: [
                      {type:'message',params: ['アイテム操作']}
                      {type:'gain_item',params: [1]}
                    ]
                  }
                ]
              }
            ])
        }
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event005'
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
                mapX: 20
                mapY: 5
                pages: [
                  {
                    name: 'page1'
                    trigger: ['touched']
                    commands: [
                      {type:'message',params: ['接触イベント']}
                      {type:'if',params:['flag','A',on]}
                      {type:'block',params:[
                        {type:'message',params:['フラグＡ=ON']}
                      ]}
                      {type:'else'}
                      {type:'block',params:[
                        {type:'message',params:['フラグＡ=OFF']}
                      ]}
                      {type:'end'}
                    ]
                  }
                ]
              }
            ])
        }
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event006'
          width: 32
          height: 32
          properties:
            init: JSON.stringify([
              {
                spriteSheet: 'spritesheet.object001'
                transparent: true
                frame: 1
                direction:
                  fix: true
                mapX: 20
                mapY: 4
                pages: [
                  {
                    name: 'page0'
                  }
                  {
                    name: 'page1'
                    condition: [
                      {type:'flag.off?',params:['A']}
                    ]
                    trigger: ['touched']
                    commands: [
                      {type:'flag',params:['A',true]}
                    ]
                  }
                  {
                    name: 'page2'
                    condition: [
                      {type:'flag.on?',params:['A']}
                    ]
                    trigger: ['touched']
                    commands: [
                      {type:'flag',params:['A',false]}
                    ]
                  }
                ]
              }
            ])
        }
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event007'
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
                mapX: 20
                mapY: 10
                pages: [
                  {
                    name: 'page1'
                    trigger: ['touched']
                    commands: [
                      {type:'setup_transition'}
                      {type:'move_map',params:[2,5,6,8]}
                      {type:'start_transition'}
                    ]
                  }
                ]
              }
            ])
        }
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event008'
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
                mapX: 0
                mapY: 3
                pages: [
                  {
                    name: 'page1'
                    trigger: ['touched']
                    commands: [
                      {type:'message',params:['マップＩＤの入力']}
                      {type:'input_num',params:['MAPID']}
                      {type:'message',params:['移動します']}
                      {type:'move_map',params:['MAPID',0,0,2]}
                    ]
                  }
                ]
              }
            ])
        }
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event009'
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
                mapX: 0
                mapY: 0
                pages: [
                  {
                    name: 'page1'
                    trigger: ['auto']
                    commands: [
                      {type:'flag',params: ['init',on]}
                      {type:'gain_item',params: [1]}
                      {type:'gain_cash',params: [1000]}
                    ]
                  }
                  {
                    name: 'page2'
                    condition: [
                      {type:'flag.on?',params:['init']}
                    ]
                    trigger: ['auto']
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
