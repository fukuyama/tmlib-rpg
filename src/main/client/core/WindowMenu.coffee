
DEFAULT_CURSOR_ASSET = 'sample.cursor'

# ウィンドウメニュークラス
tm.define 'rpg.WindowMenu',
  superClass: rpg.Window

  # 初期化
  init: (args={}) ->
    delete args[k] for k, v of args when not v?
    # width と height はダミー すぐに resizeAuto する
    @superInit(args.x ? 0, args.y ? 0, 128, 128, args)
    {
      @menus
      @index
      @cols
      @rows
      @cursor
      @colPadding
    } = {
      menus: [] # {name:'name',fn:menuFunc} の配列
      index: 0
      cols: 1
      rows: 2
      cursor: DEFAULT_CURSOR_ASSET
      colPadding: 4
    }.$extend(rpg.system.windowDefault).$extend args

    # カーソル作成
    @cursorInstance = @createCursor(@cursor)
    @addChild @cursorInstance

    # リピート用ハンドラの設定
    @addRepeatHandler
      up: @input_up.bind(@)
      down: @input_down.bind(@)
      left: @input_left.bind(@)
      right: @input_right.bind(@)
    
    # メニュー用ハンドラメソッド
    @eventHandler.create('Menu')
    @addMenuHandler = @eventHandler.addMenuHandler
    @callMenuHandler = @eventHandler.callMenuHandler

    # メニューハンドラ初期化
    @interactive = true
    @addMenuHandler(m.name, m.fn) for m in @menus

    @addEventListener 'pointingover', (e) ->
      console.log e

    @resizeAuto()
    @refresh()

  # カーソルの作成
  createCursor: (param = DEFAULT_CURSOR_ASSET) ->
    rpg.SpriteCursor(@, param)

  # メニューの追加
  addMenu: (name, fn) ->
    if typeof name is 'string'
      @menus.push name: name, fn: fn
      @addMenuHandler.apply(@,arguments)
    else
      @addMenu(m.name, m.fn) for m in name

  # 自動リサイズ
  resizeAuto: ->
    width = 0
    for m in @menus
      w = @measureText(m.name).width
      width = w if width < w
    @menuWidth = width
    @menuHeight = rpg.system.lineHeight
    width  = @menuWidth * @cols + (@cols - 1) * @colPadding
    height = @menuHeight * @rows
    @resize(width + @borderWidth * 2, height + @borderHeight * 2)
    @cursorInstance.reset()

  # コンテキストのリサイズ
  resizeContent: ->
    pageMax = 1 # TODO: 計算を
    w = @innerRect.width * pageMax
    h = @innerRect.height
    @content.resize(w,h)
    @content.shape.width = w
    @content.shape.height = h
    @content.shape.canvas.resize(w,h)

  # メニュー再更新
  refreshMenu: ->
    w = @menuWidth + @colPadding
    h = rpg.system.lineHeight
    for m, i in @menus
      x = (i % @cols)
      y = (i / @cols) | 0
      @drawText(m.name, x * w, y * h)

  # Window再更新
  refresh: ->
    @refreshMenu()
    rpg.Window.prototype.refresh.apply(@, arguments)

  # ----------------------------------------------------
  # 入力処理
  # とりあえず
  # TODO: cols rows の処理、ページの処理とかとか
  
  # 上
  input_up: ->
    pageItems = 0
    if @menus.length < @pageIndex
      pageItems = @menus.length
      pageItems = pageItems + @cols - pageItems % @cols
    else
      pageItems = @pageIndex
    if @rows == 1
      # 行１
      @index -= 1
    else if @index % @pageIndex < @cols
      # ページの一番上
      @index = @index + pageItems - @cols
    else
      # それ以外
      @index -= @cols
    @index = @menus.length - 1 if @index >= @menus.length
    @index = (@index + @menus.length) % @menus.length
    @cursorInstance.setIndex(@index)
    rpg.system.se.menuCursorMove()

  # 下
  input_down: ->
    pageItems = 0
    if @menus.length < @pageIndex
      pageItems = @menus.length
      pageItems = pageItems + @cols - pageItems % @cols
    else
      pageItems = @pageIndex
    if @rows == 1
      # 行１
      @index += 1
    else if @index % @pageIndex >= pageItems - @cols
      # ページの一番下
      @index = @index - pageItems + @cols
    else
      # それ以外
      @index += @cols
      @index = @menus.length - 1 if @index >= @menus.length
    @index = (@index + @menus.length) % @menus.length
    @cursorInstance.setIndex(@index)
    rpg.system.se.menuCursorMove()

  # 左
  input_left: ->
    if @cols == 1
      # カラム１
      @index -= 1
    else if @index > @menus.length - @cols
      # 最後のメニューの場合
      @index -= 1
    else if @index % @cols == 0 and @cols != 1
      # ページの左端の場合
      @index += @cols - 1
    else
      @index -= 1
    @index = (@index + @pageIndex) % @pageIndex
    @cursorInstance.setIndex(@index)
    rpg.system.se.menuCursorMove()

  # 右
  input_right: ->
    if @cols == 1
      # カラム１
      @index += 1
    else if @index == @menus.length - 1
      # 最後のメニューの場合
      @index -= @cols - 1
    else if @index % @cols == @cols - 1
      # ページの右端の場合
      @index -= @cols - 1
    else
      @index += 1
    @index = (@index + @pageIndex) % @pageIndex
    @cursorInstance.setIndex(@index)
    rpg.system.se.menuCursorMove()

  # 決定
  input_ok: ->
    # TODO: メニューがあるかどうか
    rpg.system.se.menuDecision()
    @callMenuHandler(@menus[@index].name)

  # キャンセル
  input_cancel: ->
    # TODO: キャンセル処理はどうするか？
    rpg.system.se.menuCancel()
    console.log 'input_escape'

rpg.WindowMenu.prototype.getter 'pageIndex', -> @cols * @rows
