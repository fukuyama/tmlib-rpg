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

  itemEquip: (owner,item) ->
    @message """
    #{owner.name} は #{item.name} を
    そうびした。
    """
    return
  itemEquipError: (owner,item) ->
    @message """
    #{owner.name} は #{item.name} を
    そうびできなかった。
    """
    return
  itemEquipOff: (owner,item) ->
    @message """
    #{owner.name} は #{item.name} を
    はずした。
    """
    return
  itemEquipOffError: (owner,item) ->
    @message """
    #{owner.name} は #{item.name} を
    はずせなかった。
    """
    return
  itemThrow: (owner,item) ->
    @message """
    #{owner.name} は #{item.name} を
    なげすてた。
    """
    return
  itemTradeSwap: (owner,target,item1,item2) ->
    @message """
    #{owner.name} は #{item1.name} を
    #{target.name} の #{item2.name} とこうかんした。
    """
    return
  itemTradeHandOver: (owner,target,item) ->
    @message """
    #{owner.name} は #{item.name} を
    #{target.name} に手渡した。
    """
    return

  itemUseError: (user,item) ->
    @message "#{user.name} は #{item.name} を使った。"
    @message "しかし 効果がなかった。"
    return

  itemUseOk: (user,item,target,log) ->
    msgs = item.message.ok
    return unless msgs?
    @commands.push m for m in msgs
    return

  itemUseNg: (user,item,target,log) ->
    msgs = item.message.ng
    return unless msgs?
    @commands.push m for m in msgs
    return

# rpg.event_command パッケージから create メソッドを持ったイベントコマンドで
# コマンドを生成するメソッドを作成
for own cmd,ins of rpg.event_command when ins.create?
  rpg.EventGenerator.prototype[cmd] = (->
    f = ins.create
    -> @commands.push f.apply(@,arguments)
  )()
