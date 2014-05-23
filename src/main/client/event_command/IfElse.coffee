
# 条件分岐
tm.define 'rpg.event_command.If',

  # コマンド
  apply_command: (type) ->
    # 条件の結果
    result = false
    switch type
      when 'flag' # フラグによる分岐 type is 'flag'
        rsf = rpg.game.flag
        if arguments.length == 3
          flag = arguments[1]
          value = arguments[2]
          result = rsf.is(flag) is value
        if arguments.length == 4
          flag = arguments[1]
          ope = arguments[2]
          value = arguments[3]
          fvalue = rsf.get(flag)
          switch ope
            when '==' then result = fvalue == value
            when '!=' then result = fvalue != value
            when '<'  then result = fvalue < value
            when '>'  then result = fvalue > value
            when '<=' then result = fvalue <= value
            when '>=' then result = fvalue >= value

    # else ブロックがある場合 結果を保存
    if @command(@index + 2).type is 'else'
      @command(@index + 2).params[0] = result
    # 結果が false の場合
    unless result
      # 次のブロックを飛ばす
      @next()
    false

# 分岐条件に合わない場合
# result: if コマンドで保存された結果
tm.define 'rpg.event_command.Else',

  # コマンド
  apply_command: (result) ->
    # 条件分岐の結果が true の場合
    if result
      # 次のブロックを飛ばす
      @next()
    false

rpg.event_command.if = rpg.event_command.If()
rpg.event_command.else = rpg.event_command.Else()
