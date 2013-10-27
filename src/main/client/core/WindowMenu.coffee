
DEFAULT_CURSOR_ASSET = 'sample.cursor'

# ウィンドウメニュークラス
tm.define 'rpg.WindowMenu',
  superClass: rpg.Window

  # 初期化
  init: (args={}) ->
    delete args[k] for k, v of args when not v?
    # width と height はダミー すぐに resizeAuto する
    @superInit(args.x, args.y, 128, 128, args)
    {
      @menus
      @index
      @cols
      @rows
      @cursor
    } = {
      menus: [] # {name:'name',fn:menuFunc} の配列
      index: 0
      cols: 1
      rows: @innerRect.height / rpg.system.lineHeight | 0
      cursor: DEFAULT_CURSOR_ASSET
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
    @addMenuHandler(m.name, m.fn) for m in @menus

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

  # リサイズ
  resizeAuto: ->
    width = 0
    for m in @menus
      w = @measureText(m.name).width
      width = w if width < w
    height = rpg.system.lineHeight * @menus.length
    bw = @borderWidth
    bh = @borderHeight
    @resize(width + bw * 2, height + bw * 2)
    @content.resize(width, height)
    @rows = @menus.length
    @cursorInstance.reset(@cols,@rows)

  refreshMenu: ->
    h = 0
    for m in @menus
      @drawText(m.name, 0, h)
      h += rpg.system.lineHeight

  refresh: ->
    @refreshMenu()
    rpg.Window.prototype.refresh.apply(@, arguments)

  # ----------------------------------------------------
  # 入力処理
  # とりあえず
  # TODO: cols rows の処理、ページの処理とかとか
  
  # 上
  input_up: ->
    @index = (--@index + @menus.length) % @menus.length
    @cursorInstance.setIndex(@index)
    rpg.system.se.menuCursorMove()

  # 下
  input_down: ->
    @index = ++@index % @menus.length
    @cursorInstance.setIndex(@index)
    rpg.system.se.menuCursorMove()

  # 左
  input_left: ->
    @index = (--@index + @menus.length) % @menus.length
    @cursorInstance.setIndex(@index)
    rpg.system.se.menuCursorMove()

  # 右
  input_right: ->
    @index = ++@index % @menus.length
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
