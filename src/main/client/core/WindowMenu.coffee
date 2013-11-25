
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
      saveIndex
      @cols
      @rows
      @cursor
      @colPadding
      close
    } = {
      menus: [] # {name:'name',fn:menuFunc} の配列
      index: 0
      saveIndex: false # カーソル位置の保存フラグ true だと保存する
      cols: 1
      rows: 2
      cursor: DEFAULT_CURSOR_ASSET
      colPadding: 4
      close: true
    }.$extend(rpg.system.windowDefault).$extend args
    
    @closeEvent = close

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
    @addMenuHandler(m.name, m.fn) for m in @menus
    
    # イベントリスナー
    @addEventListener 'open', ->
      # カーソル位置を保存しない場合は、開くときに index を初期化
      @setIndex(0) unless saveIndex

    # ポインティング対応
    @setInteractive(true)
    @setBoundingType('rect')
    @addEventListener 'pointingend', @pointing_menu.bind(@)

    # リサイズ、初期更新
    @resizeAuto()
    @refresh()

  # カーソルの作成
  createCursor: (param = DEFAULT_CURSOR_ASSET) ->
    rpg.SpriteCursor(@, param)

  # カーソルインデックス設定
  setIndex: (@index) ->
    @cursorInstance.setIndex(@index)

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
    w = @innerRect.width * @maxPageNum
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
      n = Math.floor(i / @maxPageItems)
      x = (i % @cols) * w + n * @innerRect.width
      y = Math.floor((i % @maxPageItems)/ @cols) * h
      @drawText(m.name, x, y)

  # Window再更新
  refresh: ->
    @refreshMenu()
    rpg.Window.prototype.refresh.apply(@, arguments)

  # ----------------------------------------------------
  # 入力処理
  # とりあえず

  # 決定
  input_ok_up: ->
    # TODO: メニューがあるかどうか
    rpg.system.se.menuDecision()
    @callMenuHandler(@menus[@index].name)

  # キャンセル
  input_cancel_up: ->
    if @closeEvent
      rpg.system.se.menuCancel()
      @close()

  # 上
  input_up: ->
    if @rows == 1 and @maxPageNum == 1
      # 行１
      @index -= 1
    else if @currentIndexRow == 1
      # ページの一番上
      @index = @index + (@currentPageRows - 1) * @cols
    else
      # それ以外
      @index -= @cols
    @index = @menus.length - 1 if @index >= @menus.length
    @setIndex (@index + @menus.length) % @menus.length
    rpg.system.se.menuCursorMove()

  # 下
  input_down: ->
    if @rows == 1 and @maxPageNum == 1
      # 行１
      @index += 1
    else if @index % @maxPageItems >= @currentPageItems - @cols
      # ページの一番下
      if @currentIndexRow == @currentPageRows
        @index = @index - (@currentPageRows - 1) * @cols
      else
        @index = @menus.length - 1
    else
      # それ以外
      @index += @cols
    @setIndex (@index + @menus.length) % @menus.length
    rpg.system.se.menuCursorMove()

  # 左
  input_left: ->
    if @currentIndexCols == 1 and @maxPageNum == 1
      # カラム１
      @index -= 1
    else if @currentIndexCol == 1
      # ページの左端の場合
      if @currentPageNum == 1
        @index = (@maxPageNum - 1) * @maxPageItems + @index + @cols - 1
      else
        @index = @index - @maxPageItems + @cols - 1
      if @menus.length <= @index
        @index = @menus.length - 1 - @menus.length % @cols
    else
      @index -= 1
    @setIndex (@index + @menus.length) % @menus.length
    @content.ox = (@currentPageNum - 1) * @innerRect.width
    @content.drawTo()
    rpg.system.se.menuCursorMove()

  # 右
  input_right: ->
    if @cols == 1 and @maxPageNum == 1
      # カラム１
      @index += 1
    else if @currentIndexCol == @cols or
    (@index == @menus.length - 1 and @currentIndexRow == 1)
      # ページの右端の場合
      if @currentPageNum == @maxPageNum
        @index = (@currentIndexRow - 1) * @cols
      else
        @index = @index + @maxPageItems - @cols + 1
      if @menus.length <= @index
        @index = (@maxPageNum - 1) * @maxPageItems +
        (@currentPageRows - 1) * @cols
    else if @index == @menus.length - 1
      @index = @index - @cols + 1
    else
      @index += 1
    @setIndex (@index + @menus.length) % @menus.length
    @content.ox = (@currentPageNum - 1) * @innerRect.width
    @content.drawTo()
    rpg.system.se.menuCursorMove()

  # メニュー選択
  pointing_menu: (e) ->
    @cursorInstance.setPointing(e)

# １ページに表示可能な最大数
rpg.WindowMenu.prototype.getter 'maxPageItems', -> @cols * @rows

# 最大ページ数
rpg.WindowMenu.prototype.getter 'maxPageNum', ->
  Math.ceil(@menus.length / @maxPageItems)

# 現在のページ数
rpg.WindowMenu.prototype.getter 'currentPageNum', ->
  Math.floor(@index / @maxPageItems) + 1

# 現在のページに表示される数
rpg.WindowMenu.prototype.getter 'currentPageItems', ->
  currentPageItems = @maxPageItems
  if @index + (@menus.length % @maxPageItems) >= @menus.length
    currentPageItems = @menus.length % @maxPageItems
  currentPageItems

# 現在のページに表示される行数
rpg.WindowMenu.prototype.getter 'currentPageRows', ->
  currentPageRows = @rows
  if @currentPageItems < @maxPageItems
    currentPageRows = Math.ceil(@currentPageItems / @cols)
  currentPageRows

# 現在位置のカラム数
rpg.WindowMenu.prototype.getter 'currentIndexCols', ->
  currentIndexCols = @cols
  if @menus.length - (@menus.length % @cols) <= @index
    currentIndexCols = @menus.length % @cols + 1
  currentIndexCols

# 現在位置の行
rpg.WindowMenu.prototype.getter 'currentIndexRow', ->
  Math.floor(@index % @maxPageItems / @cols) + 1

# 現在位置のカラム
rpg.WindowMenu.prototype.getter 'currentIndexCol', ->
  @index % @cols + 1
