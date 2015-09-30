
# さくせんメニュー
tm.define 'rpg.WindowOperation',
  superClass: rpg.WindowMenu
  # 初期化
  init: (args={}) ->
    parent = args.parent
    args.$extend {
      name: 'Operation'
      x: parent.left
      y: parent.top
      active: true
      visible: true
      cols: 1
      rows: 5
      menus: [
        {name:'まんたん',fn:@menuCuraAll.bind(@)}
        {name:'セーブ',fn:@menuSave.bind(@)}
        {name:'ロード',fn:@menuLoad.bind(@)}
      ]
    }
    @superInit(args)

  menuCuraAll: ->
    console.log 'menuCuraAll'
    w = @findTopWindow()
    console.log w

  menuSave: ->
    console.log 'save'
    localStorage.setItem 'data01', JSON.stringify(rpg.game)

  menuLoad: ->
    console.log 'load'
    data = JSON.parse(localStorage.getItem 'data01')
    console.log data
    
