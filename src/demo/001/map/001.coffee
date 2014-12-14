path = require 'path'

base = path.dirname module.filename

require path.relative(base,'./src/main/common/constants')

MOVE_RESTRICTION = rpg.constants.MOVE_RESTRICTION

module.exports = {
  name: '001'
  width: 20
  height: 15
  tilewidth: 32
  tileheight: 32
  tilesets: [
    {
      image: 'img/pipo-map001.png'
      restriction: [
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLNG
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
        MOVE_RESTRICTION.ALLOK
      ]
    }
  ]
  layers: [
    {
      type: 'layer'
      name: '地面'
      data: [
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      ]
    }
    {
      type: 'layer'
      name: '地上'
      data: [
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,10,-1,-1,-1,-1,-1,10,10,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,10,10,-1,-1,-1,-1,10,-1,-1,10,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,10,-1,-1,-1,10,-1,-1,-1,-1,10,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,10,-1,-1,-1,10,-1,-1,-1,-1,10,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,10,-1,-1,-1,10,-1,-1,-1,-1,10,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,10,-1,-1,-1,10,-1,-1,-1,-1,10,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,10,-1,-1,-1,10,-1,-1,-1,-1,10,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,10,-1,-1,-1,-1,10,-1,-1,10,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,10,10,10,-1,-1,-1,-1,10,10,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
      ]
    }
    {
      type: 'objectgroup'
      name: 'events'
      objects: [
        {
          type: 'rpg.SpriteCharacter'
          name: 'Auto001'
          width: 32
          height: 32
          properties:
            init: JSON.stringify([
              {
                spriteSheet: 'character.object002'
                transparent: true
                frame: 0
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
                      {type:'message',params: [
                        'これは、tmlib.js Advent Calendar 2014\n１５日目のデモです。\nメッセージを進めるには、Enterキーを押してください。'
                        '操作説明'
                        '決定 = Enter'
                        'キャンセル = Esc'
                        '移動 = Arrow key'
                      ]}
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
