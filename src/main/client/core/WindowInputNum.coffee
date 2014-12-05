
tm.define 'rpg.WindowInputNum',
  superClass: rpg.Window

  # 初期化
  init: (args={}) ->
    delete args[k] for k, v of args when not v?
    args.initSizeContent = true
    args.name = 'InputNum'
    @superInit(0, 0, 0, 0, args)
    {
      @visible
      @active
      @min
      @max
      @value
      step
      @cancel
      @cursor
      @x
      @y
    } = {
      visible: false
      active: false
      min: 0
      max: 99
      value: 0
      cancel: -1 # キャンセルフラグ(数字の場合はキャンセル時値、falseの場合は、キャンセルOFF)
      step: 1
      cursor: 'sample.cursor'
      x: 0
      y: 0
    }.$extend(rpg.system.windowDefault).$extend args
    # 描画サイズ計算
    @rows = 1
    @cols = (@max+'').length
    @menuHeight = rpg.system.lineHeight
    @menuWidth = @measureTextWidth('9')
    @colPadding = 0
    # ステップ
    @steps = (parseInt(i) for i in (step + '').split(''))
    if @steps.length < @cols
      @steps.unshift(1) for i in [0...(@cols - @steps.length)]
    # リサイズ
    if args.title?
      w1 = @measureTextWidth(args.title) + @borderWidth * 2
      w2 = @menuWidth * @cols + @borderWidth * 2
      w = if w1 > w2 then w1 else w2
      h = @menuHeight + @borderHeight * 2 + @titleHeight
      @resizeWindow(w,h)
      @drawTitle()
    else
      @resizeWindow(
        @menuWidth * @cols + @borderWidth * 2
        @menuHeight + @borderHeight * 2
      )
    cursorx = @content.width - @menuWidth * @cols
    # カーソル作成
    @cursorInstance = rpg.SpriteCursor(@,@cursor)
    @cursorInstance.reset basex:cursorx
    @addChild @cursorInstance
    @cursorInstance.setIndex(@cols - 1)
    while @steps[@cursorInstance.index] == 0
      @cursorInstance.setIndex(@cursorInstance.index - 1)

    # リピート用ハンドラの設定
    @addRepeatHandler
      up: @input_up.bind(@)
      down: @input_down.bind(@)
      left: @input_left.bind(@)
      right: @input_right.bind(@)

    @values = (0 for i in [0...@cols])

    # 初期更新
    @refresh()

  # Window再更新
  refresh: ->
    @content.clear()
    @drawText(@values.join(''),@content.width,0,{
      align: 'right'
    })
    rpg.Window.prototype.refresh.call(@)
    
  setValues: (v)->
    @values[@cursorInstance.index] = v
    @value = parseInt @values.join('')
    @refresh()
    @

  setValue: (v) ->
    @value = v
    vs = (@value + '').split('')
    @values = ('0' for i in [0...(@cols - vs.length)]).concat vs
    @refresh()
    @

  input_left: ->
    if @cursorInstance.index == 0
      @setValue @max
    else
      @cursorInstance.setIndex(@cursorInstance.index - 1)

  input_right: ->
    i = @cursorInstance.index + 1
    while i < @cols and @steps[i] == 0
      i += 1
    if i == @cols
      @setValue @min
    else
      @cursorInstance.setIndex(i)

  input_up: ->
    i = @cursorInstance.index
    @setValues((@values[@cursorInstance.index] + 10 + @steps[i]) % 10)

  input_down: ->
    i = @cursorInstance.index
    @setValues((@values[@cursorInstance.index] + 10 - @steps[i]) % 10)
  
  input_ok_up: ->
    @close()
    rpg.system.app.keyboard.clear()
    @active = false
  
  input_cancel_up: ->
    return if typeof @cancel is 'boolean' and not @cancel
    @setValue @cancel
    @close()
    rpg.system.app.keyboard.clear()
    @active = false
