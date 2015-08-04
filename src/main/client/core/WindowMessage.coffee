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
      messageSpeed: 8 # メッセージスピード
      scrollSpeed:  6 # スクロールスピード
      autoSpeed:    0 # 自動送りスピード
      maxLine:      3 # 表示ライン数
      options:
        message:
          position: MSG_OPT.MESSAGE.BOTTOM # メッセージウィンドウ位置
          close: on # 表示毎にクローズする場合 on(true)
        select:
          position: MSG_OPT.SELECT.RIGHT # 選択肢ウィンドウ位置
        input_num:
          position: MSG_OPT.NUMBER.RIGHT # 数値入力ウィンドウ位置
    }.$extend(args)

    # リサイズ
    @resize(
      Math.min(rpg.system.screen.width,640 - 32)
      rpg.system.lineHeight * @maxLine + @borderHeight * 2)
    @resizeContent(
      @innerRect.width
      @innerRect.height * 2)

    @_lineIndexStart = 0
    @_lineIndex = 0
    @_lines = []
    for n in [0 .. @maxLine * 2]
      line = rpg.ShapeMessageLine(
        x: 0
        y: n * rpg.system.lineHeight
        width: @innerRect.width
        height: rpg.system.lineHeight
        speed: @messageSpeed
      ).addChildTo @contentShape
      line.on 'end', @_lineEndCallback.bind @
      @_lines.push line
    #console.log '@_lines.lenth = ' + @_lines.length

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

    @on "enterframe", @updateMessage

  _lineEndCallback:  ->
    console.log "end " + @_debug_string() + " #{@_lines[@_lineIndex].currentText}"
    i = ++@_lineIndex
    if @_lines[i].isReady()
      @_lines[i].start()
    @_dy += rpg.system.lineHeight
    return

  ###* 状態クリア
  * @memberof rpg.WindowMessage#
  ###
  clear: ->
    @currentMessage = ''
    @_messages = []
    @_dx = @_dy = 0 # 描画座標
    @_sy = 0 # スクロール用
    @_py = 0 # ポーズ時座標
    @_ay = 0 # スクロール差分用座標
    @_waitCount = 0 # 描画時のウェイトカウント
    @_autoCount = 0 # 自動ページ送りのカウント
    @content.clear()
    @_lineIndex = 0
    for line in @_lines
      line.clear()
    return

  ###* コンテンツクリア
  * @memberof rpg.WindowMessage#
  ###
  clearContent: ->
    @oy = @_ay = @_dy = @_py = @_sy = 0 # 初期化
    @content.clear()
    newIndex = @_lineIndex
    lines1 = @_lines[0 ... newIndex]
    lines2 = @_lines[newIndex .. ]
    for l in lines1
      l.clear()
      lines2.push l
    @_lines = lines2
    for l,i in @_lines
      l.y = i * rpg.system.lineHeight
    @_lineIndex = 0
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
    @_waitCount = 0
    @_autoCount = 0

    text = @markup.replace(@_messages.shift().replace /\n/g, '\\n')
    @currentMessage = ''
    i = 0
    l = @_lineIndex
    while i < text.length
      line = @_lines[l++]
      unless line?
        break
      i = line.drawMarkup(text,i:i)
      line.reset()
      @currentMessage += line.currentText
      if @_lines[l]?
        @_lines[l].setOptions line.getOptions()
    @_autoCountMax = @currentMessage.length * @autoSpeed
    @_py = @_dy
    @_lineIndexStart = @_lineIndex
    @_lines[@_lineIndex].start()
    console.log 'next ' + @_debug_string()
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
    @_autoCountMax = @currentMessage.length * @autoSpeed

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
  * @memberof rpg.WindowMessage#
  * @return {boolean} ポーズが必要な場合 true
  ###
  isPause: -> @_lines[@_lineIndex].isEmpty()

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

  _debug_string: -> "s#{@_sy} p#{@_py} d#{@_dy} a#{@_ay} o#{@oy} i#{@_lineIndex}"

  ###* スクロール処理
  * @memberof rpg.WindowMessage#
  ###
  scroll: ->
    # スクロール処理
    if @_sy > 0
      n = Math.pow(2, @scrollSpeed) / 256.0 * rpg.system.lineHeight
      @oy += n
      @_sy -= n
      return true
    # ポーズしててページ位置までスクロールしてなかったらスクロールさせる
    if @isPause() and @_py > @oy
      console.log 'scroll ' + @_debug_string()
      @_sy = @_py - @oy
      return true
    # ポーズしてて表示がずれている場合は位置調整（@_lines並べ替え）
    if @isPause() and @oy > 0
      console.log 'init ' + @_debug_string()
      @_ay = @_dy -= @oy # 描画位置を、現在の表示位置分戻して
      @oy = @_py = @_sy = 0 # 初期化
      @contentShape.setPosition(@ox,@oy) # ちらつきを抑えるために描画調整と同時に位置調整
      lines1 = @_lines[0 ... @_lineIndexStart]
      lines2 = @_lines[@_lineIndexStart .. ]
      @_lineIndex -= @_lineIndexStart
      for l in lines1
        l.clear()
        lines2.push l
      @_lines = lines2
      for l,i in @_lines
        l.y = i * rpg.system.lineHeight
      return false
    # ポーズじゃなくて、描画位置が範囲を超えたら
    if not @isPause() and @_dy >= rpg.system.lineHeight * @maxLine + @oy
      #if not @isPause() and @_ay != @_dy and @_dy >= rpg.system.lineHeight * @maxLine
      console.log 'over ' + @_debug_string()
      @_sy = rpg.system.lineHeight
      @_ay = @_dy
      return true
    return false

  ###* 更新処理
  * @memberof rpg.WindowMessage#
  ###
  updateMessage: ->
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
    return

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

rpg.WindowMessage.EVENT_TERMINATE = tm.event.Event 'terminate'
