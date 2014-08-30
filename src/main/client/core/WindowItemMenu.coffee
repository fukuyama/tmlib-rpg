###*
* @file WindowItemMenu.coffee
* アイテムメニュー
###

ITEM_SCOPE = rpg.constants.ITEM_SCOPE

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

  ###* 使うメニュー
  * @memberof rpg.WindowItemMenu#
  ###
  itemUse: ->
    wi = @findWindowTree (o) -> o instanceof rpg.WindowItemList
    wa = @findWindowTree (o) -> o instanceof rpg.WindowItemActorList
    i = wi.item
    a = wa.actor
    return if i.scope.type == ITEM_SCOPE.TYPE.ENEMY
    if i.scope.range == ITEM_SCOPE.RANGE.ONE
      # 単体なので相手を選択
      @addWindow rpg.WindowItemTargetActorList parent: @
      @active = false
    if i.scope.range == ITEM_SCOPE.RANGE.MULTI
      # 複数対象なのでこの場で使う
      a.useItem i
    return

  ###* わたすメニュー
  * @memberof rpg.WindowItemMenu#
  ###
  itemTrade: ->
    @addWindow rpg.WindowItemTradeActorList parent: @
    @active = false
    return

  ###* 捨てるメニュー
  * @memberof rpg.WindowItemMenu#
  ###
  itemThrow: ->
    @active = false
    wi = @findWindowTree (o) -> o instanceof rpg.WindowItemList
    wa = @findWindowTree (o) -> o instanceof rpg.WindowItemActorList
    self = @
    wa.actor.backpack.removeItem wi.item
    eg = rpg.EventGenerator()
    eg.itemThrow(wa.actor,wi.item)
    eg.function ->
      self.close()
      wa.changeActor(wa.actor)
      if wi.items.length == 0
        wa.active = true
        wi.active = false
      if wi.items.length <= wi.index
        wi.setIndex(wi.items.length - 1)
    rpg.system.mapInterpreter.start eg.commands
