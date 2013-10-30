
ASSETS =
  'sample.scene.map':
    _type: 'json'
    mapName: 'sample.map'

# タイトルシーン
tm.define 'SceneMap',

  superClass: rpg.SceneBase

  # 初期化
  init: (args='sample.scene.map') ->
    # 親の初期化
    @superInit(name:'SceneMap')

    args = tm.asset.AssetManager.get(args) if typeof args == 'string'
    {
      @mapName
    } = {}.$extendAll(ASSETS['sample.scene.map']).$extendAll(args)
    
    @pc = new rpg.Character(tm.asset.AssetManager.get('sample.character.test'))
    @map = new rpg.Map(tm.asset.AssetManager.get(@mapName))

    @pc.moveSpeed = 6
    
    @windowMessage = rpg.WindowMessage()

    @player = rpg.GamePlayer(@pc)
    
    @windowMessage.addEventListener('close',(->
      @player.active = true
    ).bind(@))
    @player.addEventListener('input_ok',(->
      @player.active = false
      @windowMessage.setMessage('ほえほえ')
    ).bind(@))

    @spriteMap = rpg.SpriteMap(@pc, @map)
    @spriteMap.addChild(rpg.SpriteCharacter(@pc))
    @addChild(@spriteMap)
    
    @setupEvent()
    
    dummy = tm.app.CanvasElement()
    dummy.update = @spriteMap.updatePosition.bind(@spriteMap)
    @addChild(dummy)

    @addChild(@windowMessage)
  
  setupEvent: ->
    @characters = [
      new rpg.Character()
      new rpg.Character()
      new rpg.Character()
      new rpg.Character()
    ]

    @characters[0].moveTo(5,4).direction = 'left'
    @characters[1].moveTo(6,4).direction = 'right'
    @characters[2].moveTo(7,4).direction = 'up'
    @characters[3].moveTo(8,4).direction = 'down'

    @characters[0].moveFrequency = 1
    @characters[0].defaultMoveRoute [
      {name: 'moveUp'}
      {name: 'moveLeft'}
      {name: 'moveDown'}
      {name: 'moveRight'}
      {name: 'moveLoop'}
    ]
    @characters[1].moveFrequency = 2
    @characters[1].defaultMoveRoute [
      {name: 'moveRundom'}
      {name: 'moveLoop'}
    ]
    @characters[2].moveFrequency = 3
    @characters[2].defaultMoveRoute [
      {name: 'moveRundom'}
      {name: 'moveLoop'}
    ]
    @characters[3].moveFrequency = 4
    @characters[3].defaultMoveRoute [
      {name: 'moveRundom'}
      {name: 'moveLoop'}
    ]

    rpg.SpriteCharacter(c).addChildTo(@spriteMap) for c in @characters

  update: (app) ->
    @player.update()

SceneMap.assets = [].concat ASSETS
SceneMap.assets = SceneMap.assets.concat rpg.SpriteMap.assets
