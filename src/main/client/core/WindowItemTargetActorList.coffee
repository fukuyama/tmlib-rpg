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
    wi = @findWindowTree (o) -> o instanceof rpg.WindowItemList
    wa = @findWindowTree (o) -> o instanceof rpg.WindowItemActorList
    i = wi.item
    a = wa.actor
    r = a.useItem i, target
    console.log r
    return
