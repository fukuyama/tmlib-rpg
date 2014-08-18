
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
    @on 'addWindow', (e) ->
      @window_help = rpg.Window(
        @right
        16
        24 * 5 + 16 * 2
        rpg.system.lineHeight * 3 + 16 * 2
        {
          visible: false
          active: false
        }
      )
      @addWindow(@window_help)

  change_index: ->
    if @index >= 0
      if @window_help?
        @window_help.visible = true
        @window_help.content.clear()
        if @item?.help?
          @window_help.drawMarkup(@item.help,0,0)
        @window_help.refresh()
    else
      @window_help?.visible = false

  selectMenu: ->
    @selectItem @items[@index]

  selectItem: (item) ->
    @addWindow rpg.WindowItemMenu(parent:@)
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

rpg.WindowItemList.prototype.getter 'item', -> @items[@index]
