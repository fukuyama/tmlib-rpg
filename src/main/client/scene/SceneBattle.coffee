
# 戦闘シーン
tm.define 'SceneBattle',

  superClass: rpg.SceneBase

  ###* 初期化
  * @classdesc 戦闘シーンクラス
  * @constructor rpg.SceneBattle
  * @param {Object} args
  * @param {rpg.Map} args.map マップオブジェクト
  *                  事前に読み込む物があるのでStringでは無理
  ###
  init: (args={}) ->
    {
      @encount
    } = args
    # 親の初期化
    @superInit(name:'SceneBattle')

    setting = rpg.system.setting

    # バトルインタープリター
    @interpreter = rpg.system.mapInterpreter

    # メッセージウィンドウ
    @windowMessage = rpg.WindowMessage(
      messageSpeed: setting.messageSpeed
    )

    # メニューレイヤー
    #menuLayer = tm.display.CanvasElement()
    #menuLayer.addChild(@windowBattleStatus)
    #menuLayer.addChild(@windowBattleMenu)
    #@addChild(menuLayer)

    # メッセージレイヤー
    messageLayer = tm.display.CanvasElement()
    messageLayer.addChild(@windowMessage)
    @addChild(messageLayer)

    @next @phaseStartBattle

  next: (@phase) ->

  phaseStartBattle: ->
    console.count 'startPhase'
    @interpreter.start [
      {type:'message',params:['battle start']}
    ]
    @next @phaseEndBattle
    return

  phaseEndBattle: ->
    console.count 'endPhase'
    @app.popScene()
    return

  phaseInputCommand: ->
    return

  phaseMain: ->
    return

  update: ->
    if @interpreter.isRunning()
      @interpreter.update()
      return
    if @phase?
      @phase()
    return
