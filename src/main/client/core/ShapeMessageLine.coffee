
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
      speed: 4
      repeat: false
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

    @sleep().hide()

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
    c.font         = @font
    c.textBaseline = @textBaseline
    c.textAlign    = @textAlign
    c.fillStyle    = @fillStyle
    c.strokeStyle  = @strokeStyle ? @fillStyle
    c.lineWidth    = @lineWidth
    c.shadowBlur   = @shadowBlur
    c.shadowColor  = @shadowColor
    w = x = y = 0
    while i < text.length
      [x,y,i] = markup.draw(@,x,y,text,i)
      ch = text[i]
      cw = @measureTextWidth(ch,@font)
      if (@width <= x + cw) or (y != 0)
        break
      c.fillText(ch, x, @fontSize / 2)
      x += cw
      w += cw
      i += 1
    @textWidth = w
    c.context.restore()
    return i

  reset: ->
    @_clip.width = 0
    return @

  start: ->
    return if @textWidth is 0
    @reset().wakeUp().show()
    @fire tm.event.Event("start")

  restart: ->
    @wakeUp()
    @fire tm.event.Event("restart")

  stop: ->
    @sleep()
    @fire tm.event.Event("stop")

  # 更新処理
  update: (app) ->
    if @_clip.width <= @textWidth
      @_clip.width += @speed
    else if @repeat
      @reset().wakeUp()
      @fire tm.event.Event("repeat")
    else
      @stop()
      @fire tm.event.Event("end")

rpg.ShapeMessageLine.prototype.getter 'font', -> "{fontWeight} {fontSize}px {fontFamily}".format(@)
