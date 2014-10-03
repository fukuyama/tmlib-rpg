###*
* @file WindowItemListBase.coffee
* アイテム一覧ウィンドウ基底クラス
###

# アイテム一覧ウィンドウ基底クラス
tm.define 'rpg.WindowItemListBase',
  superClass: rpg.WindowMenu

  ###* コンストラクタ
  * @classdesc アイテム一覧ウィンドウ基底クラス
  * @constructor rpg.WindowItemListBase
  * @param {Object} param
  * @param {Array} param.items アイテムインスタンスの配列
  * @param {Array} param.menus 追加メニュー
  * @param {Array} param.help ヘルプウィンドウを使うかどうか
  ###
  init: (args={}) ->
    {
      @items
      help
      status
    } = {
      items: []
      help: on
      status: on
    }.$extend(args)
    
    @superInit({
      active: false
      visible: false
      x: 16
      y: 16
      cols: 1
      rows: 10
      menuWidthFix: 24 * 9
      close: false
    }.$extend(args))
    if help
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
    if status and help
      @on 'addWindow', (e) ->
        @window_status = rpg.Window(
          @right
          @window_help.bottom
          24 * 5 + 16 * 2
          rpg.system.lineHeight * 3 + 16 * 2
          {
            visible: false
            active: false
          }
        )
        @addWindow(@window_status)
    return

  refreshHelp: () ->
    @window_help.content.clear()
    if @item?.help?
      @window_help.drawMarkup(@item.help,0,0)
    @window_help.refresh()
    return

  refreshStatus: () ->
    @window_status.content.clear()
    if @item? and @item instanceof rpg.EquipItem
      # TODO: 装備アイテムの場合ステータスを表示
      text = "TODO: ..."
      @window_status.drawMarkup(text,0,0)
    else
      @window_status.visible = false
    @window_status.refresh()
    return

  ###* インデックス変更時の処理
  * @memberof rpg.WindowItemListBase#
  ###
  change_index: ->
    if @index >= 0
      if @window_help?
        @window_help.visible = true
        @refreshHelp()
      if @window_status?
        @window_status.visible = true
        @refreshStatus()
    else
      @window_help?.visible = false
      @window_status?.visible = false

  ###* メニュー選択時の処理
  * @memberof rpg.WindowItemListBase#
  ###
  selectMenu: ->
    @selectItem @items[@index]
    return

  ###* アイテム選択時の処理
  * @memberof rpg.WindowItemListBase#
  ###
  selectItem: (item) ->
    return

  ###* アイテムリストの設定
  * @memberof rpg.WindowItemListBase#
  * @param {Arraty} items アイテムインスタンスの配列
  ###
  setItems: (items) ->
    @clearMenu()
    if @parentWindow?.actor?
      @items = []
      actor = @parentWindow.actor
      for k, v of actor.equips when v?
        @items.push v
        @addMenu('E ' + v.name,@selectMenu.bind @)
      for i in items when actor[i.position] != i
        @items.push i
        @addMenu(i.name,@selectMenu.bind @)
    else
      @items = items
      for i in @items
        @addMenu(i.name,@selectMenu.bind @)
    @resizeContent()
    @refresh()
    return

  ###* キャンセル時の処理
  * @memberof rpg.WindowItemListBase#
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

rpg.WindowItemListBase.prototype.getter 'item', -> @items[@index]
