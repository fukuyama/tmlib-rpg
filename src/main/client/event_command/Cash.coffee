###*
* @file Cash.coffee
* 所持金操作
###

tm.define 'rpg.event_command.Cash',

  ###* コンストラクタ
  * @classdesc 所持金操作
  * @constructor rpg.event_command.Cash
  * @param {string} flag 増減フラグ
  ###
  init: (@flag) ->

  ###* 所持金操作。
  * @memberof rpg.event_command.Cash#
  * @param {number} cash 所持金
  * @return {boolean} false
  ###
  apply_command: (cash) ->
    switch @event_command.flag
      when 'gain'
        rpg.game.party.cash += cash if cash > 0
      when 'lost'
        rpg.game.party.cash -= cash if cash > 0
      when 'auto'
        rpg.game.party.cash += cash
    false

rpg.event_command.gain_cash = rpg.event_command.Cash('gain')
rpg.event_command.lost_cash = rpg.event_command.Cash('lost')
rpg.event_command.cash = rpg.event_command.Cash('auto')
