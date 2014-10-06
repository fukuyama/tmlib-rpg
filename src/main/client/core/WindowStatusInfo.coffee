
# アクターステータス情報
tm.define 'rpg.WindowStatusInfo',
  superClass: rpg.Window

  # 初期化
  init: (args={}) ->
    rs = rpg.system
    parent = args.parent
    detail = parent.findWindowTree (w) -> w instanceof rpg.WindowStatusDetail
    x = detail.right
    y = 16
    w = 24 * 8 + 16 * 2
    h = rs.lineHeight * 4 + 16 * 2
    @superInit(x,y,w,h,args)

  # 指定アクターを描画
  changeActor: (actor) ->
    @content.clear()
    if actor?
      @drawText(actor.name,0,0)
    @refresh()
