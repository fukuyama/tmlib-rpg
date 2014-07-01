
tm.define 'rpg.WindowInputNum',
  superClass: rpg.Window

  # 初期化
  init: (args={}) ->
    delete args[k] for k, v of args when not v?
    args.initSizeContent = true
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
    } = {
      visible: false
      active: false
      min: 0
      max: 99
      value: 0
      cancel: -1
      step: 1
      cursor: 'sample.cursor'
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
    @resize(
      @menuWidth * @cols + @borderWidth * 2
      @menuHeight + @borderHeight * 2)
    # カーソル作成
    @cursorInstance = rpg.SpriteCursor(@,@cursor)
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
    @drawText(@values.join(''),0,0)
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
  
  input_cancel_up: ->
    return if typeof @cancel is 'boolean' and not @cancel
    @setValue @cancel
    @close()
