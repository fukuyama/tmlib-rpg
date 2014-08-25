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

# rpg.event_command パッケージから create メソッドを持ったイベントコマンドで
# コマンドを生成するメソッドを作成
for own cmd,ins of rpg.event_command when ins.create?
  rpg.EventGenerator.prototype[cmd] = (->
    f = ins.create
    -> @commands.push f.apply(@,arguments)
  )()
