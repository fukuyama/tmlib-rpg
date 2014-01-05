
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
        {name:'テスト再開',fn:@menuTest.bind(@)}
      ]
    }
    @superInit(args)

  menuCuraAll: ->
    console.log 'menuCuraAll'
    w = @findTopWindow()
    console.log w
  menuTest: ->
    console.log 'menuTest'
    @findTopWindow().closeAll()
