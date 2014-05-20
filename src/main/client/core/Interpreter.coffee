
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
    f = @['command_' + command.type]
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
  
  #-------------------
  # イベントコマンド

  # 関数実行
  # 本当は、function は params に入らないのでスクリプトとかデバック用
  command_function: (f) ->
    f.call()
    false

  # script
  command_script: (script) ->
    # TODO: eval は危険かな～？

  # オプション
  command_option: (options) ->
    # temp にオプションを渡す
    rpg.system.temp.options = options
    false
    
  # 文章表示
  command_message: (msg) ->
    tmp = rpg.system.temp
    tmp.message = [msg]
    # 文章が続く場合まとめて表示する。
    while @hasNext()
      command = @nextCommand()
      break if command.type isnt 'message'
      tmp.message.push command.params[0]
      @next()
    # 文章表示終了処理
    tmp.messageEndProc = (->
      @waitFlag = false
    ).bind(@)
    @waitFlag = true
    # 次のコマンドが選択肢か数値入力の場合続けて処理する
    if @hasNext() and
    (@nextCommand().type is 'select' or @nextCommand().type is 'input_num')
      @next().execute()
    false

  # フラグ操作
  command_flag: (flag, value1, value2) ->
    rsf = rpg.game.flag
    if typeof value1 is 'boolean'
      if value1
        rsf.on flag
      else
        rsf.off flag
    else if typeof value1 is 'string'
      value2 = rsf.get(value2) if typeof value2 is 'string'
      switch value1
        when '=' then rsf.set flag, value2
        when '+' then rsf.plus flag, value2
        when '-' then rsf.minus flag, value2
        when '*' then rsf.multi flag, value2
        when '/' then rsf.div flag, value2
    false

  # ブロック
  command_block: ->
    command = @command()
    # 選択肢表示で選択されたブロックでは無い場合は飛ばす
    return false if command.select? and command.select is false
    # 今の状態を保存
    @blocks.push [@indent,@index,@commands]
    # ブロックをコピー（先頭は実行されない）
    @commands = [{type:'block_start'}].concat @command().params
    # ブロック終了コマンドを追加
    @commands.push {type:'block_end'}
    # ブロックを最初から実行
    @index = 0
    false

  # ブロック終了(内部用)
  command_block_end: ->
    [@indent,@index,@commands] = @blocks.pop()
    false

  # 条件分岐
  command_if: (type) ->
    # 条件の結果
    result = false
    switch type
      when 'flag' # フラグによる分岐 type is 'flag'
        rsf = rpg.game.flag
        if arguments.length == 3
          flag = arguments[1]
          value = arguments[2]
          result = rsf.is(flag) is value
        if arguments.length == 4
          flag = arguments[1]
          ope = arguments[2]
          value = arguments[3]
          fvalue = rsf.get(flag)
          switch ope
            when '==' then result = fvalue == value
            when '!=' then result = fvalue != value
            when '<'  then result = fvalue < value
            when '>'  then result = fvalue > value
            when '<=' then result = fvalue <= value
            when '>=' then result = fvalue >= value

    # else ブロックがある場合 結果を保存
    if @command(@index + 2).type is 'else'
      @command(@index + 2).params[0] = result
    # 結果が false の場合
    unless result
      # 次のブロックを飛ばす
      @next()
    false

  # 分岐条件に合わない場合
  # result: if コマンドで保存された結果
  command_else: (result) ->
    # 条件分岐の結果が true の場合
    if result
      # 次のブロックを飛ばす
      @next()
    false

  # 構造終了(条件/ループ等)
  command_end: () ->
    # ループ end の場合
    if @command(@index - 2).type is 'loop'
      # index を戻す
      @index -= 2
    false

  # ループ
  command_loop: () ->
    false

  # ループブレイク
  command_break: () ->
    # ブロックがある間ループ
    while @blocks.length > 0
      # 今のブロックを抜ける
      @command_block_end()
      # ループブロックの場合終わり
      if @command(@index - 1).type is 'loop'
        break
    # 次に進む
    @next()
    false

  # ウェイト
  command_wait: (n) ->
    @waitCount += 1
    return true if @waitCount < n
    @waitCount = 0
    false

  # 選択肢表示
  command_select: (menus, options) ->
    rpg.system.temp.selectArgs = {
      menus: [].concat menus
      options: {}.$extend options
      callback: ((select) ->
        base = @index
        i = 0
        # 選択したブロックに情報を設定する
        while @command(base + i).type is 'block'
          c = @command(base + i)
          c.select = select == i
          i++
        @waitFlag = false
      ).bind(@)
    }
    @waitFlag = true
    false

  # 数値入力
  command_input_num: (flag, options) ->
    rpg.system.temp.inputNumArgs = {
      flag: flag
      options: {}.$extend options
      callback: ((num) ->
        rpg.game.flag.set(flag, num)
        @waitFlag = false
      ).bind(@)
    }
    @waitFlag = true
    false

  # アイテム操作関連
  
  # アイテムを増やす
  command_gain_item: (item, num = 1, actor = null) ->
    if item.item?
      {item,num,actor,backpack} = {num: 1}.$extend item
    @waitFlag = true
    # 現在のシーンをキャプチャー
    rpg.system.captureScreenBitmap()
    rpg.system.db.item([item],((items) ->
      # 誰かのアイテム
      target = rpg.game.party
      if actor?
        # アクターのアイテム
        actor = rpg.game.party.getAt(actor)
        target = actor.backpack if actor?
      else if backpack?
        # バックパックのアイテム
        target = rpg.game.party.backpack
      # 対象のアイテムを増やす
      for n in [0 ... num]
        target.addItem(i) for i in items
      @waitFlag = false
      ).bind(@)
    )
    false

  # アイテムを減らす
  command_lost_item: (item, num = 1, actor = null) ->
    if item.item?
      {item,num,actor,backpack} = {num: 1}.$extend item
    @waitFlag = true
    # 現在のシーンをキャプチャー
    rpg.system.captureScreenBitmap()
    rpg.system.db.item([item],((items) ->
      # 誰かのアイテム
      target = rpg.game.party
      if actor?
        # アクターのアイテム
        actor = rpg.game.party.getAt(actor)
        target = actor.backpack if actor?
      else if backpack?
        # バックパックのアイテム
        target = rpg.game.party.backpack
      # 対象のアイテムを捨てる
      for n in [0 ... num]
        for i in items
          i = target.getItem(i.name)
          target.removeItem(i) if i?
      @waitFlag = false
      ).bind(@)
    )
    false

  # アイテムをすべて捨てる
  command_clear_item: () ->
    rpg.game.party.clearItem()
    false
