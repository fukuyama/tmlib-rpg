
# アイテム一覧ウィンドウクラス
tm.define 'rpg.WindowItemList',
  superClass: rpg.WindowMenu

  # 初期化
  init: (args={}) ->
    {
      @items
      menus
    } = {
      items: []
      menus: []
    }.$extend(args)
    
    for i in @items
      menus.push {
        name: i.name
        fn: @selectMenu.bind @
      }

    @superInit({
      menus: menus
      active: false
      visible: false
      x: 16
      y: 16
      cols: 1
      rows: 10
      menuWidthFix: 24 * 9
      close: false
    }.$extend(args))

  selectMenu: ->
    @selectItem @items[@index]

  selectItem: (item) ->
    @addWindow rpg.WindowItemMenu().open()
    @active = false

  setItems: (items) ->
    @clearMenu()
    @items = items
    for i in @items
      @addMenu(i.name,@selectMenu.bind @)
    @refresh()
    @

  cancel: ->
    @setIndex -1
    @parentWindow.active = true
    @active = false
