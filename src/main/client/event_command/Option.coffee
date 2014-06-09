
# オプション
tm.define 'rpg.event_command.Option',

  # コマンド
  apply_command: (options) ->
    # temp にオプションを渡す
    rpg.system.temp.options = options
    false

rpg.event_command.option = rpg.event_command.Option()
