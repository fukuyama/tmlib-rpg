
findCharactor = (chara) ->
  if chara == 'player'
    return rpg.system.player.character
  return rpg.system.scene.map.events[chara]

# 移動ルートの設定
tm.define 'rpg.event_command.MoveRoute',

  # コマンド
  apply_command: (chara,route) ->
    if rpg.system.scene.map?
      c = findCharactor(chara)
      c.forceMoveRoute(route)
    false

rpg.event_command.move_route = rpg.event_command.MoveRoute()

# 移動ルートの設定
tm.define 'rpg.event_command.MoveTo',

  # コマンド
  apply_command: (chara,x,y) ->
    if rpg.system.scene.map?
      c = findCharactor(chara)
      c.moveTo x, y
    false

rpg.event_command.move_to = rpg.event_command.MoveTo()
