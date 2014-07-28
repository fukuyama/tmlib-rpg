
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

    # Mocha Mode の場合、n キーでデバック用のコールバックを呼ぶ
    if rpg.mocha
      sys = rpg.system
      @addEventListener('enterframe',->
        if sys.app.keyboard.getKeyUp('n') and sys.temp.callback?
          sys.temp.callback()
          sys.temp.callback = null
      )

  transitionScene: (args={}) ->
    rpg.system.transitionScene args

  replaceScene: (args={}) ->
    rpg.system.replaceScene args

  loadScene: (args={}) ->
    rpg.system.loadScene args
