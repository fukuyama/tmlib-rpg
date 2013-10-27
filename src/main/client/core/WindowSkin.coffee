
ASSETS =
  #'windowskin.vxace': 'img/window.png'
  'windowskin.config.vxace':
    _type: 'json'
    image: 'windowskin.vxace'
    borderWidth: 16
    borderHeight: 16
    backgroundPadding: 2
    backgroundColor: 'rgba(0,0,0,0.9)'
    spec:
      backgrounds: [
        [0,0,64,64]
        [0,64,64,64]
      ]
      topLeft: [64, 0, 16, 16]
      topRight: [128 - 16, 0, 16, 16]
      bottomLeft: [64, 64 - 16, 16, 16]
      bottomRight: [128 - 16, 64 - 16, 16, 16]
      borderTop: [64 + 16, 0, 16, 16]
      borderBottom: [64 + 16, 64 - 16, 16, 16]
      borderLeft: [64, 16, 16, 16]
      borderRight: [128 - 16, 16, 16, 16]
  'windowskin.hiyoko': 'img/Frame320.png'
  'sample.windowskin.config':
    _type: 'json'
    image: 'windowskin.hiyoko'
    borderWidth: 32
    borderHeight: 32
    backgroundPadding: 2
    backgroundColor: 'rgba(255,255,255,1.0)'
    spec:
      backgrounds: [
        [32,32,64,64]
      ]
      topLeft: [0, 0, 32, 32]
      topRight: [320 - 32, 0, 32, 32]
      bottomLeft: [0, 320 - 32, 32, 32]
      bottomRight: [320 - 32, 320 - 32, 32, 32]
      borderTop: [32, 0, 32, 32]
      borderBottom: [32, 320 - 32, 32, 32]
      borderLeft: [0, 32, 32, 32]
      borderRight: [320 - 32, 32, 32, 32]

# ウィンドウスキンクラス
tm.define 'rpg.WindowSkin',
  superClass: tm.app.CanvasElement

  # 初期化
  init: (width, height, args = 'sample.windowskin.config') ->
    @superInit()
    @width = width
    @height = height
    args = tm.asset.AssetManager.get(args) if typeof args == 'string'
    {
      @image
      @borderWidth
      @borderHeight
      @backgroundPadding
      @backgroundColor
      @spec
    } = {}.$extend(ASSETS['sample.windowskin.config']).$extend(args)

    @texture = tm.asset.AssetManager.get(@image)

    @_background = tm.app.Shape().addChildTo(@)
    @_background.origin.set(0,0)
    @_border = {
      topLeft: tm.app.Shape().addChildTo(@)
      topRight: tm.app.Shape().addChildTo(@)
      bottomLeft: tm.app.Shape().addChildTo(@)
      bottomRight: tm.app.Shape().addChildTo(@)
      borderTop: tm.app.Shape().addChildTo(@)
      borderBottom: tm.app.Shape().addChildTo(@)
      borderLeft: tm.app.Shape().addChildTo(@)
      borderRight: tm.app.Shape().addChildTo(@)
    }
    v.origin.set(0,0) for k, v of @_border

    @refresh()

  resize: (width, height) ->
    @width = width
    @height = height
    @refresh()

  refreshTexture: (o,s,r) ->
    o.x = r[0]
    o.y = r[1]
    o.width = r[2]
    o.height = r[3]
    o.canvas.resize(r[2], r[3])
    o.canvas.drawTexture(@texture, s[0], s[1], s[2], s[3], 0, 0, r[2], r[3])

  # 再更新
  # ウィンドウスキン自体を設定に従って再作成する
  refresh: ->
    skin = @createSkinConfig()
    #if not @backgroundColor?
    #  @fillStyle = @backgroundColor
    #  @fillRect.apply(@, skin.background)
    for s in @spec.backgrounds
      @refreshTexture(@_background, s, skin.background)
    for k, d of skin.rects
      @refreshTexture(@_border[k], @spec[k], d)

  # 描画処理
  # 与えられたキャンバスにスキンを描画
  drawTo: (canvas) -> #canvas.drawImage(@canvas, 0, 0)

  # スキン設定
  createSkinConfig: () ->
    w = @borderWidth
    h = @borderHeight
    p = @backgroundPadding
    {
      background: [p, p, @width - p * 2, @height - p * 2]
      rects:
        topLeft: [0, 0, w , h]
        topRight: [@width - w, 0, w, h]
        bottomLeft: [0, @height - h, w, h]
        bottomRight: [@width - w, @height - h, w, h]
        borderTop: [w, 0, @width - w * 2, h]
        borderBottom: [w, @height - h, @width - w * 2, h]
        borderLeft: [0, h, w, @height - h * 2]
        borderRight: [@width - w, h, w, @height - h * 2]
    }

rpg.WindowSkin.prototype.accessor 'backgroundAlpha',
    get: -> @_background.alpha
    set: (v) -> @_background.alpha = v
