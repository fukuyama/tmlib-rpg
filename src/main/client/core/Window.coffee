###*
* @file Window.coffee
* ウィンドウ
###

tm.define 'rpg.Window',
  superClass: tm.display.CanvasElement

  ###* コンストラクタ
  * @classdesc ウィンドウクラス
  * @constructor rpg.Window
  * @param {number} x ウィンドウX座標
  * @param {number} y ウィンドウY座標
  * @param {number} width ウィンドウ幅
  * @param {number} height ウィンドウ高さ
  * @param {Object} args ウィンドウ設定
  ###
  init: (x, y, width, height, args={}) ->
    delete args[k] for k, v of args when not v?
    @superInit()
    {
      @active     # アクティブフラグ
      @visible    # 表示状態
      @textColor  # テキスト描画時のカラー
      @fontFamily # フォントファミリー
      @fontSize   # フォントサイズ
      title       # タイトル
      @alpha
      @windowskin
      @windows    # 関連するウィンドウのインスタンス add/remove でつかう。
    } = {
      active: false
      visible: true
      title: null
      windows: []
    }.$extend({
      windowskin: 'windowskin.config.default'
      textColor: 'rgb(255,255,255)'
      fontFamily: 'sans-serif'
      fontSize: '24px'
      alpha: 0.9
    }).$extend(rpg.system.windowDefault).$extend args

    @_openDuring = false
    @_closeDuring = false

    @origin.set(0, 0)
    @x = x
    @y = y
    @width = if width == 0 then 100 else width
    @height = if height == 0 then 100 else height

    # ウィンドウスキン
    @_windowskin = @createWindowSkin(@windowskin)
    @_windowskin.backgroundAlpha = @alpha
    @addChild @_windowskin

    # ウィンドウコンテンツ
    @content = rpg.WindowContent(@_calcInnerRect())
    @addChild @content.shape

    # タイトル
    if title?
      # タイトルコンテンツ
      @titleContent = rpg.WindowContent(@_calcInnerTitleRect())
      @addChild @titleContent.shape
      @_windowskin.title = true
      @height += @titleHeight
      @resizeWindow(@width,@height)
      @drawTitle(title)

    # 最初の更新（自分のだけ呼ぶ…OOP的にどなんだろ）
    @refreshWindow()

    # イベントハンドラ用メソッド
    @eventHandler = rpg.EventHandler({active:true})
    @setupHandler = -> @eventHandler.setupHandler(@) # bind は、まずい気がする。
    @addInputHandler = @eventHandler.addInputHandler # まるまる delegate するならこう？
    @addRepeatHandler = @eventHandler.addRepeatHandler
    @setupHandler()

  ###* ウィンドウスキンの作成
  * @memberof rpg.Window#
  * @param {Object} skin ウィンドウスキン情報
  ###
  createWindowSkin: (skin) ->
    rpg.WindowSkin(@width, @height, skin)

  # タイトル描画範囲（ウィンドウの内側の領域サイズ）計算
  _calcInnerTitleRect: (width = @width, height = @height)->
    tm.geom.Rect(
      @borderWidth
      @borderHeight + @titlePadding
      width - @borderWidth * 2
      rpg.system.lineHeight
    )

  # コンテンツ描画範囲（ウィンドウの内側の領域サイズ）計算 コンテンツサイズとは別
  _calcInnerRect: (width = @width, height = @height)->
    tm.geom.Rect(
      @borderWidth
      @borderHeight + @titleHeight
      width - @borderWidth * 2
      height - @borderHeight * 2 - @titleHeight
    )

  # 再更新
  refresh: ->
    @refreshWindow()

  # 再更新(派生用)
  refreshWindow: ->
    @titleContent?.drawTo()
    @content?.drawTo()

  ###* テキスト描画
  * @memberof rpg.Window#
  * @param {String} text 描画文字列
  * @param {number} x 描画X座標
  * @param {number} y 描画Y座標
  ###
  drawText: (text, x, y, op={}) ->
    # TODO: フォントとかカラーを変更できるようにする
    {
      font
      baseline
      align
      color
      strokeStyle
    } = {
      font: @font
      baseline: 'top'
      align: 'left'
      color: @textColor
    }.$extend op
    @content.context.save()
    @content.font = font
    @content.textBaseline = baseline
    @content.textAlign = align
    @content.fillStyle = color
    @content.strokeStyle = strokeStyle ? color
    @content.fillText(text, x, y + 3) # TODO: textBaseline ちょい下で良いかな？
    @content.context.restore()

  ###* タイトル描画処理
  * @memberof rpg.Window#
  * @param {String} title タイトル文字列
  ###
  drawTitle: (title = @titleText) ->
    return unless title?
    @titleText = title
    @titleContent.context.save()
    @titleContent.context.font = @font
    @titleContent.textBaseline = 'top'
    @titleContent.setFillStyle(@textColor)
    @titleContent.fillText(title, 0, 3) # TODO: textBaseline ちょい下で良いかな？
    @titleContent.context.restore()

  ###* テキスト描画テスト
  * @memberof rpg.Window#
  * @param {String} text テスト文字列
  ###
  measureTextWidth: (text) ->
    @content.context.save()
    @content.context.font = @font
    @content.textBaseline = 'top'
    width = Math.ceil @content.context.measureText(text).width
    @content.context.restore()
    width
  
  ###* リサイズ
  * @memberof rpg.Window#
  * @param {number} width 幅
  * @param {number} height 高さ
  ###
  resize: (width, height) ->
    @resizeWindow(width, height)

  ###* リサイズ
  * @memberof rpg.Window#
  * @param {number} width 幅
  * @param {number} height 高さ
  ###
  resizeWindow: (width, height) ->
    @width = width
    @height = height
    @_windowskin.resize(width, height)
    @resizeInnerRect()
    @resizeContent()
    if @titleText?
      @resizeTitleContent()

  ###* 内側のリサイズ
  * @memberof rpg.Window#
  * @param {number} width 幅
  * @param {number} height 高さ
  ###
  resizeInnerRect: (width = @width, height = @height) ->
    ir = @_calcInnerRect(width, height)
    @innerRect.set.apply(@innerRect, ir.toArray())

  ###* コンテンツリサイズ
  * @memberof rpg.Window#
  * @param {number} width 幅
  * @param {number} height 高さ
  ###
  resizeContent: (w = @innerRect.width,h = @innerRect.height)->
    @content.resize(w,h)

  resizeTitleContent: (width = @width, height = @height) ->
    ir = @_calcInnerTitleRect(width,height)
    w = ir.width
    h = ir.height
    @titleContent.innerRect.width = w
    @titleContent.innerRect.height = h
    @titleContent.resize(w,h)

  ###* 更新処理
  * @memberof rpg.Window#
  ###
  update: ->
    @eventHandler.updateInput() if @active
    if @_openDuring
      @_openDuring = false
      @visible = true
      @active = true
      @dispatchEvent rpg.Window.EVENT_OPEN
    if @_closeDuring
      @_closeDuring = false
      @visible = false
      @active = false
      @dispatchEvent rpg.Window.EVENT_CLOSE
    @content.update()

  ###* 表示位置調整（中央に配置する）
  * @memberof rpg.Window#
  * @param {String} param 'horizon' or 'vertical'
  * 水平、垂直、どちらかのみ中央にする場合に指定する。
  ###
  centering: (param) ->
    w = rpg.system.screen.width
    h = rpg.system.screen.height
    @x = (w - @width) / 2 if param is 'horizon' or not param?
    @y = (h - @height) / 2 if param is 'vertical' or not param?
    @

  ###* 開く
  * @memberof rpg.Window#
  ###
  open: ->
    @_openDuring = true
    @

  ###* 閉じる（treeにあるのは全部閉じる）
  * @memberof rpg.Window#
  ###
  close: ->
    win.close() for win in @windows
    @_closeDuring = true
    @

  ###* open 確認
  * @memberof rpg.Window#
  ###
  isOpen: ->
    @visible

  ###* close 確認
  * @memberof rpg.Window#
  ###
  isClose: ->
    not @visible

  addWindow: (w) ->
    w.parentWindow = @
    w.addCloseListener (e) ->
      p = @parentWindow
      if p?
        p.removeWindow(e.target)
        p.active = true
        p.visible = true
    @windows.push w
    @parent.addChild(w)
    w.dispatchEvent rpg.Window.EVENT_ADD_WINDOW
    @
  removeWindow: (w) ->
    w.parentWindow = null
    w.remove()
    index = @windows.indexOf(w)
    @windows.splice(index,1) if 0 <= index
    @
  addOpenListener: (fn) ->
    @addEventListener('open',fn)
    @
  onceOpenListener: (fn) ->
    _callback = (->
      fn()
      @removeEventListener('open',_callback)
    ).bind(@)
    @addEventListener('open',_callback)
    @
  addCloseListener: (fn) ->
    @addEventListener('close',fn)
    @
  onceCloseListener: (fn) ->
    _callback = (->
      fn()
      @removeEventListener('close',_callback)
      _callback = null
    ).bind(@)
    @addEventListener('close',_callback)
    @
  # ツリー構造のウィンドウで一番上のウィンドウを探す
  findTopWindow: ->
    if @parentWindow instanceof rpg.Window
      return @parentWindow.findTopWindow()
    @
  # ウインドウを探す
  findWindow: (fn)->
    for w in @windows when fn w
      return w
    return null


rpg.Window.EVENT_OPEN = tm.event.Event 'open'
rpg.Window.EVENT_CLOSE = tm.event.Event 'close'
rpg.Window.EVENT_ADD_WINDOW = tm.event.Event 'addWindow'

rpg.Window.prototype.getter 'innerRect', -> @content.innerRect
rpg.Window.prototype.getter 'borderWidth', -> @_windowskin.borderWidth
rpg.Window.prototype.getter 'borderHeight', -> @_windowskin.borderHeight
rpg.Window.prototype.getter 'titleHeight', -> @_windowskin.titleHeight
rpg.Window.prototype.getter 'titlePadding', -> @_windowskin.titlePadding
rpg.Window.prototype.getter 'font', -> "#{@fontSize} #{@fontFamily}"
