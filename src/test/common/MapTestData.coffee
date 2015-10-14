
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
for x in [12..14]
  for y in [9..11]
    data[x+y*30] = 0
for x in [0..29]
  for y in [0,1,2]
    data[x+y*30] = 0
t = 2
for x in [0..29] when x % 2 == 1 and t <= 15
  for y in [1]
    data[x+y*30] = t++

module.exports = {
  name: '001'
  width: 30
  height: 30
  tilewidth: 32
  tileheight: 32
  encounts: [
    {
      rect:
        left: 0
        top: 0
        right: 10
        bottom: 10
      troop: 1
      step: 30
      rate: 50
    }
  ]
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
        }
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
      ]
    }
  ]
}
