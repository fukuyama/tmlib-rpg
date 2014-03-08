
MSG_TOP = 1
MSG_CENTER = 2
MSG_BOTTOM = 3

SEL_LEFT = 1
SEL_CENTER = 2
SEL_RIGHT = 3

NUM_LEFT = 1
NUM_CENTER = 2
NUM_RIGHT = 3

tm.define 'rpg.WindowMessage',
  superClass: rpg.Window

  # 初期化
  init: (args={}) ->
    delete args[k] for k, v of args when not v?
    @superInit(0,0,0,0,args)
    # args からのインスタンス変数初期化
    {
      @visible
      @active
      @messageSpeed
      @scrollSpeed
      @maxLine
      @options
    } = {
      visible: false
      active: false
      messageSpeed: 15 # メッセージスピード
      scrollSpeed: 5 # スクロールスピード
      maxLine: 3
      options:
        message:
          position: MSG_BOTTOM # メッセージウィンドウ位置
        select:
          position: SEL_RIGHT # 選択肢ウィンドウ位置
        input_num:
          position: NUM_RIGHT # 数値入力ウィンドウ位置
    }.$extend(args)

    # リサイズ
    @resize(
      Math.min(rpg.system.screen.width,640 - 32)
      rpg.system.lineHeight * @maxLine + @borderHeight * 2)
    @resizeContent(
      @innerRect.width
      @innerRect.height * 2)

    @markup = new rpg.MarkupText()
    @markup.add(rpg.MarkupText.MARKUP_NEW_LINE)
    
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
    @_message = ''
    @_messageIndex = 0
    @_dx = @_dy = 0 # 描画座標
    @_sy = 0 # スクロール用
    @_py = 0 # ポーズ時座標
    @_ay = 0 # スクロール差分用座標
    @_waitCount = 0 # 描画時のウェイトカウント
    @content.clear()

  # メッセージを設定
  setMessage: (msg) ->
    @open()
    @_messages = if msg instanceof Array then [].concat(msg) else [msg]
    @_message = @_messages.shift()
    @_messageIndex = 0
    @_sy = @_dx = @_dy = 0
    @

  # 表示位置設定
  setDisplayPosition: (options=@options) ->
    # x座標は真ん中
    @centering('horizon')
    # y座標は上中下のいずれか
    switch options.message.position
      when MSG_TOP then @y = 0
      when MSG_CENTER then @centering('vertical')
      when MSG_BOTTOM then @y = rpg.system.screen.height - @height
    @setDisplayPositionMenu options
    @setDisplayPositionInputNum options
    @

  # 選択肢表示位置
  setDisplayPositionMenu: (options=@options) ->
    if @windowMenu?
      # 左右位置
      switch options.select.position
        when SEL_LEFT then @windowMenu.x = @left
        when SEL_CENTER then @windowMenu.center()
        when SEL_RIGHT then @windowMenu.x = @right - @windowMenu.width
      # 上下位置
      if options.message.position is MSG_TOP
        @windowMenu.y = @bottom
      else
        @windowMenu.y = @top - @windowMenu.height
    @

  # 数値入力ウィンドウ表示位置
  setDisplayPositionInputNum: (options=@options) ->
    if @windowInputNum?
      # 左右位置
      switch options.input_num.position
        when NUM_LEFT then @windowInputNum.x = @left
        when NUM_CENTER then @windowInputNum.center()
        when NUM_RIGHT then @windowInputNum.x = @right - @windowInputNum.width
      # 上下位置
      if options.message.position is MSG_TOP
        @windowInputNum.y = @bottom
      else
        @windowInputNum.y = @top - @windowInputNum.height
    @

  # ポーズ状態の場合 true
  isPause: -> @_message.length <= @_messageIndex
  
  # 表示するメッセージが無い場合 true
  isEmpty: -> @_messages.length == 0

  # 選択肢表示中の場合 true
  isSelect: -> @windowMenu?

  # 入力ウィンドウ表示中の場合 true
  isInput: -> @windowInputNum?

  # 描画タイミングの計算
  countDrawTiming: ->
    @_waitCount = @_waitCount++ % @messageSpeed
    @_waitCount != 0

  # メッセージを描画する
  drawMessage: (msg) ->
    @drawText(msg, @_dx, @_dy)
    @_dx += @measureText(msg).width
    @refresh()

  # 選択肢ウィンドウの作成
  createSelectWindow: (args={}) ->
    {
      menus
      options
      callback
    } = args

    fn = -> @windowMenu.close()
    menuAndFuncs = ({name:name,fn:fn.bind(@)} for name in menus)

    @windowMenu = rpg.WindowMenu({
      visible: false
      active: false
      cols: 1
      rows: menuAndFuncs.length
      menus: menuAndFuncs
    }.$extend options).addCloseListener((->
      callback(@windowMenu.index) if callback?
      @removeWindow(@windowMenu)
      @windowMenu = null
      @active = true
      @pauseCancel()
    ).bind(@)).open()
    @addWindow(@windowMenu)
    @active = false
    @setDisplayPosition()

  # 数値入力ウィンドウの作成
  createInputNumWindow: (args={}) ->
    {
      flag
      options
      callback
    } = args
    
    @windowInputNum = rpg.WindowInputNum(options)
    @windowInputNum.addCloseListener((->
      callback(@windowInputNum.value) if callback?
      @removeWindow(@windowInputNum)
      @windowInputNum = null
      @active = true
      @pauseCancel()
    ).bind(@)).open()
    @addWindow(@windowInputNum)
    @active = false
    @setDisplayPosition()

  # メッセージの確認
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
    return unless rpg.system.temp.selectArgs?
    return unless @isPause() and @isEmpty()
    @createSelectWindow rpg.system.temp.selectArgs
    rpg.system.temp.selectArgs = null
    @
  
  # 数値入力の確認
  checkTempInputNum: ->
    return unless rpg.system.temp.inputNumArgs?
    return unless @isPause() and @isEmpty()
    @createInputNumWindow rpg.system.temp.inputNumArgs
    rpg.system.temp.inputNumArgs = null
    @

  # オプションの確認
  checkTempOption: ->
    return unless rpg.system.temp.options?
    @options = @options.$extendAll rpg.system.temp.options
    rpg.system.temp.options = null
    @

  # スクロール処理
  scroll: ->
    # スクロール処理
    if @_sy > 0
      n = Math.pow(2, @scrollSpeed) / 256.0 * rpg.system.lineHeight
      @content.oy += n
      @_sy -= n
      return true
    # ポーズしててページ位置までスクロールしてなかったらスクロールさせる
    if @isPause() and @_py > @content.oy
      @_sy = @_py - @content.oy
      return true
    # ポーズしてて表示がずれている場合は位置調整（@content初期化）
    if @isPause() and @content.oy > 0
      @_ay = @_dy -= @content.oy # 描画位置を、現在の表示位置分戻して
      @content.oy = @_py = @_sy = 0 # 初期化
      @content.clear()
      @content.drawImage(
        @content.shape.canvas.canvas
        0, 0, @innerRect.width, @innerRect.height
        0, 0, @innerRect.width, @innerRect.height
      )
      return false
    # 描画位置が範囲を超えたら
    if @_ay != @_dy and @_dy >= rpg.system.lineHeight * @maxLine
      @_sy = rpg.system.lineHeight
      @_ay = @_dy
      return true
    return false

  # 更新処理
  update: ->
    rpg.Window.prototype.update.apply(@)
    return if @scroll()
    @checkTempOption()
    @checkTempMessage()
    @checkTempSelect()
    @checkTempInputNum()
    return if @isClose()
    return if @isSelect()
    return if @isInput()
    return if @isPause()
    return if @countDrawTiming()
    return if @processMarkup()
    @drawMessage @_message[@_messageIndex++]

  # マークアップ処理
  processMarkup: ->
    [@_dx, @_dy, @_messageIndex] =
      @markup.draw(@, @_dx, @_dy, @_message, @_messageIndex)
    @markup.matched

  # ポーズ解除
  pauseCancel: ->
    if @isEmpty()
      rpg.system.app.keyboard.clear()
      @close()
    else
      if @_dx != 0
        @_dx = 0
        @_dy += rpg.system.lineHeight
      @_py = @_dy
      @_messageIndex = 0
      @_waitCount = 0
      @_message = @_messages.shift()
  
  input_ok_up: ->
    if @isPause()
      @pauseCancel()

Object.defineProperty rpg.WindowMessage.prototype, 'currentMessage',
  enumerable: true, get: -> @_message
