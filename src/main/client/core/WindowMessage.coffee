
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

  # 状態クリア
  clear: ->
    @_messages = []
    @_message = null
    @_dx = @_dy = 0
    @_currentIndex = 0
    @_waitCount = 0
    @speed = 15
    @content.clear()

  # メッセージを設定
  setMessage: (msg) ->
    @open()
    @_messages = if msg instanceof Array then [].concat(msg) else [msg]
    @_message = @_messages.shift()
    @_currentIndex = 0
    @_dx = @_dy = 0
    @

  # ポーズ状態かどうか
  isPause: -> @_message is null
  
  # 表示するメッセージが無い場合 true
  isEmpty: -> @_messages.length == 0

  # 描画タイミングの計算
  countDrawTiming: ->
    @_waitCount = @_waitCount++ % @speed
    @_waitCount != 0

  # 描画する文字の取得
  nextDrawMessage: ->
    m = @_message[@_currentIndex++]
    if @_message.length <= @_currentIndex
      @_message = null
    m

  # メッセージを描画する
  drawMessage: (msg) ->
    @drawText(msg, @_dx, @_dy)
    @_dx += @measureText(msg).width
    @refresh()

  # TEMPメッセージの確認
  checkTempMessage: ->
    return unless rpg.system.temp.message?
    @setMessage rpg.system.temp.message
    rpg.system.temp.message = null
    if rpg.system.temp.messageEndProc?
      if rpg.system.scene?
        _fn = (->
          rpg.system.temp.messageEndProc()
          rpg.system.temp.messageEndProc = null
          rpg.system.scene.windowMessage.removeEventListener(
            'close'
            _fn
          )
        ).bind(@)
        rpg.system.scene.windowMessage.addEventListener('close',_fn)

  # 更新処理
  update: ->
    rpg.Window.prototype.update.apply(@)
    @checkTempMessage()
    return if @isPause()
    return if @countDrawTiming()
    @drawMessage @nextDrawMessage()

  input_ok_up: ->
    return unless @isPause()
    if @isEmpty()
      rpg.system.app.keyboard.clear()
      @close()
    else
      @_dx = @_dy = 0
      @_currentIndex = 0
      @_waitCount = 0
      @speed = 15
      @content.clear()
      @_message = @_messages.shift()
