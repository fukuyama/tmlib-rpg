
# 戦闘シーン
tm.define 'SceneBattle',

  superClass: rpg.SceneBase

  ###* 初期化
  * @classdesc 戦闘シーンクラス
  * @constructor rpg.SceneBattle
  * @param {Object} args
  ###
  init: (args={}) ->
    {
      @troop
    } = args
    # 親の初期化
    @superInit(name:'SceneBattle')

    setting = rpg.system.setting

    # 戦闘用インタープリター
    @interpreter = rpg.system.mapInterpreter

    # メッセージウィンドウ
    @windowMessage = rpg.WindowMessage(
      messageSpeed: setting.messageSpeed
    )

    # 戦闘コマンドメニュー
    @windowBattleMenu = rpg.WindowBattleMenu()
    @windowBattleMenu.addCloseListener @_endInputPhase.bind @
    # メニューレイヤー
    menuLayer = tm.display.CanvasElement()
    #menuLayer.addChild(@windowBattleStatus)
    menuLayer.addChild(@windowBattleMenu)
    @addChild(menuLayer)

    # メッセージレイヤー
    messageLayer = tm.display.CanvasElement()
    messageLayer.addChild(@windowMessage)
    @addChild(messageLayer)

    @on 'enter', @_load
    return

  _load: ->
    _loaded_enemies = (enemies) ->
      @enemies = enemies
      @_start()
      return
    _loaded_troop = (troops) ->
      @troop = troops[0]
      rpg.system.db.preloadEnemy @troop.enemies, _loaded_enemies.bind @
      return
    rpg.system.db.preloadTroop [@troop], _loaded_troop.bind @
    return

  _start: () ->
    @actors = rpg.game.party.getMembers()
    @battlers = [].concat @actors
    @battlers = @battlers.concat @enemies
    @interpreter.start [
      {type:'message',params:['battle start']}
    ]
    @_startTurn()
    return

  _end: ->
    @app.popScene()
    return

  _startTurn: ->
    @battlers = @battlers.shuffle().sort (a,b) -> b.age - a.age
    @index = 0
    @_startCommandPhase()
    return

  _startCommandPhase: ->
    @battler = @battlers[@index]
    if @battler instanceof rpg.Actor
      @_startInputPhase(@battler)
    else if @battler instanceof rpg.Enemy
      a
    return

  _startInputPhase: ->
    @windowBattleMenu.setActor @battler
    @phase = ->
      @phase = null
      @windowBattleMenu.open()
      return
    return

  _endInputPhase: ->
    @_end()
    # @_startMainPhase()
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
