
tm.define 'rpg.WindowMessage',
  superClass: rpg.Window

  # 初期化
  init: (args={}) ->
    delete args[k] for k, v of args when not v?
    @superInit(
      0, 0
      rpg.system.screen.width, rpg.system.lineHeight * 4
      args
    )

    {
      @visible
      @active
    } = {
      visible: false
      active: false
    }.$extend(args)
    
    @addEventListener 'close',@clear.bind(@)

    @clear()

  clear: ->
    @_message = null
    @_dx = @_dy = 0
    @_currentIndex = 0
    @_waitCount = 0
    @speed = 15
    @content.clear()

  setMessage: (msg) ->
    @open()
    @_message = msg
    @_currentIndex = 0
    @_dx = @_dy = 0

  isEmpty: ->
    @_message == null or @_message == '' or @_message.length <= @_currentIndex

  countDrawTiming: ->
    @_waitCount = @_waitCount++ % @speed
    @_waitCount != 0

  getDrawMessage: ->
    @_message[@_currentIndex++]

  drawMessage: (msg) ->
    @drawText(msg, @_dx, @_dy)
    @_dx += @measureText(msg).width
    @refresh()

  update: ->
    rpg.Window.prototype.update.apply(@)
    return if @isEmpty()
    return if @countDrawTiming()
    @drawMessage @getDrawMessage()

  input_ok: ->
    if @isEmpty()
      @close()
