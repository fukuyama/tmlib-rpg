###*
* @file Return.coffee
* イベントの中断
###

tm.define 'rpg.event_command.Return',

  ###* イベントコマンドの反映。
  * Interpreter インスタンスのメソッドとして実行される。
  * イベントコマンド自体のインスタンスは、@event_command で取得する。
  * @memberof rpg.event_command.Return#
  * @return {boolean} false
  ###
  apply_command: () ->
    @clear()
    false

rpg.event_command.return = rpg.event_command.Return()
