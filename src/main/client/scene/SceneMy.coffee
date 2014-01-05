
tm.define "SceneMy",
  superClass: "tm.app.Scene"

  init: ->
    # 親の初期化
    @superInit()

    #window1 = rpg.Window(50, 50, 200, 200)
    #@addChild(window1)
    w = rpg.WindowInputNum(max:999900,step:100).open()
    w.addCloseListener((-> console.log w.value))
    @addChild(w)
