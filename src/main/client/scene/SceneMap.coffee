
ASSETS =
  'sample.scene.map':
    type: 'json'
    src:
      mapName: 'sample.map'

# タイトルシーン
tm.define 'SceneMap',

  superClass: rpg.SceneBase

  # 初期化
  init: (args='sample.scene.map') ->
    # 親の初期化
    @superInit(name:'SceneMap')

    # シーンマップデータ初期化
    args = tm.asset.AssetManager.get(args).data if typeof args == 'string'
    {
      @mapName
    } = {}.$extendAll(ASSETS['sample.scene.map'].src).$extendAll(args)

    # TODO: プレイヤーキャラクターとりあえず版
    @pc = new rpg.Character(tm.asset.AssetManager.get('sample.character.test'))
    @pc.moveSpeed = 6
    rpg.system.player = @pc
    
    # TODO: マップデータ読み込みとりあえず版
    @map = new rpg.Map(tm.asset.AssetManager.get(@mapName))

    # メッセージウィンドウ
    @windowMessage = rpg.WindowMessage()

    # プレイヤー
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
    
    dummy = tm.app.CanvasElement()
    dummy.update = @spriteMap.updatePosition.bind(@spriteMap)
    @addChild(dummy)

    @addChild(@windowMessage)
  
  update: (app) ->
    @player.update()

SceneMap.assets = [].concat ASSETS
SceneMap.assets = SceneMap.assets.concat rpg.SpriteMap.assets
