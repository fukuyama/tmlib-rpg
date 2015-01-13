
# スプライトカーソルクラス
tm.define 'rpg.SpriteCursor',

  superClass: tm.display.RectangleShape

  # 初期化
  init: (@menuWindow, args='sample.cursor') ->
    args = tm.asset.AssetManager.get(args).data if typeof args == 'string'
    {
      @index
      @padding
      fillStyle
      strokeStyle
    } = {
      index: 0
      padding: 4
      fillStyle: 'rgba(255,255,255,0.2)'
      strokeStyle: 'rgba(255,255,255,1.0)'
    }.$extend args
    @superInit {
      strokeStyle: strokeStyle
      fillStyle: fillStyle
    }
    delete args[k] for k, v of args when not v?
    @origin.set(0, 0)

    @reset()
    return

  # 再更新
  ###
  refresh: () ->
    @renderRectangle
      strokeStyle: @borderColor
      fillStyle: @color
  ###

  # リサイズ
  resize: (@width = @menuWindow.menuWidth, @height = @menuWindow.menuHeight) ->
    @canvas.resize(@width, @height)

  # 再設定
  reset: (args = {}) ->
    @resize()
    # @refresh()
    @render()
    @setIndex()
    return

  # カーソル位置設定
  setIndex: (@index = @index) ->
    # 範囲チェック
    if 0 <= @index and @index < @menuWindow.menuRects.length
      {@x, @y} = @menuWindow.menuRects[@index]
      @visible = true
    else
      # 範囲外の場合は、カーソルを消す
      @visible = false
    @
