###*
* @file Function.coffee
* 関数実行
###

# 関数実行
tm.define 'rpg.event_command.Function',

  ###* イベントコマンドの反映
  * @memberof rpg.event_command.Function#
  * @param {Function} f 実行する関数
  * @return {boolean} false
  ###
  apply_command: (f) ->
    # 本当は、function が json に入らないのでスクリプトとかデバック用
    f.call()
    false

  ###* イベントコマンドの作成
  * @memberof rpg.event_command.Function#
  * @param {Function} f 実行する関数
  * @return {Object} コマンドデータ
  ###
  create: (f) ->
    {type:'function',params:[f]}

rpg.event_command.function = rpg.event_command.Function()
