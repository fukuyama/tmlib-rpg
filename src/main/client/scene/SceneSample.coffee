tm.define "SceneSample",

  superClass: "tm.app.Scene"

  init: ->
    # 親の初期化
    this.superInit()
    # 星スプライト
    this.star = tm.app.StarShape 64, 64
    # シーンに追加
    this.addChild(this.star)

  update: (app) ->
    p = app.pointing
    # マウス位置 or タッチ位置に移動
    this.star.x = p.x
    this.star.y = p.y
    # クリック or タッチ中は回転させる
    if app.pointing.getPointing()
      this.star.rotation += 15
