# InterpreterAnimationTest

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Animation)', () ->
  interpreter = null
  @timeout(10000)
  describe 'アニメーションの操作１', ->
    describe 'アニメーションの実行', ->
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を開始する', (done)->
        interpreter.start [
          {type:'animation',params:[{
            sprite_1:
              src: 'anime_001.png'
          }]}
        ]
        checkWait done, -> interpreter.isEnd()
