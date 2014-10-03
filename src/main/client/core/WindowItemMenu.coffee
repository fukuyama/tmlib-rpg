###*
* @file WindowItemMenu.coffee
* アイテムメニュー
###

ITEM_SCOPE = rpg.constants.ITEM_SCOPE

tm.define 'rpg.WindowItemMenu',

  superClass: rpg.WindowMenu

  wi: (w=@) ->
    unless @_wi?
      @_wi = w.findWindowTree (o) -> o instanceof rpg.WindowItemList
    return @_wi

  wa: (w=@) ->
    unless @_wa?
      @_wa = w.findWindowTree (o) -> o instanceof rpg.WindowItemActorList
    return @_wa

  item: (w=@) ->
    return @wi(w).item

  actor: (w=@) ->
    return @wa(w).actor

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

    item = @item parent
    actor = @actor parent

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
    wa = @wa parent
    @x = wa.right - @width
    @y = wa.bottom

  ###* 使うメニュー
  * @memberof rpg.WindowItemMenu#
  ###
  itemUse: ->
    @active = false
    self = @
    wi = @wi()
    wa = @wa()
    item = @item()
    actor = @actor()

    @active = false
    if item.usable and
    item.scope.type == ITEM_SCOPE.TYPE.FRIEND and
    item.scope.range == ITEM_SCOPE.RANGE.ONE
      # 単体なので相手を選択
      @addWindow rpg.WindowItemTargetActorList parent: @
      return

    eg = rpg.EventGenerator()
    if item.usable
      if item.scope.type == ITEM_SCOPE.TYPE.ENEMY
        eg.itemUseError actor, item
      if item.scope.type == ITEM_SCOPE.TYPE.FRIEND and
      item.scope.range == ITEM_SCOPE.RANGE.MULTI
        # 複数対象なのでこの場で使う
        targets = []
        rpg.game.party.each (a) -> targets.push a
        log = rpg.system.temp.log = {}
        r = actor.useItem item, targets, log
        if r
          eg.itemUseOk actor, item, targets, log
        else
          eg.itemUseNg actor, item, targets, log
    else
      # 使用できないアイテム
      eg.itemUseError actor, item
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
    self = @
    wi = @wi()
    wa = @wa()
    item = @item()
    actor = @actor()

    actor.backpack.removeItem item
    eg = rpg.EventGenerator()
    eg.itemThrow(actor,item)
    eg.function ->
      self.close()
      wa.changeActor(actor)
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
    self = @
    wi = @wi()
    wa = @wa()
    item = @item()
    actor = @actor()

    # メッセージの作成と装備処理
    eg = rpg.EventGenerator()
    if item instanceof rpg.EquipItem
      if actor.checkEquip item.position, item
        # 装備可能
        actor[item.position] = item
        eg.itemEquip(actor,item)
      else
        # 装備不可
        eg.itemEquipError(actor,item)
    eg.function ->
      self.close()
      wa.changeActor(wa.actor)
    rpg.system.mapInterpreter.start eg.commands
    return

  ###* はずすメニュー
  * @memberof rpg.WindowItemMenu#
  ###
  itemEquipOff: ->
    @active = false
    self = @
    wi = @wi()
    wa = @wa()
    item = @item()
    actor = @actor()

    # メッセージの作成と装備解除処理
    eg = rpg.EventGenerator()
    if item instanceof rpg.EquipItem
      if actor.checkEquipOff item
        # 装備解除可能
        actor[item.position] = null
        eg.itemEquipOff(actor,item)
      else
        # 装備解除不可
        eg.itemEquipOffError(actor,item)
    self = @
    eg.function ->
      self.close()
      wa.changeActor(wa.actor)
    rpg.system.mapInterpreter.start eg.commands
    return
