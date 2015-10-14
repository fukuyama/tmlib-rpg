
# マップシーンクラス
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
    @_encount = 0

    setting = rpg.system.setting

    # マップインタープリター
    @interpreter = rpg.system.mapInterpreter

    # メッセージウィンドウ
    @windowMessage = rpg.WindowMessage(
      messageSpeed: setting.messageSpeed
    )
    # マップメインメニュー
    @windowMapMenu = rpg.WindowMapMenu()
    # 簡易ステータスウィンドウ
    @windowMapStatus = rpg.WindowMapStatus(windowMapMenu:@windowMapMenu)
    # プレイヤー
    @player = rpg.game.player
    @player.map = map.name

    f = @playerActive.bind @
    @windowMapMenu.addCloseListener f
    @windowMessage.addCloseListener f

    # プレイヤーの入力、決定かキャンセルどちらでも、メニューを表示する。
    f = @openMapMenu.bind @
    @player.setupEventListener input_ok: f, input_cancel: f

    # マップ用スプライト
    @spriteMap = rpg.SpriteMap(@map)

    # プレイヤーキャラクター用のスプライト
    plsc = rpg.SpriteCharacter(@player.character).addChildTo(@spriteMap)
    plsc.on 'enterframe', @playerEnterframe.bind(@)

    # 画像表示用スプライト
    @spritePicture = rpg.SpritesetPicture()
    # アニメーション表示用スプライト
    @spriteAnimation = rpg.SpritesetAnimation()

    @addChild(@player)
    @addChild(@spriteMap)
    @addChild(@spritePicture)
    @addChild(@spriteAnimation)

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
      if @player.character.isMoved()
        @player.checkTouched()
    if @interpreter.isRunning()
      # インタプリター更新
      if @interpreterUpdate
        @interpreter.update()
    else
      # TODO:エンカウント判定
      # エンカウント歩数以上歩いたら、エンカウント率で戦闘
      if @player.character.isMoved()
        @_encount += 1
        encount = @map.encount
        if encount?
          if encount.step < @_encount
            if Math.rand(0,100) < encount.rate
              @_encount = 0
              @startBattle(encount)
              return
    @player.awake = not @interpreter.isRunning()
    return

  refreshEvent: () ->
    @_refreshEvent = true

  openMapMenu: ->
    wa = @windowMapMenu.findWindowTree (w) -> w.visible
    if (not @windowMessage.visible) and (not wa?) and not @interpreter.isRunning()
      @player.active = false
      @windowMapStatus.show()
      @windowMapMenu.open()
    rpg.system.app.keyboard.clear()

  playerActive: ->
    wa = @windowMapMenu.findWindowTree (w) -> w.visible
    if (not @windowMessage.visible) and (not wa?)
      @player.active = true
      @windowMapStatus.hide()
    rpg.system.app.keyboard.clear()

  playerEnterframe: ->
    @spriteMap.updatePosition()

  startBattle: (encount) ->
    @player.active = false
    scene = SceneBattle encount
    scene.on 'exit', @endBattle.bind @
    @app.pushScene scene

  endBattle: ->
    @playerActive()
    return
