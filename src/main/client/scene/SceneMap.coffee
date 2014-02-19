
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
      @interpreterUpdate
    } = {
      mapName: 'sample'
      interpreterUpdate: true # デバック用
    }.$extendAll(args)

    # TODO: マップデータ読み込みとりあえず版
    @map = new rpg.Map(tm.asset.AssetManager.get('map.' + @mapName).data)

    # インタープリター
    @interpreter = rpg.Interpreter()
    # メッセージウィンドウ
    @windowMessage = rpg.WindowMessage()
    # マップメインメニュー
    @windowMapMenu = rpg.WindowMapMenu()
    # プレイヤー
    @player = rpg.system.player

    playerActive = (->
      @player.active = true
      rpg.system.app.keyboard.clear()
    ).bind(@)
    @windowMapMenu.addCloseListener(playerActive)
    @windowMessage.addCloseListener(playerActive)

    openMapMenu = (->
      @player.active = false
      rpg.system.app.keyboard.clear()
      @windowMapMenu.open()
    ).bind(@)
    @player.addEventListener('input_ok',openMapMenu)
    @player.addEventListener('input_cancel',openMapMenu)

    @spriteMap = rpg.SpriteMap(@player.character, @map)
    @spriteMap.addChild(rpg.SpriteCharacter(@player.character))

    @addChild(@spriteMap)
    
    dummy = tm.app.CanvasElement()
    dummy.update = (->
      if @interpreter.isRunning()
        @interpreter.update() if @interpreterUpdate
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
  src = param.mapData unless src?
  loader.preload(key, src, 'json', rpg.Map.preload)
