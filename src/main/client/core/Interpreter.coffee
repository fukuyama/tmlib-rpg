
# イベントのインタプリタ
tm.define 'rpg.Interpreter',

  # 初期化
  init: (args={}) ->
    {
      @index
      @indent
      @flagWait
    } = {
      index: 0
      indent: 0
      flagWait: false
    }.$extend args
    @clear()

  # 状態クリア
  clear: ->
    @index = 0
    @commands = []
    @event = null

  # イベント開始
  start: (args) ->
    if args instanceof rpg.Event
      @event = args
      @commands = args.commands
    else
      @commands = args
    @index = 0
    
  # イベント終了
  end: ->
    @clear()

  # イベント実行中かどうか
  isRunning: -> @commands.length isnt 0

  # 更新
  update: ->
    while not @isEnd()
      return if @flagWait
      return if @execute()
      @next()
    @clear()

  # イベント実行
  execute: (command) ->
    command = @command() unless command?
    @['command_' + command.type].apply(@, command.params)

  # 終わりかどうか
  isEnd: ->
    @index >= @commands.length
  # 次があるかどうか
  hasNext: ->
    @index + 1 < @commands.length
  # 次へ
  next: ->
    @index++
    @
  # 今のコマンド
  command: ->
    @commands[@index]

  # 次のコマンド
  nextCommand: ->
    @commands[@index + 1]
  
  #-------------------
  # イベントコマンド

  # script
  command_script: (script) ->
    # TODO: eval は危険かな～？
  
  # messge
  command_message: (msg) ->
    rpg.system.temp.message = [msg]
    while @hasNext()
      command = @nextCommand()
      return if command.type isnt 'message'
      rpg.system.temp.message.push command.params[0]
      @next()

    rpg.system.temp.messageEndProc = (->
      @flagWait = false
    ).bind(@)
    @flagWait = true
    false

  # flag
  command_flag: (key) ->
    