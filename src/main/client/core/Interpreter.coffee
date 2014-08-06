
# イベントのインタプリタ
tm.define 'rpg.Interpreter',

  # 初期化
  init: (args={}) ->
    {
      @index
      @blocks
      @waitFlag
      @waitCount
    } = {
      index: 0
      blocks: []
      waitFlag: false
      waitCount: 0
    }.$extend args
    @clear()

  # 状態クリア
  clear: ->
    @index = 0
    @blocks = []
    @commands = []
    @event = null
    @waitFlag = false
    @waitCount = 0

  # イベント開始
  start: (args) ->
    if args instanceof rpg.Event
      @event = args
      @commands = [].concat args.commands
    else
      @commands = [].concat args
    # console.log "event start"
    # console.log @commands
    @index = 0
    
  # イベント終了
  end: ->
    @event.end() if @event? and @event.end?
    @clear()

  # イベント実行中かどうか
  isRunning: -> @commands.length isnt 0

  # 更新
  update: ->
    return unless @isRunning()
    return if @waitFlag
    if @isEnd()
      @end()
      return
    while not @isEnd()
      return if @waitFlag
      return if @execute()
      @next()

  # イベント実行
  execute: (command) ->
    command = @command() unless command?
    # DEBUG
    #console.log "index=#{@index}"+
    #" comannds.length=#{@commands.length}"+
    #" blocks.length=#{@blocks.length}"
    #console.log command
    #console.log 'command:' + command.type
    if rpg.event_command[command.type]?
      f = rpg.event_command[command.type].apply_command
    if f?
      return f.apply(@, command.params)
    else
      console.error 'command not found. ' + command.type
      false

  # 終わりかどうか
  isEnd: ->
    @index >= @commands.length and @blocks.length is 0

  # 次があるかどうか
  hasNext: ->
    @index + 1 < @commands.length

  # 次へ
  next: ->
    @index++
    @

  # コマンドの取得
  command: (i=@index) ->
    c = @commands[i]
    c.params = [] unless c.params?
    c

  # 次のコマンド
  nextCommand: ->
    @command(@index + 1)

  # キャラクター検索
  findCharactor: (chara) ->
    if chara == 'player'
      return rpg.system.player.character
    return rpg.system.scene.map.events[chara]
