###*
* @file WindowMenu.coffee
* ウィンドウメニュー
###

tm.define 'rpg.WindowMenu',
  superClass: rpg.Window

  ###* コンストラクタ
  * @classdesc ウィンドウメニュークラス
  * @constructor rpg.WindowMenu
  * @param {Object} args 初期化パラメータ
  ###
  init: (args={}) ->
    delete args[k] for k, v of args when not v?
    @menuRects = []
    @menus = []
    # width と height はダミー すぐに resizeAuto する
    @superInit(args.x ? 0, args.y ? 0, 128, 128, args)
    {
      menus
      index
      saveIndex
      @cancelIndex
      @cols
      @rows
      @colPadding
      @menuWidthFix
      @menuHeightFix
    } = {
      menus: [] # {name:'name',fn:menuFunc} の配列
      index: 0
      saveIndex: false # カーソル位置の保存フラグ true だと保存する
      cancelIndex: -1 # キャンセル時のインデックス
      cols: 1
      rows: 2
      colPadding: 4
      menuWidthFix: null
      menuHeightFix: null
    }.$extend(rpg.system.windowDefault).$extend args
    console.assert(@rows > 0,'@rows は０より大きく')
    @rows = 2 if @rows <= 0
    index = -1 if menus.length == 0
    @index = index # インデックスの初期化関連でローカル変数も使う

    # カーソル作成
    @cursorInstance = @createCursor()
    @cursorInstance.addChildTo(@)

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
    @clearMenuHandler = @eventHandler.clearMenuHandler
    @eventHandler.create('Change')
    @addChangeHandler = @eventHandler.addChangeHandler
    @callChangeHandler = @eventHandler.callChangeHandler
    @clearChangeHandler = @eventHandler.clearChangeHandler

    # メニューハンドラ初期化
    @addMenu(menus)
    if @change_index?
      @addChangeHandler('index',@change_index.bind(@))

    @addChangeHandler('index',@change_page.bind(@))

    # インデックス初期化
    @setIndex(index)
    # イベントリスナー
    @addOpenListener ->
      # カーソル位置を保存しない場合は、開くときに index を初期化
      @setIndex(index) unless saveIndex

    # ポインティング対応
    @setInteractive(true)
    @setBoundingType('rect')
    @addEventListener 'pointingend', @pointing_menu.bind(@)

    # リサイズ、初期更新
    @resizeAuto()
    @refresh()

  # ページ変更
  change_page: ->
    if @titleText? and @_page != @currentPageNum
      @_page = @currentPageNum
      @refreshTitle()

  # カーソルの作成
  createCursor: ->
    rpg.SpriteCursor {
      width: @menuWidth
      height: @menuHeight
      positions: @_cursorPosition()
    }

  _cursorPosition: () ->
    for o in @menuRects
      {
        x: @innerRect.x + o.x % @innerRect.width
        y: @innerRect.y + o.y
      }

  # カーソルインデックス設定
  setIndex: (@index) ->
    @cursorInstance.setIndex(@index)
    @callChangeHandler('index')

  # メニューの追加
  addMenu: (name, fn) ->
    if typeof name is 'string'
      @menus.push name: name, fn: fn
      @addMenuHandler(@menus.length - 1,fn)
    else
      @addMenu(m.name, m.fn) for m in name

  # メニューのクリア
  clearMenu: () ->
    @content.clear()
    for m,i in @menus
      @clearMenuHandler(i)
    @menus = []

  # 自動リサイズ
  resizeAuto: ->
    #return if @menus.length == 0
    if @menuWidthFix?
      @menuWidth = @menuWidthFix
    else
      width = 0
      if @titleText?
        width = @measureTextWidth(@titleText)
      for m in @menus
        w = @measureTextWidth(m.name)
        width = w if width < w
      @menuWidth = width
    if @menuHeightFix?
      @menuHeight = @menuHeightFix
    else
      @menuHeight = rpg.system.lineHeight
    width  = @menuWidth * @cols + (@cols - 1) * @colPadding
    height = @menuHeight * @rows + @titleHeight
    @resize(width + @borderWidth * 2, height + @borderHeight * 2)
    @cursorInstance.resize(@menuWidth,@menuHeight)
    @cursorInstance.reset()
    return

  # コンテキストのリサイズ
  resizeContent: ->
    w = @innerRect.width * @maxPageNum
    h = @innerRect.height
    if @content.width == w and @content.height == h
      return
    @contentShape.width = w
    @contentShape.height = h
    @content.resize(w,h)
    return

  # メニュー再更新
  refreshMenu: ->
    @content.clear()
    r.remove() for r in @menuRects
    @menuRects.clear()
    for m, i in @menus
      n = Math.floor(i / @maxPageItems)
      w = @menuWidth
      h = @menuHeight
      x = (i % @cols) * (w + @colPadding) + n * @innerRect.width
      y = Math.floor((i % @maxPageItems) / @cols) * h
      s = tm.display.Shape(width:w, height:h)
        .addChildTo(@contentShape)
        .setPosition(x,y)
      l = tm.display.Label(m.name)
        .addChildTo(s)
        .setAlign('left')
        .setY(h/2)
      @menuRects.push(s)
    @cursorInstance.positions = @_cursorPosition()
    @cursorInstance.reset()
    return

  # メニューを１つ描画
  drawMenu: (i,x,y,w,h) ->
    @drawText(@menus[i].name, x, y)
    return

  # Window再更新
  refresh: ->
    @refreshMenu()
    @refreshTitle()

  refreshTitle: () ->
    if @titleContent?
      @titleContent.clear()
      @drawTitle()
      @drawPageNum()

  ###* ページ数描画処理
  * @memberof rpg.WindowMenu#
  ###
  drawPageNum: ->
    # ページ処理
    return if @maxPageNum <= 1
    pageText = "#{@currentPageNum} / #{@maxPageNum}"
    @titleContent.context.save()
    @titleContent.context.font = @font
    @titleContent.textBaseline = 'top'
    @titleContent.setFillStyle(@textColor)
    x = @titleContent.width - @measureTextWidth(pageText)
    @titleContent.fillText(pageText, x, 3)
    @titleContent.context.restore()

  # ----------------------------------------------------
  # 入力処理

  # 決定
  input_ok_up: ->
    # メニューがあるかどうか
    if 0 <= @index and @index < @menus.length
      rpg.system.se.menuDecision()
      @callMenuHandler(@index)
      rpg.system.app.keyboard.clear()
    # TODO:ミスの場合 SE 鳴らす？

  # キャンセル
  input_cancel_up: ->
    if @cancel instanceof Function
      @cancel()
    else unless typeof @cancel is 'boolean' and not @cancel
      rpg.system.se.menuCancel()
      @index = @cancelIndex
      @close()

  # 上
  input_up: ->
    if @index < 0
      @index = 0
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
    if @index < 0
      @index = 0
    else if @currentIndexCols == 1 and @maxPageNum == 1
      # カラム１
      @index -= 1
    else if @currentIndexCol == 1
      # ページの左端の場合
      if @currentPageNum == 1
        @index = (@maxPageNum - 1) * @maxPageItems + @index + @cols - 1
      else
        @index = @index - @maxPageItems + @cols - 1
      if @menus.length <= @index
        n = @menus.length - (@maxPageNum - 1) * @maxPageItems
        @index = n - 1 - n % @cols
        if @index > 0
          @index += (@maxPageNum - 1) * @maxPageItems
        else
          @index = @menus.length - 1
    else
      @index -= 1
    @setIndex (@index + @menus.length) % @menus.length
    @ox = (@currentPageNum - 1) * @innerRect.width * -1
    rpg.system.se.menuCursorMove()

  # 右
  input_right: ->
    if @index < 0
      @index = 0
    else if @cols == 1 and @maxPageNum == 1
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
    @ox = (@currentPageNum - 1) * @innerRect.width * -1
    rpg.system.se.menuCursorMove()

  # メニュー選択
  pointing_menu: (e) ->
    return unless @active
    base = (@currentPageNum - 1) * @maxPageItems
    # @cursorInstance.setPointing(e,base)
    if @cursorInstance.index < @menus.length
      if @index == @cursorInstance.index
        @input_ok_up()
      else
        @setIndex @cursorInstance.index
    else
      @setIndex @index

# １ページに表示可能な最大数
rpg.WindowMenu.prototype.getter 'maxPageItems', -> @cols * @rows

# 最大ページ数
rpg.WindowMenu.prototype.getter 'maxPageNum', ->
  return 1 if @menus.length == 0
  Math.ceil(@menus.length / @maxPageItems)

# 現在のページ
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
