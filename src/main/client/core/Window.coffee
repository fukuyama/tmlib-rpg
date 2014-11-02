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
      name
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
    @eventHandler = rpg.EventHandler({active:true,name:name})
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

  ###* タイトル描画範囲（ウィンドウの内側の領域サイズ）計算
  * @memberof rpg.Window#
  * @param {number} width=@width 幅
  * @param {number} height=@height 高さ
  * @private
  ###
  _calcInnerTitleRect: (width = @width, height = @height)->
    tm.geom.Rect(
      @borderWidth
      @borderHeight + @titlePadding
      width - @borderWidth * 2
      rpg.system.lineHeight
    )

  ###* コンテンツ描画範囲（ウィンドウの内側の領域サイズ）計算 コンテンツサイズとは別
  * @memberof rpg.Window#
  * @param {number} width=@width 幅
  * @param {number} height=@height 高さ
  * @private
  ###
  _calcInnerRect: (width = @width, height = @height)->
    tm.geom.Rect(
      @borderWidth
      @borderHeight + @titleHeight
      width - @borderWidth * 2
      height - @borderHeight * 2 - @titleHeight
    )

  ###* 再更新
  * @memberof rpg.Window#
  ###
  refresh: ->
    @refreshWindow()

  ###* 再更新(派生用)
  * @memberof rpg.Window#
  ###
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

  ###* マークアップテキストの描画
  * @memberof rpg.Window#
  * @param {String} text マークアップテキスト
  * @param {number} x 描画X座標
  * @param {number} y 描画Y座標
  ###
  drawMarkup: (text,x=0,y=0,op={}) ->
    {
      i
      markup
    } = op = {
      i: 0
      markup: rpg.MarkupText.default
    }.$extend op
    while i < text.length
      [x,y,i] = markup.draw(@,x,y,text,i)
      c = text[i++]
      @drawText(c,x,y)
      cx = @measureTextWidth(c)
      x += cx
      if @content.width - cx <= x
        x = 0
        y += rpg.system.lineHeight

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

  ###* タイトルコンテンツリサイズ
  * @memberof rpg.Window#
  * @param {number} width 幅
  * @param {number} height 高さ
  ###
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

  ###* 閉じる
  * @memberof rpg.Window#
  * @param {boolean} closeall=true treeにあるのは全部閉じるかどうか
  ###
  close: (closeall=true)->
    if closeall
      w.close() for w in @windows
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

  ###* ウィンドウ追加
  * @memberof rpg.Window#
  * @param {rpg.Window} w 追加するウィンドウ
  ###
  addWindow: (w,flag=true) ->
    w.parentWindow = @
    if flag
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
  ###* ウィンドウ追加
  * @memberof rpg.Window#
  * @param {rpg.Window} w 追加するウィンドウ
  ###
  removeWindow: (w) ->
    w.parentWindow = null
    w.remove()
    index = @windows.indexOf(w)
    @windows.splice(index,1) if 0 <= index
    @
  ###* open リスナ追加
  * @memberof rpg.Window#
  * @param {Function} fn リスナー
  ###
  addOpenListener: (fn) ->
    @addEventListener('open',fn)
    @
  ###* open リスナ追加（１回用）
  * @memberof rpg.Window#
  * @param {Function} fn リスナー
  ###
  onceOpenListener: (fn) ->
    _callback = (->
      fn()
      @removeEventListener('open',_callback)
    ).bind(@)
    @addEventListener('open',_callback)
    @
  ###* close リスナ追加
  * @memberof rpg.Window#
  * @param {Function} fn リスナー
  ###
  addCloseListener: (fn) ->
    @addEventListener('close',fn)
    @
  ###* close リスナ追加（１回用）
  * @memberof rpg.Window#
  * @param {Function} fn リスナー
  ###
  onceCloseListener: (fn) ->
    _callback = (->
      fn()
      @removeEventListener('close',_callback)
      _callback = null
    ).bind(@)
    @addEventListener('close',_callback)
    @
  ###* ツリー構造のウィンドウで一番上のウィンドウを探す
  * @memberof rpg.Window#
  ###
  findTopWindow: ->
    if @parentWindow instanceof rpg.Window
      return @parentWindow.findTopWindow()
    @
  ###* ツリーを巡ってウインドウを探す
  * @memberof rpg.Window#
  * @param {rpg.Window~findWindowCallback} fn 検索用コールバック
  ###
  findWindowTree: (fn)->
    t = @findTopWindow()
    return t._findWindowTree(fn)

  ###* ツリーを巡ってウインドウを探す内部メソッド
  * @memberof rpg.Window#
  * @param {rpg.Window~findWindowCallback} fn 検索用コールバック
  * @private
  ###
  _findWindowTree: (fn)->
    return @ if fn @
    for w in @windows
      r = w._findWindowTree(fn)
      return r if r?
    return null


rpg.Window.EVENT_OPEN       = tm.event.Event 'open'
rpg.Window.EVENT_CLOSE      = tm.event.Event 'close'
rpg.Window.EVENT_ADD_WINDOW = tm.event.Event 'addWindow'

rpg.Window.prototype.getter 'innerRect', -> @content.innerRect
rpg.Window.prototype.getter 'borderWidth', -> @_windowskin.borderWidth
rpg.Window.prototype.getter 'borderHeight', -> @_windowskin.borderHeight
rpg.Window.prototype.getter 'titleHeight', -> @_windowskin.titleHeight
rpg.Window.prototype.getter 'titlePadding', -> @_windowskin.titlePadding
rpg.Window.prototype.getter 'font', -> "#{@fontSize} #{@fontFamily}"
