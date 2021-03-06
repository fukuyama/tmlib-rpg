###*
* @file WindowBattleMenu.coffee
* 戦闘時メニュー
###

tm.define 'rpg.WindowBattleMenu',

  superClass: rpg.WindowMenu

  # 初期化
  init: (args={}) ->
    args.$extend {
      title:'actor name'
      name:'BattleMenu'
      active: false
      visible: false
      x: 16
      y: 16
      cols: 1
      rows: 5
      menus: [
        {name:'こうげき',fn:@menuAttack.bind(@)}
        {name:'とくぎ',fn:@menuSkill.bind(@)}
        {name:'どうぐ',fn:@menuItem.bind(@)}
        {name:'ぼうぎょ',fn:@menuDefense.bind(@)}
        {name:'さくせん',fn:@menuOperation.bind(@)}
      ]
    }
    @superInit(args)
    @friends = []
    @targets = []

  setActor: (@actor) ->
    @clearTitle()
    @drawTitle(@actor.name)
    return @

  menuAttack: ->
    @action = {
      skill: rpg.system.db.getSkill rpg.system.actions.attack # 攻撃アクション
    }
    windowBattleTarget = rpg.WindowBattleTarget
      parent: @
      targets: @targets
      friends: @friends
      action: @action
    @active = false
    @visible = false
    @addWindow windowBattleTarget
    windowBattleTarget.open()
    return
  menuSkill: ->
    return
  menuItem: ->
    return
  menuDefense: ->
    return
  menuOperation: ->
    return

rpg.WindowBattleMenu.prototype.setter 'battler', (actor) -> @setActor actor
