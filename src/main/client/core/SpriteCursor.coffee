
# スプライトカーソルクラス
tm.define 'rpg.SpriteCursor',

  superClass: tm.app.Shape

  # 初期化
  init: (@parent, args='sample.cursor') ->
    @superInit()
    args = tm.asset.AssetManager.get(args) if typeof args == 'string'
    delete args[k] for k, v of args when not v?
    @origin.set(0, 0)
    {
      @index
      @padding
      @color
      @borderColor
    } = {
      index: 0
      padding: 4
      color: 'rgba(255,255,255,0.2)'
      borderColor: 'rgba(255,255,255,1.0)'
    }.$extend args

    @reset()

  # 再更新
  refresh: () ->
    @renderRectangle
      strokeStyle: @borderColor
      fillStyle: @color

  # リサイズ
  resize: (width, height) ->
    @canvas.resize(@width = width, @height = height)

  # 再設定
  reset: () ->
    cols = @parent.cols
    rows = @parent.rows
    w = @parent.innerRect.width / cols
    h = @parent.innerRect.height / rows | 0
    @resize(w + @padding, h + @padding)
    @refresh()
    @index_positions = []
    pw = (@parent.width - @parent.innerRect.width) / 2 - @padding / 2
    ph = (@parent.height - @parent.innerRect.height) / 2 - @padding / 2
    for c in [0..cols]
      for r in [0..rows]
        @index_positions.push
          x: c * w + pw
          y: r * h + ph
    @setIndex()
  
  # カーソル位置設定
  setIndex: (index = @index) ->
    @index = index
    {@x, @y} = @index_positions[@index]
