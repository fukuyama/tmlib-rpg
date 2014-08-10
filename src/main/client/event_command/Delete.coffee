###*
* @file Delete.coffee
* イベント削除
###

tm.define 'rpg.event_command.Delete',

  ###* イベントコマンドの反映。
  * Interpreter インスタンスのメソッドとして実行される。
  * イベントコマンド自体のインスタンスは、@event_command で取得する。
  * @memberof rpg.event_command.Delete#
  * @param {string} name 削除するイベント名
  * @return {boolean} false
  ###
  apply_command: (name) ->
    unless name?
      name = @event.name
    c = @findCharacter(name)
    if c?
      c.remove = true
      delete rpg.system.scene.map.events[name]
    false

# イベントの削除
rpg.event_command.delete = rpg.event_command.Delete()
