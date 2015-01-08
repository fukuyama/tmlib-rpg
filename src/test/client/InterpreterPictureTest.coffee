
# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Picture)', () ->
  interpreter = null
  @timeout(10000)
  describe 'ピクチャーの表示', ->
    it 'マップシーンへ移動', (done) ->
      reloadTestMap(done)
    it 'wait', (done) ->
      setTimeout(done,1000)
    it 'インタープリタ取得', ->
      interpreter = rpg.system.scene.interpreter
    it 'interpreter を開始する', (done)->
      interpreter.start [
        {type:'picture',params:[{src:'test_001.png',x:100,y:100}]}
      ]
      checkWait done, -> interpreter.isEnd()
