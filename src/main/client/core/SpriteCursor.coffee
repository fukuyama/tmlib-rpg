
# スプライトカーソルクラス
tm.define 'rpg.SpriteCursor',

  superClass: tm.display.RectangleShape

  # 初期化
  init: (args={}) ->
    args = tm.asset.AssetManager.get(args).data if typeof args == 'string'
    {
      @index
      @padding
      @positions
      width
      height
      fillStyle
      strokeStyle
    } = {
      index: 0
      padding: 2
      fillStyle: 'rgba(255,255,255,0.2)'
      strokeStyle: 'rgba(255,255,255,1.0)'
    }.$extend args
    @superInit {
      width: width + @padding * 2
      height: height + @padding * 2
      strokeStyle: strokeStyle
      fillStyle: fillStyle
    }
    @origin.set(0, 0)
    @reset()
    return

  # リサイズ
  resize: (width, height) ->
    if width?
      @width = width + @padding * 2
    if height?
      @height = height + @padding * 2
    @canvas.resize(@width, @height)

  # 再設定
  reset: ->
    @resize()
    @render()
    @setIndex()
    return

  # カーソル位置設定
  setIndex: (@index = @index) ->
    # 範囲チェック
    if 0 <= @index and @index < @positions.length
      {@x, @y} = @positions[@index]
      @x -= @padding
      @y -= @padding
      @visible = true
    else
      # 範囲外の場合は、カーソルを消す
      @visible = false
    @
