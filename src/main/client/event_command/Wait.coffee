
# ウェイト
tm.define 'rpg.event_command.Wait',

  # コマンド
  apply_command: (n) ->
    @waitCount += 1
    return true if @waitCount < n
    @waitCount = 0
    false

rpg.event_command.wait = rpg.event_command.Wait()
