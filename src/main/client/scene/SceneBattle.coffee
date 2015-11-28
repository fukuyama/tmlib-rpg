###*
* @file SceneBattle.coffee
* 戦闘シーン
###

###
戦闘関連まとめ

キャラクター情報
Battler
 +> Actor
 +> Enemy

Effect

Item

Skill

State

攻撃とかのアクション効果は、全部Effectで行う。

###

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

    # 戦闘シーンテンプレートをここに
    if rpg.system.scene_battle_module()
      @battleField = rpg.SpritesetBattle()

    # 戦闘コマンドメニュー
    @windowBattleMenu = rpg.WindowBattleMenu()
    @windowBattleMenu.addCloseListener @_endInputPhase.bind @

    # メニューレイヤー
    menuLayer = tm.display.CanvasElement()
    #menuLayer.addChild(@windowBattleStatus)
    menuLayer.addChild(@windowBattleMenu)
    @addChild(menuLayer)

    # メッセージウィンドウ
    @windowMessage = rpg.WindowMessage(messageSpeed:setting.messageSpeed)
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

  _start: ->
    @actors = rpg.game.party.getMembers()
    @battlers = [].concat @actors
    @battlers = @battlers.concat @enemies
    @interpreter.start [
      {type:'message',params:['battle start']}
    ]
    @turn = 0
    @_nextTurn()
    return

  _end: ->
    @app.popScene()
    return

  _nextTurn: ->
    @battlers = @battlers.shuffle().sort (a,b) -> b.age - a.age
    @index = 0
    @turn += 1
    console.log 'turn ' + @turn
    @_startCommandPhase()
    return

  _nextBattler: ->
    if @index < @battlers.length
      console.log 'battler ' + @index
      @index += 1
      @_startCommandPhase()
    else
      @_nextTurn()

  _startCommandPhase: ->
    @battler = @battlers[@index]
    if @battler.isActionInput()
      @_startInputPhase(@battler)
    else if @battler.makeAction?
      @_startAIPhase(@battler)
    return

  _startInputPhase: ->
    @windowBattleMenu.battler = @battler
    @windowBattleMenu.friends = @actors
    @windowBattleMenu.targets = @enemies
    @phase = ->
      @phase = null
      @windowBattleMenu.open()
      return
    return

  _startAIPhase: ->
    if @battler instanceof rpg.Actor
      @action = @battler.makeAction {
        battler: @battler
        friends: @actors
        targets: @enemies
        turn: @turn
      }
    else if @battler instanceof rpg.Enemy
      @action = @battler.makeAction {
        battler: @battler
        friends: @enemies
        targets: @actors
        turn: @turn
      }
    @phase = @phaseAction
    return

  _endInputPhase: ->
    @_end()
    return

  # アクションを実行する
  phaseAction: ->
    @_nextBattler()
    return

  update: ->
    if @interpreter.isRunning()
      @interpreter.update()
      return
    if @phase?
      @phase()
    return
