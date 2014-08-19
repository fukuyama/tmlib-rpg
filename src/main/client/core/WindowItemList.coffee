###*
* @file WindowItemList.coffee
* アイテム一覧ウィンドウクラス
###

# アイテム一覧ウィンドウクラス
tm.define 'rpg.WindowItemList',
  superClass: rpg.WindowMenu

  ###* コンストラクタ
  * @classdesc ウィンドウクラス
  * @constructor rpg.WindowItemList
  * @param {Object} param
  * @param {Array} param.items アイテムインスタンスの配列
  * @param {Array} param.menus 追加メニュー
  ###
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
    return

  ###* インデックス変更時の処理
  * @memberof rpg.WindowItemList#
  ###
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

  ###* メニュー選択時の処理
  * @memberof rpg.WindowItemList#
  ###
  selectMenu: ->
    @selectItem @items[@index]
    return

  ###* アイテム選択時の処理
  * @memberof rpg.WindowItemList#
  ###
  selectItem: (item) ->
    # アイテムメニューを表示する
    @addWindow rpg.WindowItemMenu(parent:@)
    # 自分は非アクティブに
    @active = false
    return

  ###* アイテムリストの設定
  * @memberof rpg.WindowItemList#
  * @param {Arraty} items アイテムインスタンスの配列
  ###
  setItems: (@items) ->
    @clearMenu()
    for i in @items
      @addMenu(i.name,@selectMenu.bind @)
    @refresh()
    return

  ###* キャンセル時の処理
  * @memberof rpg.WindowItemList#
  ###
  cancel: ->
    # 選択解除
    @setIndex -1
    # 親(アクターリスト)をアクティブに
    @parentWindow.active = true
    # 自分は非アクティブに
    @active = false
    # クローズ（非表示）には、しない
    return

rpg.WindowItemList.prototype.getter 'item', -> @items[@index]
