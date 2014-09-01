###*
* @file EventGenerator.coffee
* イベント作成クラス
###

tm.define 'rpg.EventGenerator',

  ###* コンストラクタ
  * @classdesc イベント作成クラス
  * @constructor rpg.EventGenerator
  ###
  init: (args={}) ->
    @commands = []

  itemThrow: (owner,item) ->
    @message """
    #{owner.name} は #{item.name} を
    なげすてた。
    """

  itemTradeSwap: (owner,target,item1,item2) ->
    @message """
    #{owner.name} は #{item1.name} を
    #{target.name} の #{item2.name} とこうかんした。
    """

  itemTradeHandOver: (owner,target,item) ->
    @message """
    #{owner.name} は #{item.name} を
    #{target.name} に手渡した。
    """

  itemUseOk: (user,item,target,log) ->
    msgs = item.message.ok
    return unless msgs?
    msgs = [msgs] unless Array.isArray msgs
    for msg in msgs
      msg = msg.replace /user.name/g, user.name
      msg = msg.replace /item.name/g, item.name
      msg = msg.replace /target.name/g, target.name
      msg = msg.replace /effect.value/g, log.targets[0].hp
      @message msg
    return

  itemUseNg: (user,item,target,log) ->
    msgs = item.message.ng
    return unless msgs?
    msgs = [msgs] unless Array.isArray msgs
    for msg in msgs
      msg = msg.replace /user.name/g, user.name
      msg = msg.replace /item.name/g, item.name
      msg = msg.replace /target.name/g, target.name
      msg = msg.replace /value/g, log.targets[0].hp
      @message msg
    return

# rpg.event_command パッケージから create メソッドを持ったイベントコマンドで
# コマンドを生成するメソッドを作成
for own cmd,ins of rpg.event_command when ins.create?
  rpg.EventGenerator.prototype[cmd] = (->
    f = ins.create
    -> @commands.push f.apply(@,arguments)
  )()
