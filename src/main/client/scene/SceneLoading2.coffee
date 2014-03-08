
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
    @_endCount = 1
    @updateOnce = @run.bind(@,key,src,type,assets)

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
 

  update: (app) ->
    if @updateOnce?
      @updateOnce()
      @updateOnce = null

  addEndCount: -> @_endCount++
  
  loaded: ->
    @_count += 1
    if @_count == @_endCount
      console.log 'loadend'
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
      for k, v of asset
        if typeof v is 'string'
          @preload(k, v)
        else
          @preload(k, v['src'], v['type'])

    if key?
      scene = tm.global[@scene] if typeof @scene is 'string'
      if scene? and scene.preload?
        @preload(key, src, type, scene.preload)
      else
        @preload(key, src, type)
      @param = tm.asset.AssetManager.get(key).data
    else if typeof @scene is 'string'
      scene = tm.global[@scene]
      if scene? and scene.preload?
        scene.preload(@, @param)
    @loaded()
  

  preload: (key, src, type, callback) ->
    console.log "preload #{key}, #{src}, #{type}"
    @addEndCount()
    am = tm.asset.AssetManager
    am.load(key, src, type)
    obj = am.get(key)
    if obj.loaded
      callback(@, obj.data, obj) if callback?
      @loaded()
    else
      obj.addEventListener 'load', (->
        callback(@, obj.data, obj) if callback?
        @loaded()
      ).bind(@)
