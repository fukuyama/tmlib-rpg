
# 関数実行
tm.define 'rpg.event_command.Function',

  # コマンド
  apply_command: (f) ->
    # 本当は、function が json に入らないのでスクリプトとかデバック用
    f.call()
    false

rpg.event_command.function = rpg.event_command.Function()
