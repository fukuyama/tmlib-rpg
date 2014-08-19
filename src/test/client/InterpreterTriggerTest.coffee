
getMessage = -> rpg.system.scene?.windowMessage?._message

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Trigger)', () ->
  interpreter = null
  @timeout(10000)
  describe 'イベントトリガーの確認', ->
    describe 'イベントへの接触判定', ->
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'wait', (done) ->
        setTimeout(done,500)
      it '移動', ->
        rpg.system.player.character.moveTo 19, 5
      it 'right', (done) ->
        emulate_key 'right', done
      it 'メッセージ表示待ち', (done) ->
        setTimeout done, 2000
      it 'Enter', (done) ->
        emulate_key 'enter', done
      it 'メッセージ表示待ち', (done) ->
        setTimeout done, 2000
      it 'Enter', (done) ->
        getMessage().should.equals 'フラグＡ=OFF'
        emulate_key 'enter', done
      it 'up', (done) ->
        emulate_key 'up', done
      it 'down', (done) ->
        emulate_key 'down', done
      it 'メッセージ表示待ち', (done) ->
        setTimeout done, 2000
      it 'Enter', (done) ->
        emulate_key 'enter', done
      it 'メッセージ表示待ち', (done) ->
        setTimeout done, 2000
      it 'Enter', (done) ->
        getMessage().should.equals 'フラグＡ=ON'
        emulate_key 'enter', done
    describe 'イベントの自動起動', ->
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'Interpreter 取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'Interpreter 実行', ->
        interpreter.start [
          {type:'move_map',params:[3,0,0,2]}
        ]
      it 'メッセージ表示待ち', (done) ->
        setTimeout done, 1000
      it '自動実行確認', (done) ->
        checkWait done, -> getMessage() == 'auto message'
      it 'Enter', (done) ->
        emulate_key 'enter', done
