
# さくせんメニュー
tm.define 'rpg.WindowOperation',
  superClass: rpg.WindowMenu
  # 初期化
  init: (args={}) ->
    parent = args.parent
    args.$extend {
      name: 'Operation'
      x: parent.right
      y: parent.top
      active: true
      visible: true
      cols: 1
      rows: 5
      menus: [
        {name:'まんたん',fn:@menuCuraAll.bind(@)}
        {name:'TEST',fn:@menuTest001.bind(@)}
      ]
    }
    @superInit(args)

  menuCuraAll: ->
    console.log 'menuCuraAll'
    w = @findTopWindow()
    console.log w
  menuTest001: ->
    console.log 'menuTest001'
    rpg.system.db.preloadItem(['001','002'],(items)->
      console.log items
    )
