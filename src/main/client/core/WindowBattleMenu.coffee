###*
* @file WindowBattleMenu.coffee
* 戦闘時メニュー
###

tm.define 'rpg.WindowBattleMenu',

  superClass: rpg.WindowMenu

  # 初期化
  init: (args={}) ->
    args.$extend {
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

  menuAttack: ->
    return
  menuSkill: ->
    return
  menuItem: ->
    return
  menuDefense: ->
    return
  menuOperation: ->
    return
