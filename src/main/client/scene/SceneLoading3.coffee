###*
* @file SceneLoading.coffee
* ロードシーン
###

DEFAULT_PARAM =
    width: 465
    height: 465
    bgColor: 'transparent'

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
    @param = param = {}.$extend(DEFAULT_PARAM, args)

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
          text: 'LOADING'
          x: param.width / 2
          y: param.height / 2 - 20
          align: 'center'
          baseline: 'middle'
          fontSize: 46
          shadowBlur: 4
          shadowColor: 'hsl(190, 100%, 50%)'
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
          y: 0

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
      console.log param
      if param.assets
        loader = tm.asset.Loader()

        loader.on 'load', (->
          stage.tweener.clear().wait(200).fadeOut(200).call (->
            console.log 'load'
            @fire tm.event.Event 'load'
            if param.nextScene?
              rpg.system.replaceScene
                scene: param.nextScene
                param: param.param
            else if param.autopop
              @app.popScene()
          ).bind(@)
        ).bind(@)

        loader.on 'progress', ((e) ->
          console.log 'progress'
          # update bar
          bar.value = e.progress * 100
          # dispatch event
          event = tm.event.Event 'progress'
          event.progress = e.progress
          @fire event
        ).bind(@)

        loader.load(param.assets)
    ).bind(@)
