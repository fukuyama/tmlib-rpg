
# 移動ルートの設定
tm.define 'rpg.event_command.MoveRoute',

  # コマンド
  apply_command: (chara,route) ->
    c = @findCharacter(chara)
    c?.forceMoveRoute(route)
    false

rpg.event_command.move_route = rpg.event_command.MoveRoute()

# 移動ルートの設定
tm.define 'rpg.event_command.MoveTo',

  # コマンド
  apply_command: (chara,x,y) ->
    c = @findCharacter(chara)
    c?.moveTo x, y
    false

rpg.event_command.move_to = rpg.event_command.MoveTo()

# マップの移動
tm.define 'rpg.event_command.MoveMap',

  # コマンド
  apply_command: (mapid,x,y,d) ->
    mapid = @normalizeEventValue mapid
    x = @normalizeEventValue x
    y = @normalizeEventValue y
    d = @normalizeEventValue d
    rpg.system.loadMap mapid, ->
      c = rpg.system.player.character
      c.moveTo x, y
      c.direction = d
    @next()
    true

rpg.event_command.move_map = rpg.event_command.MoveMap()
