
# CustomizeTexture クラス
tm.define 'tm.asset.CustomizeTexture',
  superClass: tm.asset.JsonWrapper

  # 初期化
  init: (path) ->
    @superInit(path)

  parse: (args) ->
    {
      @images
      @width
      @height
    } = args
    @canvas = tm.graphics.Canvas()
    @canvas.resize(@width, @height)
    @element = @canvas.canvas
    for image in @images
      image = tm.asset.AssetManager.get(image)
      @canvas.drawTexture(image,0,0)

# AssetManager に登録
tm.asset.AssetManager.register 'texture_',
  (path) -> tm.asset.CustomizeTexture(path)
