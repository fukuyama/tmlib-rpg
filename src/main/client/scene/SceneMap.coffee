
# タイトルシーン
tm.define 'SceneMap',

  superClass: rpg.SceneBase

  ###* 初期化
  * @classdesc マップシーンクラス
  * @constructor rpg.SceneMap
  * @param {Object} args
  * @param {rpg.Map} args.map マップオブジェクト
  *                  事前に読み込む物があるのでStringでは無理
  ###
  init: (args={}) ->
    # 親の初期化
    @superInit(name:'SceneMap')

    # シーンマップデータ初期化
    {
      @map
      @interpreterUpdate
    } = {
      interpreterUpdate: true # デバック用
    }.$extendAll(args)

    @_refreshEvent = true # イベント更新フラグ

    # マップインタープリター
    @interpreter = rpg.system.mapInterpreter

    # メッセージウィンドウ
    @windowMessage = rpg.WindowMessage()
    # マップメインメニュー
    @windowMapMenu = rpg.WindowMapMenu()
    # 簡易ステータスウィンドウ
    @windowMapStatus = rpg.WindowMapStatus(windowMapMenu:@windowMapMenu)
    # プレイヤー
    @player = rpg.system.player

    f = @playerActive.bind @
    @windowMapMenu.addCloseListener f
    @windowMessage.addCloseListener f

    f = @openMapMenu.bind @
    @player.setupEventListener input_ok: f, input_cancel: f

    @spriteMap = rpg.SpriteMap(@map)

    plsc = rpg.SpriteCharacter(@player.character).addChildTo(@spriteMap)
    plsc.on 'enterframe', @playerEnterframe.bind(@)

    @addChild(@player)
    @addChild(@spriteMap)

    # メニューレイヤー
    menuLayer = tm.display.CanvasElement()
    menuLayer.addChild(@windowMapStatus)
    menuLayer.addChild(@windowMapMenu)
    @addChild(menuLayer)

    # メッセージレイヤー
    messageLayer = tm.display.CanvasElement()
    messageLayer.addChild(@windowMessage)
    @addChild(messageLayer)

    rpg.system.temp.transition?.addChildTo @

  update: ->
    # シーン切り替え中は更新しない(カレントシーンが自分では無い場合)
    return if rpg.system.scene != @
    unless @interpreter.isRunning()
      # イベントの更新が必要な場合
      if @_refreshEvent
        # イベント更新(自動起動反映)
        @map.refreshEvent()
        @_refreshEvent = false
      # 自動実行イベント判定
      if @map.autoEvents.length > 0
        @map.autoEvents.shift().start('auto')
        @player.awake = false
        return
    unless @interpreter.isRunning()
      # 接触イベント判定
      @player.checkTouched() if @player.character.isMoved()
    @player.awake = not @interpreter.isRunning()
    # インタプリター更新
    @interpreter.update() if @interpreter.isRunning() and @interpreterUpdate
    return

  refreshEvent: () ->
    @_refreshEvent = true

  openMapMenu: ->
    @player.active = false
    rpg.system.app.keyboard.clear()
    @windowMapMenu.open()

  playerActive: ->
    wa = @windowMapMenu.findWindowTree (w) -> w.visible
    if (not @windowMessage.visible) and (not wa?)
      @player.active = true
    rpg.system.app.keyboard.clear()

  playerEnterframe: ->
    @spriteMap.updatePosition()
