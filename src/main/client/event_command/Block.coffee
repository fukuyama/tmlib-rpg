
# ブロック
tm.define 'rpg.event_command.Block',

  # コマンド
  apply_command: ->
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
tm.define 'rpg.event_command.BlockEnd',

  # コマンド
  apply_command: ->
    [@indent,@index,@commands] = @blocks.pop()
    false

rpg.event_command.block = rpg.event_command.Block()
rpg.event_command.block_end = rpg.event_command.BlockEnd()
