
# シーンクラス
tm.define 'rpg.SceneBase',
  superClass: tm.app.Scene

  init: (args={}) ->
    # 親の初期化
    @superInit()
    {
      @name
    } = {
      name: ''
    }.$extendAll args

  replaceScene: (args={}) ->
    rpg.system.replaceScene args

  loadScene: (args={}) ->
    rpg.system.loadScene args
