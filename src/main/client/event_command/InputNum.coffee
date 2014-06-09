
# 数値入力
tm.define 'rpg.event_command.InputNum',

  # コマンド
  apply_command: (flag, options) ->
    rpg.system.temp.inputNumArgs = {
      flag: flag
      options: {}.$extend options
      callback: ((num) ->
        rpg.game.flag.set(flag, num)
        @waitFlag = false
      ).bind(@)
    }
    @waitFlag = true
    false

rpg.event_command.input_num = rpg.event_command.InputNum()
