###*
* @file WindowItemTargetActorList.coffee
* アイテムターゲット一覧用メンバーリストウィンドウ
###

# アイテムターゲット一覧用メンバーリストウィンドウ
tm.define 'rpg.WindowItemTargetActorList',

  superClass: rpg.WindowMemberBase

  ###* コンストラクタ
  * @classdesc アイテムターゲット一覧用メンバーリストウィンドウ
  * @constructor rpg.WindowItemTargetActorList
  * @param {Object} args
  ###
  init: (args={}) ->
    @superInit(args.$extend {
      name: 'ItemTargetActorList'
      title: 'だれに？'
    })
    parent = args.parent
    @x = parent.right
    @y = 16

  ###* アクターが変更された場合の処理
  * @memberof rpg.WindowItemTargetActorList#
  * @param {rpg.Actor} actor アクター
  ###
  changeActor: (actor) ->
    return

  ###* アクターが選択された場合の処理
  * @memberof rpg.WindowItemTargetActorList#
  * @param {rpg.Actor} target アクター
  ###
  selectActor: (target) ->
    @active = false
    wi = @findWindowTree (o) -> o instanceof rpg.WindowItemList
    wa = @findWindowTree (o) -> o instanceof rpg.WindowItemActorList
    wm = @findWindowTree (o) -> o instanceof rpg.WindowItemMenu
    i = wi.item
    a = wa.actor
    log = rpg.system.temp.log = {}
    r = a.useItem i, target, log
    eg = rpg.EventGenerator()
    if r
      eg.itemUseOk a, i, target, log
    else
      eg.itemUseNg a, i, target, log
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
