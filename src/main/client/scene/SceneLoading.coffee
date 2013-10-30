
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
      @assets
      @currentLoadIndex
      @loadCount
      gauge
    } = {
      scene: null
      param: {}
      assets: []
      gauge: {}
      currentLoadIndex: 0
      loadCount: tm.asset.AssetManager._loadedCounter - 1
    }.$extend args

    # フラグの初期化
    @loadStarted = false
    @loadEnded = false
    @gaugeAnime = true

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
    @gauge = tm.app.Gauge(
      gauge.width
      gauge.height
      gauge.color
      gauge.direction
    ).addChildTo(@)
    @gauge.x = gauge.x
    @gauge.y = gauge.y
    @gauge.setValue(0,false)

    # 読み込む Asset の数
    @loadCountMax = 0
    for asset in @assets
      for k, v of asset
        @loadCountMax++
    
    # loadEnded の確認（終了処理）のコールバック関数
    @chckLoadEnded = (->
      if @gauge.isFull()
        @loadEnded = true
      else
        setTimeout(@chckLoadEnded,500)
    ).bind(@)
    
    # load イベントのコールバック関数
    @loadIntarnal = (->
      @gaugeAnime = false
      if @assets.length > 0 and @currentLoadIndex < @assets.length
        assets = @assets[@currentLoadIndex]
        @currentLoadIndex++
        tm.asset.AssetManager.load assets
      else
        tm.asset.AssetManager.removeEventListener('load', @loadIntarnal)
        @gauge.setValue(rpg.system.screen.width, true)
        @chckLoadEnded()
    ).bind(@)
    
    # load イベントリスナーの追加
    tm.asset.AssetManager.addEventListener('load', @loadIntarnal)

  # ロード中の更新処理
  updateLoading: ->
    i = (tm.asset.AssetManager._loadedCounter - @loadCount)
    l = (rpg.system.screen.width / @loadCountMax)
    @gauge.setValue(i * l, @gaugeAnime)
    @gaugeAnime = true

  # 更新処理
  update: ->
    if not @loadStarted
      # まだロードを開始していなければ開始
      @loadStarted = true
      @loadIntarnal()
    if @loadEnded
      # 終了したらシーンの切り替え
      rpg.system.replaceScene
        scene: @scene
        param: @param
    @updateLoading()
