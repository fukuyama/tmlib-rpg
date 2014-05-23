
# 構造終了(条件/ループ等)
tm.define 'rpg.event_command.End',

  # コマンド
  apply_command: () ->
    # ループ end の場合
    if @command(@index - 2).type is 'loop'
      # index を戻す
      @index -= 2
    false

rpg.event_command.end = rpg.event_command.End()
