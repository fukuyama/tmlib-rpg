
# アクターステータス情報
tm.define 'rpg.WindowStatusInfo',
  superClass: rpg.Window

  # 初期化
  init: (args={}) ->
    #parent = args.parent
    {x,y,w,h} = args.$extend {
      w: 24 * 5 + 16 * 2
      h: 100
    }
    @superInit(x,y,w,h,args)

  # 指定アクターを描画
  drawActor: (@actor) ->
    @content.clear()
    if @actor?
      @drawText(@actor.name,0,0)
    @refresh()
