
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
      key
      src
      type
      assets
    } = {
      param: {}
      key: null
      src: {}
      type: 'json'
      assets: {}
    }.$extend args
    @_count = 0
    @_endCount = 1
    setTimeout(@run.bind(@,key,src,type,assets),100)

  addEndCount: -> @_endCount++
  
  loaded: ->
    @_count += 1
    if @_count == @_endCount
      console.log 'loadend'
      console.log @param
      @replaceScene
        scene: @scene
        param: @param

  run: (key,src,type,assets) ->

    for asset in assets
      for k, v of asset
        if typeof v is 'string'
          @preload(k, v)
        else
          @preload(k, v['src'], v['type'])

    if key?
      @preload(key, src, type, @scene.preload)
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
      callback(@, obj.data) if callback?
      @loaded()
    else
      obj.addEventListener 'load', (->
        callback(@, obj.data) if callback?
        @loaded()
      ).bind(@)
