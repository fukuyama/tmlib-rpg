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
    @superInit {
      name: 'ItemTradeList'
      help: off
    }.$extend args
    return

  ###* アイテム選択時の処理
  * @memberof rpg.WindowItemTradeList#
  ###
  selectItem: (tradeitem) ->
    @active = false
    eg = rpg.EventGenerator()
    wa = @findWindowTree (w) -> w instanceof rpg.WindowItemActorList
    wm = @findWindowTree (w) -> w instanceof rpg.WindowItemMenu
    wt = @findWindowTree (w) -> w instanceof rpg.WindowItemTradeActorList
    wi = @findWindowTree (w) -> w instanceof rpg.WindowItemList
    sa = wa.actor
    ta = wt.actor
    item = wi.item
    sa.backpack.removeItem item
    ta.backpack.addItem item
    if tradeitem?
      ta.backpack.removeItem tradeitem
      sa.backpack.addItem tradeitem
      eg.itemTradeSwap(sa,ta,item,tradeitem)
    else
      eg.itemTradeHandOver(sa,ta,item)
    eg.function ->
      wm.close()
      wa.changeActor(wa.actor)
      if wi.items.length == 0
        wm.on 'close', ->
          wa.active = true
          wi.active = false
      if wi.items.length <= wi.index
        wi.setIndex(wi.items.length - 1)
    rpg.system.mapInterpreter.start eg.commands
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
