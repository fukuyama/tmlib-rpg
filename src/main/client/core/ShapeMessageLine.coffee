
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
      @text
      @speed
      @boundary
      @repeat
      @textColor
      @fontWeight
      @fontFamily
    } = {
      x: 0
      y: 0
      width: 100
      height: 24
      text: 'test'
      speed: 4
      boundary: 50
      repeat: false
      textColor: 'rgb(255,0,0)'
      fontWeight: ''
      fontFamily: "'HiraKakuProN-W3'"
    }.$extend param

    @fontSize = @height
    @font = "{fontWeight} {fontSize}px {fontFamily}".format(@)

    @_text = tm.display.Shape
      width: @width
      height: @height
      blendMode: 'source-in'
    @_text.setOrigin(0,0)
    @_text._render = (->
      c = @_text.canvas
      c.context.save()
      c.font = @font
      c.textBaseline = 'top'
      c.textAlign = 'left'
      c.fillStyle = @textColor
      c.fillText(@text, 0, 0)
      c.context.restore()
      return
    ).bind @
    @_text.clipping = true
    @_text.render()

    boundary = @boundary
    bmp = tm.graphics.Bitmap(@width, @height)
    bmp.width  = @width + @boundary
    bmp.height = @height
    bmp.filter
      calc: (pixel,index,x,y,self) ->
        n = self.width - x
        if n < boundary
          n = n / boundary * 255
        else
          n = 255
        self.setPixel32Index(index,0,0,0,n)
        return

    @_mask = tm.display.Shape
      width: bmp.width
      height: @height
    @_mask.setOrigin(0,0)
    @_mask.canvas.drawBitmap(bmp,0,0)

    @_mask.addChildTo @
    @_mask.addChild @_text

    dummyCanvas = tm.graphics.Canvas() unless dummyCanvas?
    dummyCanvas.font = @font
    @textWidth = dummyCanvas.context.measureText(@text).width + @height / 2

    @_start = {
      mask: - @width
      text: + @width
    }
    @awake = false
    @hide()

  start: ->
    @_mask.x = @_start.mask
    @_text.x = @_start.text
    @awake = true
    @show()
    @fire tm.event.Event("start")

  stop: ->
    @awake = false
    @fire tm.event.Event("stop")

  # 更新処理
  update: (app) ->
    if @_mask.x - @boundary < @textWidth + @_start.mask
      @_mask.x += @speed
      @_text.x -= @speed
    else if @repeat
      @fire tm.event.Event("repeat")
      @start()
    else
      @stop()
      @fire tm.event.Event("end")
