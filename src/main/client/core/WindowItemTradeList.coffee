###*
* @file WindowItemTradeList.coffee
* トレードアイテム一覧ウィンドウクラス
###

# トレードアイテム一覧ウィンドウクラス
tm.define 'rpg.WindowItemTradeList',

  superClass: rpg.WindowItemList

  ###* コンストラクタ
  * @classdesc トレードアイテム一覧ウィンドウクラス
  * @constructor rpg.WindowItemTradeList
  * @param {Object} param
  * @param {Array} param.items アイテムインスタンスの配列
  * @param {Array} param.menus 追加メニュー
  ###
  init: (args={}) ->
    @superInit {help:off}.$extend args
    return

  ###* アイテム選択時の処理
  * @memberof rpg.WindowItemTradeList#
  ###
  selectItem: (item) ->
    @active = false
    wa = @findWindowTree (w) -> w instanceof rpg.WindowItemActorList
    wm = @findWindowTree (w) -> w instanceof rpg.WindowItemMenu
    wt = @findWindowTree (w) -> w instanceof rpg.WindowItemTradeActorList
    wi = @findWindowTree (w) -> w instanceof rpg.WindowItemList
    s  = wa.actor
    t  = wt.actor
    i  = wi.item
    s.backpack.removeItem i
    t.backpack.addItem i
    s.backpack.addItem item if item?
    wm.close()
    wa.changeActor(wa.actor)
    wa.active = true
    wi.setIndex(-1)
    return

  ###* アイテムリストの設定
  * @memberof rpg.WindowItemList#
  * @param {Arraty} items アイテムインスタンスの配列
  ###
  setItems: (@items) ->
    @clearMenu()
    for i in @items
      @addMenu(i.name,@selectMenu.bind @)
    @addMenu('',@selectMenu.bind @)
    @refresh()
    return
