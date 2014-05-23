
# ループ
tm.define 'rpg.event_command.Loop',

  # コマンド
  apply_command: () ->
    false

# ループブレイク
tm.define 'rpg.event_command.Break',

  # コマンド
  apply_command: () ->
    # ブロックがある間ループ
    while @blocks.length > 0
      # 今のブロックを抜ける
      @execute(type:'block_end')
      # ループブロックの場合終わり
      if @command(@index - 1).type is 'loop'
        break
    # 次に進む
    @next()
    false

rpg.event_command.loop = rpg.event_command.Loop()
rpg.event_command.break = rpg.event_command.Break()
