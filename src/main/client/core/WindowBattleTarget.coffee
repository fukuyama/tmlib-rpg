###*
* @file WindowBattleTarget.coffee
* 戦闘時メニュー
###

tm.define 'rpg.WindowBattleTarget',

  superClass: rpg.WindowMenu

  # 初期化
  init: (args={}) ->
    {
      parent
      targets
    } = args
    menus = (
      for t in targets
        {
          name: t.name
          fn: @_menu
        }
    )
    args.$extend {
      name:'BattleTarget'
      active: false
      visible: false
      x: parent.right
      y: 16
      cols: 1
      rows: 5
      menus: menus
    }
    @superInit(args)

  _menu: ->
    console.log 'test...'
    return
