###*
* @file WindowStatusEquip.coffee
* アクター装備ステータス
###

tm.define 'rpg.WindowStatusEquip',
  superClass: rpg.Window

  ###* コンストラクタ
  * @classdesc アクター装備ステータス
  * @constructor rpg.WindowStatusEquip
  * @param {Object} args
  ###
  init: (args={}) ->
    rs = rpg.system
    parent = args.parent
    detail = parent.findWindowTree (w) -> w instanceof rpg.WindowStatusDetail
    info = parent.findWindowTree (w) -> w instanceof rpg.WindowStatusInfo
    x = info.left
    y = info.bottom
    w = 24 * 8 + 16 * 2
    h = rs.lineHeight * 7 + 16 * 2
    @superInit(x,y,w,h,args)

  ###* 装備一覧に書き換え
  * @memberof rpg.WindowStatusDetail#
  * @param {prg.Actor} actor アクター
  * @_private
  ###
  _refreshEquip: (actor) ->
    x = 0
    y = 0
    @content.clear()
    if actor?
      for k in rpg.constants.EQUIP_POSITONS
        if actor[k]?.name?
          @drawText(actor[k].name,x,y)
          y += rpg.system.lineHeight
    @refresh()

  ###* 指定アクターを描画
  * @memberof rpg.WindowStatusEquip#
  * @param {prg.Actor} actor アクター
  ###
  # selectActor: (actor) ->

  ###* 指定アクターを描画
  * @memberof rpg.WindowStatusEquip#
  * @param {prg.Actor} actor アクター
  ###
  changeActor: (actor) ->
    @_refreshEquip(actor)
