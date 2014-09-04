###*
* @file Message.coffee
* 文章表示
###

# 文章表示
tm.define 'rpg.event_command.Message',

  ###* イベントコマンドの反映。
  * Interpreter インスタンスのメソッドとして実行される。
  * イベントコマンド自体のインスタンスは、@event_command で取得する。
  * @memberof rpg.event_command.Message#
  * @param {string} msg 表示するメッセージ。
  * @return {boolean} false
  ###
  apply_command: (msgs ...) ->
    tmp = rpg.system.temp
    tmp.message = msgs
    # 文章が続く場合まとめて表示する。
    while @hasNext()
      command = @nextCommand()
      break if command.type isnt 'message'
      tmp.message.push m for m in command.params
      @next()
    # 文章表示終了処理
    self = @
    tmp.messageEndProc = -> self.waitFlag = false
    @waitFlag = true
    # 次のコマンドが選択肢か数値入力の場合続けて処理する
    if @hasNext() and
    (@nextCommand().type is 'select' or
    @nextCommand().type is 'input_num')
      @next().execute()
    false

  ###* イベントコマンドの作成
  * @memberof rpg.event_command.Message#
  * @param {string} msg 表示するメッセージ。
  * @return {Object} コマンドデータ
  ###
  create: (msg) ->
    {type:'message',params:[msg]}

rpg.event_command.message = rpg.event_command.Message()
