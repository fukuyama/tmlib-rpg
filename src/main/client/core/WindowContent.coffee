
# ウィンドウコンテントクラス
tm.define 'rpg.WindowContent',
  superClass: tm.graphics.Canvas

  # 初期化
  init: (@innerRect) ->
    @superInit()
    @shape = tm.display.Shape(@innerRect.width,@innerRect.height)
    @shape.origin.set(0,0)
    @shape.x = @innerRect.x
    @shape.y = @innerRect.y
    
    # 転送元座標
    @_px = @_py = @ox = @oy = 0
    
    # アルファ値
    @alpha = 1.0

    # コンテンツサイズ初期値（はみ出ない感じ）
    @resize(@innerRect.width, @innerRect.height)

    @clearColor('rgba(0,0,0,0)')

    @shape.update = @update

  drawTo: ->
    @shape.x = @innerRect.x
    @shape.y = @innerRect.y
    @shape.canvas.clear()
    return if @innerRect.width == 0 or @innerRect.height == 0
    @shape.canvas.drawImage(
      @canvas
      @ox, @oy, @innerRect.width, @innerRect.height
      0, 0, @innerRect.width, @innerRect.height
    )

  update: ->
    if @ox != @_px or @oy != @_py
      @drawTo()
      @_px = @ox
      @_py = @oy
