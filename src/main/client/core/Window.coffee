
# ウィンドウクラス
tm.define 'rpg.Window',

  superClass: tm.display.CanvasElement

  # 初期化
  init: (x, y, width, height, args={}) ->
    delete args[k] for k, v of args when not v?
    @superInit()
    @width = width
    @height = height
    {
      @active     # アクティブフラグ
      @visible    # 表示状態
      @textColor  # テキスト描画時のカラー
      @alpha
      @windowskin
    } = {
      active: false
      visible: true
    }.$extend({
      windowskin: 'windowskin.config.default'
      textColor: 'rgb(255,255,255)'
      alpha: 0.9
    }).$extend(rpg.system.windowDefault).$extend args

    @_openDuring = false
    @_closeDuring = false

    @origin.set(0, 0)
    @x = x
    @y = y

    # ウィンドウスキン
    @_windowskin = @createWindowSken(@windowskin)
    @_windowskin.backgroundAlpha = @alpha
    @addChild @_windowskin

    # ウィンドウコンテンツ
    @content = rpg.WindowContent(@_calcInnerRect())
    @content.alpha = 1.0
    @addChild @content.shape

    # 最初の更新（自分のだけ呼ぶ…OOP的にどなんだろ）
    rpg.Window.prototype.refresh.apply(@, arguments)

    # イベントハンドラ用メソッド
    @eventHandler = rpg.EventHandler({active:true})
    @setupHandler = -> @eventHandler.setupHandler(@) # bind は、まずい気がする。
    @addInputHandler = @eventHandler.addInputHandler # まるまる delegate するならこう？
    @addRepeatHandler = @eventHandler.addRepeatHandler
    @setupHandler()

  # ウィンドウスキンの作成
  createWindowSken: (skin = DEFAULT_WINDOWSKIN_ASSET) ->
    rpg.WindowSkin(@width, @height, skin)

  # コンテンツ描画範囲（ウィンドウの内側の領域サイズ）計算 コンテンツサイズとは別
  _calcInnerRect: (width = @width, height = @height)->
    bw = @borderWidth
    bh = @borderHeight
    tm.geom.Rect(bw, bh, width - bw * 2, height - bh * 2)

  # 再更新
  refresh: ->
    @content.drawTo()
  
  # テキスト描画
  drawText: (text, x, y) ->
    # TODO: フォントとかカラーを変更できるようにする
    @content.context.save()
    @content.context.font = '24px sans-serif'
    @content.textBaseline = 'top'
    @content.setFillStyle(@textColor)
    @content.fillText(text, x, y + 3) # TODO: textBaseline ちょい下で良いかな？
    @content.context.restore()

  # テキスト描画テスト
  measureText: (text) ->
    @content.context.save()
    @content.context.font = '24px sans-serif'
    @content.textBaseline = 'top'
    ret = @content.context.measureText(text)
    @content.context.restore()
    ret
  
  # リサイズ
  resize: (width, height) ->
    @resizeWindow(width, height)

  # リサイズ
  resizeWindow: (width, height) ->
    @width = width
    @height = height
    @_windowskin.resize(width, height)
    @resizeInnerRect()
    @resizeContent()

  resizeInnerRect: (width = @width, height = @height) ->
    ir = @_calcInnerRect(width, height)
    @innerRect.set.apply(@innerRect, ir.toArray())

  resizeContent: ->
    w = @innerRect.width
    h = @innerRect.height
    @content.resize(w,h)
    @content.shape.width = w
    @content.shape.height = h
    @content.shape.canvas.resize(w,h)

  # 更新処理
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

  # 開く
  open: ->
    @_openDuring = true

  # 閉じる
  close: ->
    @_closeDuring = true

  # open 確認
  isOpen: ->
    @visible

  # close 確認
  isClose: ->
    not @visible

  # 表示位置調整
  centering: (param) ->
    w = rpg.system.screen.width
    h = rpg.system.screen.height
    @x = (w - @width) / 2 if param is 'horizon' or not param?
    @h = (h - @height) / 2 if param is 'vertical' or not param?

  addOpenListener: (fn) ->
    @addEventListener('open',fn)
    @
  addCloseListener: (fn) ->
    @addEventListener('close',fn)
    @

  onceCloseListener: (fn) ->
    _callback = (->
      fn()
      @removeEventListener('close',_callback)
    ).bind(@)
    @addEventListener('close',_callback)
    @
  
rpg.Window.EVENT_OPEN = tm.event.Event "open"
rpg.Window.EVENT_CLOSE = tm.event.Event "close"

rpg.Window.prototype.getter 'innerRect', -> @content.innerRect
rpg.Window.prototype.getter 'borderWidth', -> @_windowskin.borderWidth
rpg.Window.prototype.getter 'borderHeight', -> @_windowskin.borderHeight
