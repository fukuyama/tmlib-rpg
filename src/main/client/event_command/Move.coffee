
# 移動ルートの設定
tm.define 'rpg.event_command.MoveRoute',

  # コマンド
  apply_command: (chara,route) ->
    if rpg.system.scene.map?
      c.forceMoveRoute(route)
    false

rpg.event_command.move_route = rpg.event_command.MoveRoute()
