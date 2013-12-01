
MSG_TOP = 1
MSG_CENTER = 2
MSG_BOTTOM = 3

SEL_LEFT = 1
SEL_CENTER = 2
SEL_RIGHT = 3

tm.define 'rpg.WindowMessage',
  superClass: rpg.Window

  # 初期化
  init: (args={}) ->
    delete args[k] for k, v of args when not v?
    @superInit(
      0, 0
      Math.min(rpg.system.screen.width,640 - 32),
      rpg.system.lineHeight * 4
      args
    )

    {
      @visible
      @active
      @options
    } = {
      visible: false
      active: false
      options:
        message:
          position: MSG_BOTTOM # メッセージウィンドウ位置
        select:
          position: SEL_RIGHT # 選択肢ウィンドウ位置
    }.$extend(args)
    
    @markup = new rpg.MarkupText()
    
    @addOpenListener((->
      @setDisplayPosition()
    ).bind(@))

    @addCloseListener((->
      @windowMenu.close() if @windowMenu?
      @clear()
    ).bind(@))

    @clear()

  # 状態クリア
  clear: ->
    @_messages = []
    @_message = null
    @_dx = @_dy = 0
    @_messageIndex = 0
    @_waitCount = 0
    @speed = 15
    @content.clear()

  # メッセージを設定
  setMessage: (msg) ->
    @open()
    @_messages = if msg instanceof Array then [].concat(msg) else [msg]
    @_message = @_messages.shift()
    @_messageIndex = 0
    @_dx = @_dy = 0
    @

  # 表示位置設定
  setDisplayPosition: (options=@options) ->
    msgop = options.message
    # x座標は真ん中
    @centering('horizon')
    # y座標は上中下
    switch msgop.position
      when MSG_TOP then @y = 0
      when MSG_CENTER then @centering('vertical')
      when MSG_BOTTOM then @y = rpg.system.screen.height - @height
    if @windowMenu?
      # 選択肢表示位置
      switch options.select.position
        when SEL_LEFT then @windowMenu.x = @left
        when SEL_CENTER then @windowMenu.center()
        when SEL_RIGHT then @windowMenu.x = @right - @windowMenu.width
      if msgop.position is MSG_TOP
        @windowMenu.y = @bottom
      else
        @windowMenu.y = @top - @windowMenu.height
    @

  # ポーズ状態の場合 true
  isPause: -> @_message is null or @_message.length <= @_messageIndex
  
  # 表示するメッセージが無い場合 true
  isEmpty: -> @_messages.length == 0

  # 選択肢表示中の場合 true
  isSelect: -> @windowMenu?

  # 描画タイミングの計算
  countDrawTiming: ->
    @_waitCount = @_waitCount++ % @speed
    @_waitCount != 0

  # メッセージを描画する
  drawMessage: (msg) ->
    @drawText(msg, @_dx, @_dy)
    @_dx += @measureText(msg).width
    @refresh()

  # 選択肢ウィンドウの作成
  createSelectWindow: (args={}) ->
    {
      select
      options
      callback
    } = args

    _menuFunc = ->
      callback(@windowMenu.index) if callback?
      @windowMenu.close()
      @pauseCancel()
    menus = ({name:name,fn:_menuFunc.bind(@)} for name in select)

    @windowMenu = rpg.WindowMenu({
      visible: false
      active: false
      menus: menus
    }.$extend options)
    @windowMenu.addCloseListener((->
      @windowMenu.remove()
      @windowMenu = null
      @active = true
    ).bind(@))
    @windowMenu.open()
    @parent.addChild(@windowMenu)
    @active = false
    @setDisplayPosition()

  # TEMPメッセージの確認
  checkTempMessage: ->
    return unless rpg.system.temp.message?

    msg = rpg.system.temp.message
    endProc = rpg.system.temp.messageEndProc
    rpg.system.temp.message = null
    rpg.system.temp.messageEndProc = null

    @setMessage(msg)
    @onceCloseListener(endProc) if endProc?

  # 選択肢の確認
  checkTempSelect: ->
    return unless rpg.system.temp.select?
    return unless @isPause() and @isEmpty()
    @createSelectWindow(
      select: rpg.system.temp.select
      options: rpg.system.temp.selectOptions
      callback: rpg.system.temp.selectEndProc
    )
    rpg.system.temp.select = null
    rpg.system.temp.selectOptions = null
    rpg.system.temp.selectEndProc = null

  # 更新処理
  update: ->
    rpg.Window.prototype.update.apply(@)
    @checkTempMessage()
    @checkTempSelect()
    return if @isClose()
    return if @isSelect()
    return if @isPause()
    return if @countDrawTiming()
    return if @processMarkup()
    @drawMessage @_message[@_messageIndex++]

  # マークアップ処理
  processMarkup: ->
    [@_dx, @_dy, @_messageIndex] =
    @markup.draw(@, @_dx, @_dy, @_message, @_messageIndex)
    false

  pauseCancel: ->
    if @isEmpty()
      rpg.system.app.keyboard.clear()
      @close()
    else
      @_dx = @_dy = 0
      @_messageIndex = 0
      @_waitCount = 0
      @speed = 15
      @content.clear()
      @_message = @_messages.shift()
  
  input_ok_up: ->
    if @isPause()
      @pauseCancel()
