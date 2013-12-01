
# タイトルシーン
tm.define 'SceneMap',

  superClass: rpg.SceneBase

  # 初期化
  init: (args={}) ->
    # 親の初期化
    @superInit(name:'SceneMap')

    # シーンマップデータ初期化
    {
      @mapName
    } = {
      mapName: 'sample'
    }.$extendAll(args)

    # TODO: プレイヤーキャラクターとりあえず版
    @pc = new rpg.Character(tm.asset.AssetManager.get('sample.character.test'))
    @pc.moveSpeed = 6

    # TODO: マップデータ読み込みとりあえず版
    @map = new rpg.Map(tm.asset.AssetManager.get('map.' + @mapName).data)

    # インタープリター
    @interpreter = rpg.Interpreter()

    # メッセージウィンドウ
    @windowMessage = rpg.WindowMessage()
    # マップコマンド
    @windowMapMenu = rpg.WindowMapMenu()

    # プレイヤー
    @player = rpg.system.player = rpg.GamePlayer(@pc)

    playerActive = (->
      @player.active = true
      rpg.system.app.keyboard.clear()
    ).bind(@)
    @windowMapMenu.addEventListener('close',playerActive)
    @windowMessage.addEventListener('close',playerActive)
    
    openMapMenu = (->
      @player.active = false
      rpg.system.app.keyboard.clear()
      @windowMapMenu.open()
    ).bind(@)
    @player.addEventListener('input_ok',openMapMenu)
    @player.addEventListener('input_cancel',openMapMenu)

    @spriteMap = rpg.SpriteMap(@pc, @map)
    @spriteMap.addChild(rpg.SpriteCharacter(@pc))

    @addChild(@spriteMap)
    
    dummy = tm.app.CanvasElement()
    dummy.update = (->
      if @interpreter.isRunning()
        @interpreter.update()
      else
        @player.update()
        @spriteMap.updatePosition()
    ).bind(@)
    @addChild(dummy)

    @addChild(@windowMapMenu)
    @addChild(@windowMessage)

SceneMap.preload = (loader, param) ->
  console.log 'SceneMap.preload'
  key = 'map.' + param.mapName
  src = rpg.system.assets[key]
  loader.preload(key, src, 'json', rpg.Map.preload)
