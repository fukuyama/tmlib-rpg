###*
* @file WindowSkin.coffee
* ウィンドウスキン
###

dummyCanvas = null

ASSETS =
  'windowskin.config.original':
    type: 'json'
    src:
      title: false
      image: 'windowskin.image'
      borderWidth: 16
      borderHeight: 16
      titleBorderHeight: 5
      titlePadding: -8
      backgroundPadding: 2
      backgroundColor: 'rgba(0,0,0,0)'
      backgroundStyle: 'pattern'
      spec:
        backgrounds: [
          [16,16,32,32]
        ]
        topLeft: [0,0,16,16]
        topRight: [64-16,0,16,16]
        bottomLeft: [0,64-16,16,16]
        bottomRight: [64-16,64-16,16,16]
        borderTop: [16,0,32,16]
        borderBottom: [16,64-16,32,16]
        borderLeft: [0,16,16,32]
        borderRight: [64-16,16,16,32]
        titleLeft: [0,64,16,27]
        titleRight: [64-16,64,16,27]
        titleBorder: [16,64,32,27]

tm.define 'rpg.WindowSkin',
  superClass: tm.display.CanvasElement

  ###* コンストラクタ
  * @classdesc ウィンドウスキンクラス
  * @constructor rpg.WindowSkin
  * @param {number} width ウィンドウ幅
  * @param {number} height ウィンドウ高さ
  * @param {String|Object} args スキンアセット名(String) | スキン設定(Object)
  ###
  init: (width, height, args = 'windowskin.config.original') ->
    @superInit()
    @width = width
    @height = height
    args = tm.asset.AssetManager.get(args).data if typeof args == 'string'
    {
      @title
      @image
      @borderWidth
      @borderHeight
      @titleBorderHeight
      @titlePadding
      @backgroundPadding
      @backgroundColor
      @backgroundStyle
      @spec
    } = {}.$extend(ASSETS['windowskin.config.original'].src).$extend(args)

    @texture = tm.asset.AssetManager.get(@image)

    @_background = tm.display.Shape().addChildTo(@)
    @_background.origin.set(0,0)
    @_border = {
      topLeft: tm.display.Shape().addChildTo(@)
      topRight: tm.display.Shape().addChildTo(@)
      bottomLeft: tm.display.Shape().addChildTo(@)
      bottomRight: tm.display.Shape().addChildTo(@)
      borderTop: tm.display.Shape().addChildTo(@)
      borderBottom: tm.display.Shape().addChildTo(@)
      borderLeft: tm.display.Shape().addChildTo(@)
      borderRight: tm.display.Shape().addChildTo(@)
      titleLeft: tm.display.Shape().addChildTo(@)
      titleRight: tm.display.Shape().addChildTo(@)
      titleBorder: tm.display.Shape().addChildTo(@)
    }
    v.origin.set(0,0) for k, v of @_border

    @refresh()

  ###* 各テクスチャの更新
  * @memberof rpg.WindowSkin#
  * @private
  ###
  resize: (width, height) ->
    @width = width
    @height = height
    @refresh()

  ###* 各テクスチャの更新(Fit)
  * @memberof rpg.WindowSkin#
  * @param {tm.display.Shape} o 書き込み先のシェイプ
  * @param {Array} s 転送元座標配列 [x,y,width,height]
  * @param {Array} r 転送先座標配列 [x,y,width,height]
  * @private
  ###
  _refreshTextureFit: (o,s,r) ->
    return unless o?
    return unless s?
    o.x = r[0]
    o.y = r[1]
    o.width = r[2]
    o.height = r[3]
    o.canvas.resize(r[2], r[3])
    o.canvas.drawTexture(@texture, s[0], s[1], s[2], s[3], 0, 0, r[2], r[3])

  ###* 各テクスチャの更新(Pattern)
  * @memberof rpg.WindowSkin#
  * @param {tm.display.Shape} o 書き込み先のシェイプ
  * @param {Array} s 転送元座標配列 [x,y,width,height]
  * @param {Array} r 転送先座標配列 [x,y,width,height]
  * @private
  ###
  _refreshTexturePattern: (o,s,r) ->
    return unless o?
    return unless s?
    if dummyCanvas is null
      dummyCanvas = tm.graphics.Canvas()
    dummyCanvas.resize(s[2], s[3])
    dummyCanvas.drawTexture(@texture, s[0], s[1], s[2], s[3], 0, 0, s[2], s[3])
    o.x = r[0]
    o.y = r[1]
    o.width = r[2]
    o.height = r[3]
    o.canvas.resize(r[2], r[3])
    pattern = o.canvas.context.createPattern(dummyCanvas.canvas, 'repeat')
    o.canvas.beginPath()
    o.canvas.rect(0, 0, r[2], r[3])
    o.canvas.setFillStyle(pattern)
    o.canvas.fill()

  ###* 再更新
  * ウィンドウスキン自体を設定に従って再作成する
  * @memberof rpg.WindowSkin#
  ###
  refresh: ->
    skin = @createSkinConfig()
    switch @backgroundStyle
      when 'fit'
        for s in @spec.backgrounds
          @_refreshTextureFit(@_background, s, skin.background)
      when 'pattern'
        for s in @spec.backgrounds
          @_refreshTexturePattern(@_background, s, skin.background)
    for k, d of skin.rects
      @_refreshTextureFit(@_border[k], @spec[k], d)
    for k, d of skin.titles
      if @title
        @_border[k].show()
        @_refreshTextureFit(@_border[k], @spec[k], d)
      else
        @_border[k].hide()

  ###* スキン設定。転送先座標を現在のウィンドウサイズから計算する。
  * @memberof rpg.WindowSkin#
  * @return {Object} スキン転送先情報
  ###
  createSkinConfig: () ->
    w = @borderWidth
    h = @borderHeight
    t = @borderHeight * 2 - @titleBorderHeight
    p = @backgroundPadding
    l = @borderHeight + @titleHeight - t
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
      titles:
        titleLeft: [0, l, w, t]
        titleRight: [@width - w, l, w, t]
        titleBorder: [w, l, @width - w * 2, t]
    }

###* バックグラウンド透明度
* @var {String} rpg.WindowSkin#backgroundAlpha
###
rpg.WindowSkin.prototype.accessor 'backgroundAlpha',
    get: -> @_background.alpha
    set: (v) -> @_background.alpha = v

###* タイトル高さ。
* タイトル（１行）の高さ＋タイトルボーダーの高さ
* @var {String} rpg.WindowSkin#titleHeight
###
rpg.WindowSkin.prototype.accessor 'titleHeight',
    get: ->
      if @title
        return rpg.system.lineHeight +
          @borderHeight * 2 -
          @titleBorderHeight +
          @titlePadding * 2
      else
        return 0
