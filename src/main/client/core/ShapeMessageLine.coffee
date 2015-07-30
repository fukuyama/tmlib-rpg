
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
      @fontSize
      @lineWidth
      @shadowBlur
      @shadowColor
    } = {
      x: 0
      y: 0
      width: 100
      height: 24
      repeat: false

      speed: 4
      textBaseline: 'middle'
      textAlign: 'left'
      fillStyle: 'rgb(255,255,255)'
      fontWeight: ''
      fontFamily: "'HiraKakuProN-W3'"
      fontSize: null
      lineWidth: 2
      shadowBlur: 0
      shadowColor: 'red'
    }.$extend param
    @setOrigin(0,0)

    @textWidth = 0
    @fontSize = @height unless @fontSize?

    @_waits = []

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

    @reset()
    @sleep()
    @hide()

  getOptions: ->
    return {
      speed:        @speed
      textBaseline: @textBaseline
      textAlign:    @textAlign
      fillStyle:    @fillStyle
      fontWeight:   @fontWeight
      fontFamily:   @fontFamily
      fontSize:     @fontSize
      lineWidth:    @lineWidth
      shadowBlur:   @shadowBlur
      shadowColor:  @shadowColor
    }

  setOptions: (op) ->
    @$extend op

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
    c = @_text.canvas
    c.context.save()
    w = x = y = 0
    while i < text.length
      [x,y,i] = markup.draw(@,x,y,text,i)
      ch = text[i]
      unless ch?
        break
      cw = @measureTextWidth(ch,@font)
      if (@width <= x + cw) or (y != 0)
        break
      c.font         = @font
      c.textBaseline = @textBaseline
      c.textAlign    = @textAlign
      c.fillStyle    = @fillStyle
      c.strokeStyle  = @strokeStyle ? @fillStyle
      c.lineWidth    = @lineWidth
      c.shadowBlur   = @shadowBlur
      c.shadowColor  = @shadowColor
      c.fillText(ch, x, @fontSize / 2)
      x += cw
      w += cw
      i += 1
    @textWidth = w
    c.context.restore()
    return i

  addWait: (time,width) ->
    @_waits.push
      time: time
      width: width
      count: 0

  reset: ->
    @_clip.width = 0
    return @

  start: ->
    return if @textWidth is 0
    @reset()
    @wakeUp()
    @show()
    @fire tm.event.Event("start")

  restart: ->
    @wakeUp()
    @fire tm.event.Event("restart")

  stop: ->
    @sleep()
    @fire tm.event.Event("stop")

  # 更新処理
  update: (app) ->
    if @_wait?
      if @_wait.count < @_wait.time
        @_wait.count += 1
        return
      else
        @_wait = undefined
    else if @_waits.length > 0
      if @_clip.width + @speed > @_waits[0].width
        @_wait = @_waits.shift()
        @_clip.width = @_wait.width
        return
    if @_clip.width < @textWidth
      @_clip.width = Math.min(@_clip.width + @speed,@textWidth)
    else if @repeat
      @reset()
      @wakeUp()
      @fire tm.event.Event("repeat")
    else
      @stop()
      @fire tm.event.Event("end")

rpg.ShapeMessageLine.prototype.getter 'font', -> "{fontWeight} {fontSize}px {fontFamily}".format(@)
