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

  itemThrow: (user1,item1) ->
    @message """
    #{user1.name}は#{item1.name}を
    なげすてた。
    """

  itemTradeSwap: (user1,user2,item1,item2) ->
    @message """
    #{user1.name}は#{item1.name}を
    #{user2.name}の#{item2.name}とこうかんした。
    """

  itemTradeHandOver: (user1,user2,item1) ->
    @message """
    #{user1.name}は#{item1.name}を
    #{user2.name}に手渡した。
    """


# rpg.event_command パッケージから create メソッドを持ったイベントコマンドで
# コマンドを生成するメソッドを作成
for own cmd,ins of rpg.event_command when ins.create?
  rpg.EventGenerator.prototype[cmd] = (->
    f = ins.create
    -> @commands.push f.apply(@,arguments)
  )()
