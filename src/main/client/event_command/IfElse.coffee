
# 条件分岐
tm.define 'rpg.event_command.If',

  split_params: (params) ->
    lval = []
    ope = null
    rval = []
    while params.length != 0
      param = params.shift()
      if typeof param is 'string'
        m = param.match(/^(\=\=|\!\=|\<|\>|\<\=|\=\<|\>\=|\=\>)$/)
        if m?
          ope = m[1]
          param = params.shift()
      if ope?
        rval.push param
      else
        lval.push param
    return [lval,ope,rval]

  # コマンド
  apply_command: (args ... ) ->
    ec = rpg.event_command.if
    [lval,ope,rval] = ec.split_params args
    # 条件の結果
    result = false
    if ope?
      lvalue = @normalizeEventValue(lval[0],lval[1])
      rvalue = @normalizeEventValue(rval[0],rval[1])
      switch ope
        when '==' then result = lvalue == rvalue
        when '!=' then result = lvalue != rvalue
        when '<'  then result = lvalue <  rvalue
        when '>'  then result = lvalue >  rvalue
        when '<=' then result = lvalue <= rvalue
        when '=<' then result = lvalue <= rvalue
        when '>=' then result = lvalue >= rvalue
        when '=>' then result = lvalue >= rvalue
    else
      result = @normalizeEventBool(lval[0],lval[1]) is lval[2]

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
