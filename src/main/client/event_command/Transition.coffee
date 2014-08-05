
# トランジション準備
tm.define 'rpg.event_command.SetupTransition',

  # コマンド
  apply_command: (options) ->
    {
      app
      scene
    } = rpg.system
    # トランジション作成
    transition = tm.display.TransitionShape(
      app.width
      app.height
      {
        source: app.canvas.getBitmap() # 表示内容をBitmap化
      }.$extend options
    ).
    setOrigin(0,0).
    setPosition(0,0)
    rpg.system.temp.transition = transition
    # 次のコマンドがマップ移動だったらトランジションを反映させる(ちらつき防止)
    if @nextCommand().type == 'move_map'
      if scene.getChildAt(transition) < 0
        scene.addChild(transition)
      @next()
      return true
    return false

rpg.event_command.setup_transition = rpg.event_command.SetupTransition()

# トランジション開始
tm.define 'rpg.event_command.StartTransition',

  # コマンド
  apply_command: () ->
    return false unless rpg.system.temp.transition?
    {
      app
      scene
    } = rpg.system
    transition = rpg.system.temp.transition
    if scene.getChildAt(transition) < 0
      scene.addChild(transition) # 切替先のシーンに追加する
      return true
    if transition.isEnd()
      # トランジションが終わっていたら削除
      transition.remove()
      rpg.system.temp.transition = null
    else
      # フレームごとにトランジションを進める
      transition.increment()
    true

rpg.event_command.start_transition = rpg.event_command.StartTransition()
