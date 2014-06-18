
class LoadCounter
  constructor: (@loadFunction) ->
    @_count = 0
    @_endCount = 1


# ロードシーン
# TODO: ロード中のアニメーション画像とか背景画像を追加したい
tm.define 'SceneLoading',
  superClass: rpg.SceneBase

  # 初期化
  init: (args={}) ->
    delete args[k] for k, v of args when not v?
    # 親の初期化
    @superInit(name:'SceneLoading')
    {
      @scene
      @param
      @callback
      key
      src
      type
      assets
      gauge
      @gaugeAnime
      bitmap
    } = {
      param: {}
      callback: null
      key: null
      src: {}
      type: 'json'
      assets: []
      gauge: {}
      gaugeAnime: false
      bitmap: null
    }.$extend args
    @_count = 0
    @_endCount = 0
    @_preload_callback = {}
    @updateOnce = @run.bind(@,key,src,type,assets)

    # ローダーインスタンス化
    @_loader = tm.asset.Loader()
    @_loader.on 'progress', @progress.bind @
    @_loader.on 'load', @loadend.bind @

    # ロードシーン
    @bg = tm.display.Shape(
      rpg.system.screen.width
      rpg.system.screen.height
    ).addChildTo(@)
    @bg.origin.set(0, 0)
    @bg.canvas.drawBitmap(bitmap,0,0) if bitmap?

    # ゲージのパラメータ作成
    gauge = {
      x: 0
      y: 0
      width: rpg.system.screen.width
      height: 10
      color: 'blue'
      direction: 'left'
    }.$extend(gauge)

    # ゲージの作成
    @gauge = tm.ui.Gauge(
      gauge.width
      gauge.height
      gauge.color
      gauge.direction
    ).addChildTo(@)
    @gauge.origin.set(0, 0)
    @gauge.x = gauge.x
    @gauge.y = gauge.y
    @gauge.setValue(0,false)

  progress: (e) ->
    {key} = e
    console.log "* progress * #{@_count} == #{@_endCount} #{key}"
    @_preload_callback[key].call(e) if @_preload_callback[key]?

  update: (app) ->
    if @updateOnce?
      @updateOnce()
      @updateOnce = null

  addEndCount: -> @_endCount++
  
  loadend: ->
    console.log 'loadend'
    @_count += 1
    if @_count == @_endCount
      @replaceScene
        scene: @scene
        param: @param
      @callback(@) if @callback?
    l = (rpg.system.screen.width / @_endCount)
    @gauge.setValue(@_count * l, @gaugeAnime)

  run: (key,src,type,assets) ->
    for asset in assets
      if typeof asset is 'string'
        @preload(asset, asset)
        continue
      @preload(asset)
      ###
      for k, v of asset
        if typeof v is 'string'
          @preload(k, v)
        else
          @preload(k, v['src'], v['type'])
      ###
    if key?
      @preload(key, src, type, (->
        @param = tm.asset.AssetManager.get(key).data
        console.log @param
      ).bind @)

  preload: (key, src, type, callback) ->
    console.log "preload #{key}, #{src}, #{type}"
    @addEndCount()
    if arguments.length == 1
      @_loader.load(key)
    else
      @_preload_callback[key] = callback if callback?
      @_loader.load(key, src, type)
