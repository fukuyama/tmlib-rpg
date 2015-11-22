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
      @targets
    } = args
    menus = (
      for t in @targets
        {
          name: t.name
          fn: @_selectTarget
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

  _changeEnemyName: (list) ->
    map = new Map()
    for name,i in list
      if map.has(name)
        n = map.get(name) + 1
        map.set(name,n)
        list[i] = name + n
      else
        map.set(name,1)
        list[i] = name + 1
    return

  _selectTarget: ->
    @action.target = @targets[@index]
    @close()
    return
