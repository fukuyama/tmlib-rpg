
###*
* @file ShapeMessageLine.coffee
* メッセージライン
###

dummyCanvas = null

tm.define 'rpg.ShapeMessageLine',

  superClass: 'tm.display.CanvasElement'

  init: (param={}) ->
    @superInit()
    {
      @x
      @y
      @width
      @height
      @speed
      @repeat
      @textBaseline
      @textAlign
      @fillStyle
      @fontWeight
      @fontFamily
      @lineWidth
      @shadowBlur
      @shadowColor
    } = {
      x: 0
      y: 0
      width: 100
      height: 24
      speed: 4
      repeat: false
      textBaseline: 'middle'
      textAlign: 'left'
      fillStyle: 'rgb(255,255,255)'
      fontWeight: ''
      fontFamily: "'HiraKakuProN-W3'"
      lineWidth: 2
      shadowBlur: 0
      shadowColor: 'red'
    }.$extend param
    @setOrigin(0,0)

    @fontSize = @height

    @_text = tm.display.Shape
      width: @width
      height: @height
    @_text.setOrigin(0,0)

    @_clip = tm.display.Shape
      width: @width
      height: @height
    @_clip.setOrigin(0,0)

    @_clip.clipping = true

    @_clip.addChildTo @
    @_text.addChildTo @_clip

    @awake = false
    @hide()

  measureTextWidth: (text,font) ->
    dummyCanvas = tm.graphics.Canvas() unless dummyCanvas?
    dummyCanvas.font = font
    return dummyCanvas.context.measureText(text).width

  ###* マークアップテキストの描画
  * @memberof rpg.ShapeMessageLine#
  * @param {String} text マークアップテキスト
  * @param {Object} param パラメータ
  ###
  drawMarkup: (text,param={}) ->
    {
      i
      markup
    } = {
      i: 0
      markup: rpg.MarkupText.default
    }.$extend param
    x = y = 0
    w = 0
    while i < text.length
      [x,y,i] = markup.draw(@,x,y,text,i)
      c = text[i]
      cx = @measureTextWidth(c,@font)
      if (@width <= x + cx) or (y != 0)
        break
      @drawText(c,x,y)
      x += cx
      w += cx
      i += 1
    @textWidth = w
    return i

  drawText: (text,x,y) ->
    c = @_text.canvas
    c.context.save()
    c.font         = @font
    c.textBaseline = @textBaseline
    c.textAlign    = @textAlign
    c.fillStyle    = @fillStyle
    c.strokeStyle  = @strokeStyle ? @fillStyle
    c.lineWidth    = @lineWidth
    c.shadowBlur   = @shadowBlur
    c.shadowColor  = @shadowColor
    c.fillText(text, x, @fontSize / 2)
    c.context.restore()
    return

  reset: ->
    @_clip.width = 0
    @awake = true
    @show()

  start: ->
    @reset()
    @fire tm.event.Event("start")

  restart: ->
    @awake = true
    @fire tm.event.Event("restart")

  stop: ->
    @awake = false
    @fire tm.event.Event("stop")

  # 更新処理
  update: (app) ->
    if @_clip.width <= @textWidth
      @_clip.width += @speed
    else if @repeat
      @reset()
      @fire tm.event.Event("repeat")
    else
      @stop()
      @fire tm.event.Event("end")

rpg.ShapeMessageLine.prototype.getter 'font', -> "{fontWeight} {fontSize}px {fontFamily}".format(@)
