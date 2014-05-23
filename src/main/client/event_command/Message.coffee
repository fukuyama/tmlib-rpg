
# 文章表示
tm.define 'rpg.event_command.Message',

  # コマンド
  apply_command: (msg) ->
    tmp = rpg.system.temp
    tmp.message = [msg]
    # 文章が続く場合まとめて表示する。
    while @hasNext()
      command = @nextCommand()
      break if command.type isnt 'message'
      tmp.message.push command.params[0]
      @next()
    # 文章表示終了処理
    tmp.messageEndProc = (->
      @waitFlag = false
    ).bind(@)
    @waitFlag = true
    # 次のコマンドが選択肢か数値入力の場合続けて処理する
    if @hasNext() and
    (@nextCommand().type is 'select' or @nextCommand().type is 'input_num')
      @next().execute()
    false

rpg.event_command.message = rpg.event_command.Message()
