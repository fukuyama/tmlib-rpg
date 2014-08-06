
# ブロック
tm.define 'rpg.event_command.Visible',

  # コマンド
  apply_command: (chara, visible) ->
    if rpg.system.scene.map?
      c = @findCharactor(chara)
      c.visible = visible
    false

rpg.event_command.visible = rpg.event_command.Visible()
