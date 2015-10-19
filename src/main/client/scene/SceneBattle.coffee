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

    # メッセージウィンドウ
    @windowMessage = rpg.WindowMessage(messageSpeed:setting.messageSpeed)

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
    _loaded_skills = (skills) ->
      for skill,i in skills
        @actions[i].skill = skill
      return

    _loaded_enemies = (enemies) ->
      @enemies = enemies
      for e in @enemies
        rpg.system.db.preloadSkill e.skills, _loaded_skills
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
    @_startTurn()
    return

  _end: ->
    @app.popScene()
    return

  _startTurn: ->
    # @battler = @actors[0]
    # @_startInputPhase()
    @battlers = @battlers.shuffle().sort (a,b) -> b.age - a.age
    @index = 0
    @turn += 1
    @_startCommandPhase
    return

  _startCommandPhase: ->
    @battler = @battlers[@index]
    if @battler.canActionInput()
      @_startInputPhase(@battler)
    else if @battler.makeAction?
      @_startAIPhase(@battler)
    return

  _startInputPhase: ->
    @windowBattleMenu.setActor @battler
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
    else @battler instanceof rpg.Enemy
      @action = @battler.makeAction {
        battler: @battler
        friends: @enemies
        targets: @actors
        turn: @turn
      }
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
