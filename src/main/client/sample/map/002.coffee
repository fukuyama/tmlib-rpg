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
        {
          type: 'rpg.SpriteCharacter'
          name: 'Event003'
          width: 32
          height: 32
          properties:
            init: JSON.stringify([
              {
                spriteSheet: 'spritesheet.hiyoko'
                mapX: 7
                mapY: 5
                pages: [
                  {
                    name: 'page1'
                    trigger: ['talk']
                    commands: [
                      {type:'message',params: ['アイテム操作 \\item[4]']}
                      {type:'gain_item',params: [4]}
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
                mapX: 7
                mapY: 6
                pages: [
                  {
                    name: 'page1'
                    trigger: ['talk']
                    commands: [
                      {type:'message',params: ['アイテム操作 \\item[5]']}
                      {type:'gain_item',params: [5]}
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
                spriteSheet: 'spritesheet.hiyoko'
                mapX: 7
                mapY: 7
                pages: [
                  {
                    name: 'page1'
                    trigger: ['talk']
                    commands: [
                      {type:'preload_item',params: [
                        weapons: [1,2]
                        armors: [1,2,3,4,5]
                      ]}
                      {type:'message',params: ['アイテム操作。装備入手']}
                      {type:'gain_weapon',params: [1]}
                      {type:'gain_armor',params: [1]}
                      {type:'gain_armor',params: [2]}
                      {type:'gain_armor',params: [3]}
                      {type:'gain_armor',params: [4]}
                      {type:'gain_armor',params: [5]}
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
                spriteSheet: 'spritesheet.hiyoko'
                mapX: 9
                mapY: 5
                pages: [
                  {
                    name: 'page1'
                    trigger: ['talk']
                    commands: [
                      {type:'preload_item',params:[
                        items: [1,2,3,4]
                        weapons: [1,2]
                        armors: [1,2,3,4,5]
                      ]}
                      {type:'option',params:[{
                        message:
                          close: off
                      }]}
                      {type:'message',params:[
                        'いらっしゃいませ。'
                      ]}
                      {type:'message',params:[
                        'ここは雑貨屋です。\n'+
                        'どの様なご用件でしょうか？'
                      ]}
                      {type:'select',params:[['買う','売る']]}
                      {type:'block',params:[
                        {type:'loop'}
                        {type:'block',params:[
                          {type:'message',params:[
                            '\\clear何をお探しですか？\\skip'
                          ]}
                          {type:'shop_item_menu',params:[{
                            items: [1,2,3,4]
                            weapons: [1,2]
                            armors: [1,2,3,4,5]
                          }]}
                          {type:'message',params:[
                            '\#{item.name} ですね。\n'
                            '\#{item.price} になります。'
                          ]}
                          {type:'select',params:[['はい','いいえ']]}
                          {type:'block',params:[
                            {type:'message',params:['TODO: 買う処理を作成']}
                            {type:'break'}
                          ]}
                          {type:'block',params:[
                            {type:'message',params:['TODO: キャンセル処理を作成']}
                          ]}
                          {type:'end'}
                        ]}
                        {type:'end'}
                      ]}
                      {type:'block',params:[
                        {type:'message',params:['TODO: 売る処理は作成中。']}
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
      ] # objects
    }
  ]
}
