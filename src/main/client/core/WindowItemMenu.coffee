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

    wi = parent.findWindowTree (o) -> o instanceof rpg.WindowItemList
    item = wi.item
    wa = parent.findWindowTree (o) -> o instanceof rpg.WindowItemActorList
    actor = wa.actor

    m = []
    if item instanceof rpg.EquipItem
      if actor[item.position] == item # インスタンス比較
        m.push name:'はずす', fn: @itemEquipOff.bind @
      else
        m.push name:'そうび', fn: @itemEquip.bind @
    else
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
    wm = @
    wi = @findWindowTree (o) -> o instanceof rpg.WindowItemList
    i = wi.item
    wa = @findWindowTree (o) -> o instanceof rpg.WindowItemActorList
    a = wa.actor

    @active = false
    if i.usable and
    i.scope.type == ITEM_SCOPE.TYPE.FRIEND and
    i.scope.range == ITEM_SCOPE.RANGE.ONE
      # 単体なので相手を選択
      @addWindow rpg.WindowItemTargetActorList parent: @
      return

    eg = rpg.EventGenerator()
    if i.usable
      if i.scope.type == ITEM_SCOPE.TYPE.ENEMY
        eg.itemUseError a, i
      if i.scope.type == ITEM_SCOPE.TYPE.FRIEND and
      i.scope.range == ITEM_SCOPE.RANGE.MULTI
        # 複数対象なのでこの場で使う
        targets = []
        rpg.game.party.each (a) -> targets.push a
        log = rpg.system.temp.log = {}
        r = a.useItem i, targets, log
        if r
          eg.itemUseOk a, i, targets, log
        else
          eg.itemUseNg a, i, targets, log
    else
      # 使用できないアイテム
      eg.itemUseError a, i
    eg.function ->
      wm.close()
      wa.changeActor(wa.actor)
      if wi.items.length == 0
        wa.active = true
        wi.active = false
      if wi.items.length <= wi.index
        wi.setIndex(wi.items.length - 1)
    rpg.system.mapInterpreter.start eg.commands
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
    # TODO: 捨てられなかった時の処理（メッセージを追加）
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
    return

  ###* 装備メニュー
  * @memberof rpg.WindowItemMenu#
  ###
  itemEquip: ->
    @active = false
    wi = @findWindowTree (o) -> o instanceof rpg.WindowItemList
    item = wi.item
    wa = @findWindowTree (o) -> o instanceof rpg.WindowItemActorList
    actor = wa.actor
    eg = rpg.EventGenerator()
    if item instanceof rpg.EquipItem
      if actor.checkEquip item.position, item
        # 装備可能
        actor[item.position] = item
        eg.itemEquip(actor,item)
      else
        # 装備不可
        eg.itemEquipError(actor,item)
    self = @
    eg.function ->
      self.close()
      wa.changeActor(wa.actor)
    rpg.system.mapInterpreter.start eg.commands
    return

  ###* はずすメニュー
  * @memberof rpg.WindowItemMenu#
  ###
  itemEquipOff: ->
    console.log 'itemEquipOff'
    return

