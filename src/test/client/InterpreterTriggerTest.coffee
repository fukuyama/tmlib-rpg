
getMessage = -> rpg.system.scene.windowMessage._message

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Trigger)', () ->
  interpreter = null
  @timeout(10000)
  describe 'イベントトリガーの確認', ->
    describe 'イベントへの接触判定', ->
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '移動', ->
        rpg.system.player.character.moveTo 19, 5
      it 'Enter', (done) ->
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
