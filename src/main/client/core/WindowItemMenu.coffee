###*
* @file WindowItemMenu.coffee
* アイテムメニュー
###

tm.define 'rpg.WindowItemMenu',

  superClass: rpg.WindowMenu

  ###* コンストラクタ
  * @classdesc アイテムメニュークラス
  * @constructor rpg.WindowItemMenu
  * @param {Object} args
  ###
  init: (args={}) ->
    {
      parent
      menus
    } = {
      menus: []
    }.$extend(args)

    m = []
    m.push name:'つかう', fn: @itemUse.bind @
    m.push name:'わたす', fn: @itemTrade.bind @
    m.push name:'すてる', fn: @itemThrow.bind @
    args.menus = m.concat menus
    @superInit({
      title: 'どうする？'
      active: true
      visible: true
      x: 16
      y: 16
      cols: 1
      rows: args.menus.length
    }.$extend(args))
    w  = parent.findWindowTree (o) -> o instanceof rpg.WindowItemActorList
    @x = w.right - @width
    @y = w.bottom

  itemUse: ->
    return

  itemTrade: ->
    @addWindow rpg.WindowItemTradeActorList parent: @
    @active = false
    return

  itemThrow: ->
    wi = @findWindowTree (o) -> o instanceof rpg.WindowItemList
    wa = @findWindowTree (o) -> o instanceof rpg.WindowItemActorList
    wa.actor.backpack.removeItem wi.item
    @close()
    wa.changeActor(wa.actor)
    if wi.items.length == 0
      wa.active = true
      wi.active = false
    if wi.items.length <= wi.index
      wi.setIndex(wi.items.length - 1)
