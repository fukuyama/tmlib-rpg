###*
* @file WindowMessage.coffee
* メッセージウィンドウ
###

MSG_OPT = rpg.constants.MESSAGE_OPTION

tm.define 'rpg.WindowMessage',
  superClass: rpg.Window

  ###* コンストラクタ
  * @classdesc メッセージウィンドウ
  * @constructor rpg.WindowMessage
  * @param {Object} args
  * @param {number} args.messageSpeed メッセージスピード
  * @param {number} args.scrollSpeed スクロールスピード
  ###
  init: (args={}) ->
    delete args[k] for k, v of args when not v?
    args.name = 'Message'
    @superInit(0,0,0,0,args)
    # args からのインスタンス変数初期化
    {
      @visible
      @active
      @messageSpeed
      @scrollSpeed
      @autoSpeed
      @maxLine
      @options
    } = {
      visible: false
      active: false
      messageSpeed: 4 # メッセージスピード
      scrollSpeed: 5 # スクロールスピード
      autoSpeed: 0 # 自動送りスピード
      maxLine: 3
      options:
        message:
          position: MSG_OPT.MESSAGE.BOTTOM # メッセージウィンドウ位置
          close: on # 表示毎にクローズする場合 on(true)
        select:
          position: MSG_OPT.SELECT.RIGHT # 選択肢ウィンドウ位置
        input_num:
          position: MSG_OPT.NUMBER.RIGHT # 数値入力ウィンドウ位置
    }.$extend(args)

    # メッセージスピード 1-8
    if @messageSpeed >= 4
      @_waitCountMax = @messageSpeed - 3
      @_drawCount = 0
    else
      @_waitCountMax = 1
      @_drawCount = @messageSpeed - 4

    # リサイズ
    @resize(
      Math.min(rpg.system.screen.width,640 - 32)
      rpg.system.lineHeight * @maxLine + @borderHeight * 2)
    @resizeContent(
      @innerRect.width
      @innerRect.height * 2)

    @markup = rpg.MarkupText.default
    
    @addOpenListener((->
      @active = false
      @setDisplayPosition()
    ).bind(@))

    @addCloseListener((->
      @windowMenu?.close()
      @windowInputNum?.close()
      @clear()
    ).bind(@))

    @clear()

  ###* 状態クリア
  * @memberof rpg.WindowMessage#
  ###
  clear: ->
    @_messages = []
    @_message = ''
    @_messageIndex = 0
    @_dx = @_dy = 0 # 描画座標
    @_sy = 0 # スクロール用
    @_py = 0 # ポーズ時座標
    @_ay = 0 # スクロール差分用座標
    @_waitCount = 0 # 描画時のウェイトカウント
    @_autoCount = 0 # 自動ページ送りのカウント
    @content.clear()
    return

  ###* コンテンツクリア
  * @memberof rpg.WindowMessage#
  ###
  clearContent: ->
    @content.oy = @_ay = @_dy = @_py = @_sy = 0 # 初期化
    @content.clear()
    return

  ###* 終了処理。最後のメッセージを表示してプレイヤーが読み終わったときに呼ばれる。
  * @memberof rpg.WindowMessage#
  ###
  terminate: ->
    @fire rpg.WindowMessage.EVENT_TERMINATE
    @active = false
    if @options.message.close
      @close()
    return

  ###* メッセージを設定。
  * @memberof rpg.WindowMessage#
  * @params {string|Array} msg メッセージ。
  ###
  setMessage: (msg) ->
    @active = false
    @open() if @isClose()
    @_messages = if Array.isArray msg then [].concat(msg) else [msg]
    @_nextMessage()
    return

  ###* 次のメッセージ。
  * @memberof rpg.WindowMessage#
  * @private
  ###
  _nextMessage: ->
    if @_dx != 0
      @_dx = 0
      @_dy += rpg.system.lineHeight
    @_py = @_dy
    @_waitCount = 0
    @_autoCount = 0
    @_message = @markup.replace(@_messages.shift().replace /\n/g, '\\n')
    @_messageIndex = 0
    @_autoCountMax = @_message.length * @autoSpeed
    return

  ###* 自動ページ送りモードの設定。
  * @memberof rpg.WindowMessage#
  * @params {boolean} args true だと、システムの自動送りスピードを設定して、オートモードON。false だと、オートモードOFF
  * @params {number} args 指定された値を、自動送りスピードにする。オートモードON
  ###
  setAutoMode: (args) ->
    if typeof args is 'boolean'
      if args
        @autoSpeed = rpg.system.setting.autoSpeed
      else
        @autoSpeed = 0
    if typeof args is 'number'
      @autoSpeed = args
    @_autoCountMax = @_message.length * @autoSpeed

  ###* ポーズスキップ。
  * @memberof rpg.WindowMessage#
  ###
  pauseSkip: (n=1) ->
    @_autoCountMax = n

  ###* 表示位置設定。
  * @memberof rpg.WindowMessage#
  * @params {Object} options
  ###
  setDisplayPosition: (options=@options) ->
    @setDisplayPositionMain options
    @setDisplayPositionMenu options
    @setDisplayPositionInputNum options
    return

  ###* メッセージウィンドウ表示位置設定
  * @memberof rpg.WindowMessage#
  * @params {Object} options
  ###
  setDisplayPositionMain: (options=@options) ->
    # x座標は真ん中
    @centering('horizon')
    c = MSG_OPT.MESSAGE
    # y座標は上中下のいずれか
    switch options.message.position
      when c.TOP then @y = 0
      when c.CENTER then @centering('vertical')
      when c.BOTTOM then @y = rpg.system.screen.height - @height
    return

  ###* 選択肢表示位置
  * @memberof rpg.WindowMessage#
  * @params {Object} options
  ###
  setDisplayPositionMenu: (options=@options) ->
    if @windowMenu?
      c = MSG_OPT.SELECT
      # 左右位置
      switch options.select.position
        when c.LEFT then @windowMenu.x = @left
        when c.CENTER then @windowMenu.center()
        when c.RIGHT then @windowMenu.x = @right - @windowMenu.width
      # 上下位置
      if options.message.position is MSG_OPT.MESSAGE.TOP
        @windowMenu.y = @bottom
      else
        @windowMenu.y = @top - @windowMenu.height
    return

  ###* 数値入力ウィンドウ表示位置
  * @memberof rpg.WindowMessage#
  * @params {Object} options
  ###
  setDisplayPositionInputNum: (options=@options) ->
    if @windowInputNum?
      c = MSG_OPT.NUMBER
      # 左右位置
      switch options.input_num.position
        when c.LEFT then @windowInputNum.x = @left
        when c.CENTER then @windowInputNum.center()
        when c.RIGHT then @windowInputNum.x = @right - @windowInputNum.width
      # 上下位置
      if options.message.position is MSG_OPT.MESSAGE.TOP
        @windowInputNum.y = @bottom
      else
        @windowInputNum.y = @top - @windowInputNum.height
    return

  ###* ポーズ状態確認。
  * メッセージの表示位置が、メッセージの長さ以上の場合、ポーズする。
  * @memberof rpg.WindowMessage#
  * @return {boolean} ポーズが必要な場合 true
  ###
  isPause: -> @_messageIndex >= @_message.length
  
  ###* 残りの表示メッセージ確認。
  * メッセージのリストが空の場合。残りメッセージが無い状態。
  * @memberof rpg.WindowMessage#
  * @return {boolean} 表示するメッセージが無い場合 true
  ###
  isEmpty: -> @_messages.length == 0

  ###* 選択中確認。
  * @memberof rpg.WindowMessage#
  * @return {boolean} 選択肢表示中の場合 true
  ###
  isSelect: -> @windowMenu?

  ###* 数値入力中確認。
  * @memberof rpg.WindowMessage#
  * @return {boolean} 数値入力ウィンドウ表示中の場合 true
  ###
  isInput: -> @windowInputNum?

  ###* 描画タイミングの計算。
  * @memberof rpg.WindowMessage#
  * @return {boolean} 描画タイミングの場合 false
  ###
  countDrawTiming: ->
    @_waitCount = ++@_waitCount % @_waitCountMax
    return @_waitCount != 0

  ###* 自動ページ送りの計算。
  * @memberof rpg.WindowMessage#
  * @return {boolean} 自動ページ送りする場合 false
  ###
  countAutoTiming: ->
    return true if @_autoCountMax == 0
    @_autoCount = ++@_autoCount % @_autoCountMax
    return @_autoCount != 0

  ###* 選択肢ウィンドウの作成
  * @memberof rpg.WindowMessage#
  ###
  createSelectWindow: (args={}) ->
    {
      menus
      options
      callback
    } = args

    fn = -> @windowMenu.close()
    menuAndFuncs = ({name:name,fn:fn.bind(@)} for name in menus)

    @windowMenu = rpg.WindowMenu({
      name: 'Select'
      visible: false
      active: false
      cols: 1
      rows: menuAndFuncs.length
      menus: menuAndFuncs
    }.$extend options).addCloseListener((->
      callback(@windowMenu.index) if callback?
      @windowMenu = null
      @pauseCancel()
    ).bind(@)).open()
    @addWindow(@windowMenu)
    @active = false
    @setDisplayPosition()
    return

  ###* 数値入力ウィンドウの作成
  * @memberof rpg.WindowMessage#
  ###
  createInputNumWindow: (args={}) ->
    {
      flag
      options
      callback
    } = args
    options.name = 'Select'
    
    @windowInputNum = rpg.WindowInputNum(options)
    @windowInputNum.addCloseListener((->
      callback(@windowInputNum.value) if callback?
      @windowInputNum = null
      @pauseCancel()
    ).bind(@)).open()
    @addWindow(@windowInputNum)
    @active = false
    @setDisplayPosition()
    return

  ###* メッセージの確認
  * @memberof rpg.WindowMessage#
  ###
  checkTempMessage: ->
    return unless rpg.system.temp.message?

    msg = rpg.system.temp.message
    endProc = rpg.system.temp.messageEndProc
    rpg.system.temp.message = null
    rpg.system.temp.messageEndProc = null

    if endProc?
      @one 'terminate', endProc

    @setMessage(msg)

  ###* 選択肢の確認
  * @memberof rpg.WindowMessage#
  ###
  checkTempSelect: ->
    return unless rpg.system.temp.selectArgs?
    return unless @isPause() and @isEmpty()
    @createSelectWindow rpg.system.temp.selectArgs
    rpg.system.temp.selectArgs = null
    @
  
  ###* 数値入力の確認
  * @memberof rpg.WindowMessage#
  ###
  checkTempInputNum: ->
    return unless rpg.system.temp.inputNumArgs?
    return unless @isPause() and @isEmpty()
    @createInputNumWindow rpg.system.temp.inputNumArgs
    rpg.system.temp.inputNumArgs = null
    @

  ###* オプションの確認
  * @memberof rpg.WindowMessage#
  ###
  checkTempOption: ->
    return unless rpg.system.temp.options?
    @options = @options.$extendAll rpg.system.temp.options
    rpg.system.temp.options = null
    if @options.message.close and @isOpen()
      @terminate()
    return

  ###* スクロール処理
  * @memberof rpg.WindowMessage#
  ###
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

  ###* 更新処理
  * @memberof rpg.WindowMessage#
  ###
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
    # ポーズ中
    if @isPause()
      @active = true
      # 自動送り
      unless @countAutoTiming()
        @pauseCancel()
      else
        return
    return if @countDrawTiming()
    @drawMessage() for num in [0 .. @_drawCount]
    @refresh()

  ###* メッセージを描画する
  * @memberof rpg.WindowMessage#
  ###
  drawMessage: ->
    return if @processMarkup()
    msg = @_message[@_messageIndex++]
    return unless msg?
    @drawText(msg, @_dx, @_dy)
    @_dx += @measureTextWidth(msg)

  ###* マークアップ処理
  * @memberof rpg.WindowMessage#
  ###
  processMarkup: ->
    [@_dx, @_dy, @_messageIndex] =
      @markup.draw(@, @_dx, @_dy, @_message, @_messageIndex)
    @markup.matched

  ###* ポーズ解除
  * @memberof rpg.WindowMessage#
  ###
  pauseCancel: ->
    if @isEmpty()
      @terminate()
    else
      @_nextMessage()

  ###* イベントハンドラ
  * @memberof rpg.WindowMessage#
  ###
  input_ok_up: ->
    if @isPause() and not @isSelect()
      @pauseCancel()
    rpg.system.app.keyboard.clear()

Object.defineProperty rpg.WindowMessage.prototype, 'currentMessage',
  enumerable: true, get: -> @_message ? ''

rpg.WindowMessage.EVENT_TERMINATE = tm.event.Event 'terminate'
