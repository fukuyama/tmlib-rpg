
# スプライトカーソルクラス
tm.define 'rpg.SpriteCursor',

  superClass: tm.display.Shape

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
    w = @parent.menuWidth
    h = @parent.menuHeight
    @resize(w + @padding, h + @padding)
    @refresh()
    @_indexPositions = []
    pw = (@parent.width - @parent.innerRect.width) / 2 - @padding / 2
    ph = (@parent.height - @parent.innerRect.height) / 2 - @padding / 2
    for r in [0...rows]
      for c in [0...cols]
        @_indexPositions.push
          x: pw + c * w + c * @parent.colPadding
          y: ph + r * h
    @setIndex()
  
  # カーソル位置設定
  setIndex: (index = @index) ->
    @index = index
    {@x, @y} = @_indexPositions[@index]

  # カーソル位置設定（ポインティング時）
  setPointing: (e) ->
    pt = @parent.globalToLocal(e.pointing)
    w = @parent.menuWidth
    h = @parent.menuHeight
    rect = tm.geom.Rect(0,0,w,h)
    for ip, i in @_indexPositions
      rect.move ip.x, ip.y
      if rect.left < pt.x and pt.x < rect.right and
      rect.top < pt.y and pt.y < rect.bottom
        @setIndex(i)
        break
