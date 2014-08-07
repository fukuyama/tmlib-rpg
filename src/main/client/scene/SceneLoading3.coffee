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
  ###
  init: (args={}) ->
    delete args[k] for k, v of args when not v?
    # 親の初期化
    @superInit(name:'SceneLoading')
    param = {
      width: rpg.system.screen.width
      height: rpg.system.screen.height
      bgColor: 'transparent'
    }.$extend args

    @_assets = []
    @addAssets param.assets

    @fromJSON
      children:
        stage:
          type: 'tm.display.CanvasElement'

    @stage.fromJSON
      children:
        bg:
          type: 'tm.display.Shape'
          init: [param.width, param.height]
          originX: 0
          originY: 0
        label:
          type: 'tm.display.Label'
          text: 'Loading'
          x: param.width - 100
          y: param.height - 32
          align: 'right'
          baseline: 'middle'
          fontSize: 24
          fillStyle: '#000'
          shadowBlur: 4
          shadowColor: 'hsl(0, 0%, 50%)'
        bar:
          type: 'tm.ui.Gauge'
          init:
            width: param.width
            height: 10
            color: 'hsl(200, 100%, 80%)'
            bgColor: 'transparent'
            borderColor: 'transparent'
            borderWidth: 0
          x: 0
          y: param.height - 10

    # bg
    bg = @stage.bg
    bg.canvas.clearColor param.bgColor

    # label
    label = @stage.label
    label.tweener.
      to({alpha:1}, 1000).
      to({alpha:0.5}, 1000).
      setLoop(true)

    # bar
    bar = @stage.bar
    bar.animationFlag = false
    bar.value = 0
    bar.animationFlag = true
    bar.animationTime = 100

    # load
    stage = @stage
    stage.alpha = 0.0
    stage.tweener.clear().fadeIn(100).call (->
      if param.assets
        loader = tm.asset.Loader()

        loader.on 'load', (->
          if @_assets.length > 0
            loader.load @_assets.shift()
          else
            bar.value = 100
            stage.tweener.clear().wait(200).fadeOut(200).call (->
              # console.log 'loadend'
              if param.nextScene?
                @replaceScene
                  scene: param.nextScene
                  param: param.param
              else if param.autopop
                @app.popScene()
              @fire tm.event.Event 'load'
            ).bind(@)
        ).bind(@)

        loader.on 'progress', ((e) ->
          # console.log 'progress ' + e.key
          # update bar
          bar.value = e.progress * 100
          # dispatch event
          event = tm.event.Event 'progress'
          event.progress = e.progress
          event.key = e.key
          @fire event
        ).bind(@)

        loader.load @_assets.shift()
    ).bind(@)


  ###* アセットの追加
  * @memberof SceneLoading#
  * @param {Array|Hash} assets 追加するアセット
  ###
  addAssets: (assets) ->
    if Array.isArray assets
      @_assets = @_assets.concat(assets)
    else
      @_assets.push assets
