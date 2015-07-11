
# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Shop)', () ->
  interpreter = null
  @timeout(10000)
  describe 'お店イベントの確認', ->
    describe 'お店イベント開始', ->
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を開始する', ->
        #checkWait done, -> interpreter.isEnd()
        console.log "interpreter shop start."
        interpreter.start [
          {type:'move_map',params:[2,9,4,2]}
        ]
      it '移動確認', (done) ->
        checkMapMove '002',9,4,'down',done
      it 'メニュー開く', (done) ->
        emulate_key('enter',done)
      it 'はなす', (done) ->
        emulate_key('enter',done)
      it 'メッセージ確認', (done) ->
        checkMessage(done,'いらっしゃいませ。\\nここは雑貨屋です。')
      it 'enter', (done) ->
        emulate_key('enter',done)
