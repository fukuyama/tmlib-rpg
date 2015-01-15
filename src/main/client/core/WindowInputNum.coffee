
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
      @x
      @y
      @unit
      title
    } = {
      visible: false
      active: false
      min: 0
      max: 99
      value: 0
      cancel: -1 # キャンセルフラグ(数字の場合はキャンセル時値、falseの場合は、キャンセルOFF)
      step: 1
      x: 0
      y: 0
      unit: null # 単位
    }.$extend(rpg.system.windowDefault).$extend args
    # 描画サイズ計算
    @rows = 1
    @cols = (@max+'').length
    @menuHeight = rpg.system.lineHeight
    @menuWidth = @measureTextWidth('9')
    console.log @menuWidth
    @colPadding = 0
    # ステップ
    @steps = (parseInt(i) for i in (step + '').split(''))
    if @steps.length < @cols
      @steps.unshift(1) for i in [0...(@cols - @steps.length)]
    # リサイズ
    w = @menuWidth * @cols
    h = @menuHeight
    if title?
      t = @measureTextWidth(title)
      w = if t > w then t else w
      h += @titleHeight
    @unitWidth = 0
    if @unit isnt null
      w += (@unitWidth = @measureTextWidth(@unit))
    w += @borderWidth * 2
    h += @borderHeight * 2
    @resizeWindow(w,h)
    @drawTitle(title) if title?
    # カーソル作成
    basex = (@innerRect.width - @menuWidth * @cols - @unitWidth)
    positions = []
    for i in [0 ... @cols]
      positions.push {
        x: basex + i * (@menuWidth + @colPadding)
        y: 0
      }
    @cursorInstance = rpg.SpriteCursor {
      width: @menuWidth
      height: @menuHeight
      positions: positions
    }
    @cursorInstance.addChildTo @contentShape
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
    @drawText(@values.join(''),@content.width - @unitWidth,0,{align: 'right'})
    @drawText(@unit,@content.width,0,{align: 'right'})
    @cursorInstance.reset()
    
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
