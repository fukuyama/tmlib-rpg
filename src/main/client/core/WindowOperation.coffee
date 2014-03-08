
# さくせんメニュー
tm.define 'rpg.WindowOperation',
  superClass: rpg.WindowMenu
  # 初期化
  init: (args={}) ->
    args.$extend {
      active: false
      visible: false
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
    # 現在のシーンをキャプチャー
    rpg.system.captureScreenBitmap()
    rpg.system.db.item(['001','002'],(items)->
      console.log items
    )
