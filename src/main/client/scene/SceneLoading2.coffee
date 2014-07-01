###*
* @file SceneLoading.coffee
* ロードシーン
###

# TODO: ロード中のアニメーション画像とか背景画像を追加したい
tm.define 'SceneLoading',
  superClass: rpg.SceneBase

  ###* コンストラクタ
  * @classdesc ロードシーンクラス。
  * シーン切り替え時に必要な Asset を事前に読み込む等の処理をする。
  * @constructor SceneLoading
  * @param {Object} args 初期化パラメータ
  * @param {String|Scene} args.scene シーン名 | シーンインスタンス
  * @param {Object} args.param シーンクラスパラメータ
  * @param {function} args.callback シーン遷移時のコールバック
  * @param {String} args.key シーンクラスパラメータをAssetから取得する場合の key
  * @param {String} args.src シーンクラスパラメータをAssetから取得する場合の src
  * @param {String} args.type シーンクラスパラメータをAssetから取得する場合の type
  * @param {Array} args.assets 事前に読み込む Asset の配列
  * @param {Array} args.bitmap ロード時の背景画像
  ###
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
    @_progress_callback = {}

    # ローダーインスタンス化
    @_loader = tm.asset.Loader()
    @_loader.on 'progress', @_progress.bind @
    @_loader.on 'load', @_load.bind @

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

    # Asset ロード
    for asset in assets
      if typeof asset is 'string'
        @_preload(asset, asset)
        continue
      @_preload(asset)
    if key?
      @_preload(key, src, type, (->
        @param = tm.asset.AssetManager.get(key).data
      ).bind @)

  ###* データ読み込み時のハンドラ
  * @memberof SceneLoading#
  * @param {Event} e
  * @private
  ###
  _progress: (e) ->
    {key} = e
    console.log "* progress * #{key}"
    @_progress_callback[key].call(e) if @_progress_callback[key]?

  ###* データ読み込み時のハンドラ
  * @memberof SceneLoading#
  * @param {Event} e
  * @private
  ###
  _load: (e) ->
    @_count++
    l = (rpg.system.screen.width / @_endCount)
    @gauge.setValue(@_count * l, @gaugeAnime)

  ###* 事前読み込み
  * @memberof SceneLoading#
  * @param {String|Object} key Assset key
  * @param {String} src Asset　の url
  * @param {String} type Asset の type
  * @param {function} callback progress 時に呼ばれる関数
  * @private
  ###
  _preload: (key, src, type, callback) ->
    console.log "preload #{key}, #{src}, #{type}"
    @_endCount++
    @_progress_callback[key] = callback if callback?
    @_loader.load(key, src, type)

  ###* シーン更新処理
  * @memberof SceneLoading#
  ###
  update: (app) ->
    if @_count == @_endCount
      console.log 'loadend'
      @replaceScene
        scene: @scene
        param: @param
      @callback(@) if @callback?
