
# イベントのインタプリタ
tm.define 'rpg.Interpreter',

  # 初期化
  init: (args={}) ->
    {
      @index
      @indent
      @messageWait
    } = {
      index: 0
      indent: 0
      messageWait: false
    }.$extend args
    
    @clear()
    
  clear: ->
    @index = 0
    @commands = null
  

  start: (@commands=[]) ->
    @index = 0

  update: ->
    while @index < @commands.length
      return if @messageWait
      return if @execute()
      @index += 1

  execute: ->
    if @index < @commands.length
      @command = @commands[@index]
      return @['command_' + @command.type].apply(@,@command.params)
    @commands = null
    return true

  command_talk: (msg) ->
    rpg.system.temp.message = msg
    @messageWait = true
    if rpg.system.scene?
      rpg.system.scene.windowMessage.addEventListener('close',(->
        @messageWait = false
      ).bind(@))
