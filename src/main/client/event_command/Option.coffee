###*
* @file Option.coffee
# オプション
###

tm.define 'rpg.event_command.Option',

  ###* オプション設定。
  * イベントコマンドをまたぐようなオプションは、これで設定するつもり。
  * @memberof rpg.event_command.Option#
  * @param {Object} options
  * @param {Object} options.message メッセージオプション
  * @param {boolean} options.message.close メッセージウィンドウを表示毎にクローズする場合は、true (default)
  * @param {number} options.message.position メッセージウィンドウ表示位置 TOP(1),CENTER(2),BOTTOM(3=default)
  * @param {number} options.select 選択肢オプション
  * @param {number} options.select.position 選択肢ウィンドウ表示位置 LEFT(1),CENTER(2),RIGHT(3=default)
  * @param {number} options.input_num 数値入力オプション
  * @param {number} options.input_num.position 数値入力ウィンドウ表示位置 LEFT(1),CENTER(2),RIGHT(3=default)
  * @return {boolean} false
  ###
  apply_command: (options) ->
    # temp にオプションを渡す
    rpg.system.temp.options = options
    false

rpg.event_command.option = rpg.event_command.Option()
