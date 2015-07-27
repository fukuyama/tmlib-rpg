
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
      @repeat
      @textColor
      @fontWeight
      @fontFamily
    } = {
      x: 0
      y: 0
      width: 100
      height: 24
      text: null
      speed: 4
      repeat: false
      textColor: 'rgb(255,0,0)'
      fontWeight: ''
      fontFamily: "'HiraKakuProN-W3'"
    }.$extend param
    @setOrigin(0,0)

    @fontSize = @height
    @font = "{fontWeight} {fontSize}px {fontFamily}".format(@)

    @_text = tm.display.Shape
      width: @width
      height: @height
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

    @_text.render() if @text?

    @_mask = tm.display.Shape
      width: @width
      height: @height
    @_mask.setOrigin(0,0)

    @_text.clipping = true
    @_mask.clipping = true

    @_mask.addChildTo @
    @_text.addChildTo @_mask

    @awake = false
    @hide()

  setText: (@text) ->
    dummyCanvas = tm.graphics.Canvas() unless dummyCanvas?
    dummyCanvas.font = @font
    @textWidth = dummyCanvas.context.measureText(@text).width + @height / 2
    @_text.render()

  reset: ->
    @_mask.width = 0
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
    if @_mask.width <= @textWidth
      @_mask.width += @speed
    else if @repeat
      @reset()
      @fire tm.event.Event("repeat")
    else
      @stop()
      @fire tm.event.Event("end")
