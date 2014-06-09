
# 選択肢表示
tm.define 'rpg.event_command.Select',

  # コマンド
  apply_command: (menus, options) ->
    rpg.system.temp.selectArgs = {
      menus: [].concat menus
      options: {}.$extend options
      callback: ((select) ->
        base = @index
        i = 0
        # 選択したブロックに情報を設定する
        while @command(base + i).type is 'block'
          c = @command(base + i)
          c.select = select == i
          i++
        @waitFlag = false
      ).bind(@)
    }
    @waitFlag = true
    false

rpg.event_command.select = rpg.event_command.Select()
