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
    return

  itemThrow: ->
    w1 = @findWindowTree (o) -> o instanceof rpg.WindowItemList
    w2 = @findWindowTree (o) -> o instanceof rpg.WindowItemActorList
    w2.actor.backpack.removeItem w1.item
    @close()
    w2.changeActor(w2.actor)
    if w1.items.length == 0
      w2.active = true
      w1.active = false
    if w1.items.length <= w1.index
      w1.setIndex(w1.items.length - 1)
