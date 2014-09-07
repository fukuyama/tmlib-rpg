
# フラグ操作
tm.define 'rpg.event_command.Flag',

  # コマンド
  apply_command: (flag, value1, value2) ->
    rsf = rpg.game.flag
    m = flag.match /^system:(.+)$/
    if m?
      flag = m[1]
      rsf = rsf.system
    if typeof value1 is 'boolean'
      if value1
        rsf.on flag
      else
        rsf.off flag
    else if typeof value1 is 'string'
      value2 = @normalizeEventValue 'flag', value2
      switch value1
        when '=' then rsf.set   flag, value2
        when '+' then rsf.plus  flag, value2
        when '-' then rsf.minus flag, value2
        when '*' then rsf.multi flag, value2
        when '/' then rsf.div   flag, value2
    rpg.system.scene.refreshEvent?()
    false

rpg.event_command.flag = rpg.event_command.Flag()
