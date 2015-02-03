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
            key: 'anime001'
            src:
              x: 100
              y: 100
              sprites:
                sprite_1:
                  src: 'hiyoco_nomal_full.png'
                  frameIndex: [0,32,32]
                  size: [32,32]
              timeline: [
                {
                  sprite_1: {delay: 20, x: 0,y: 0}
                }
                {
                  sprite_1: {delay: 120, x: 10,y: 0}
                }
                {
                  sprite_1: {delay: 120, x: 10,y: 10}
                }
                {
                  sprite_1: {delay: 120, x: -10,y: 10}
                }
                {
                  sprite_1: {delay: 120, x: -10,y: -10}
                }
            ]
          }]}
        ]
        checkWait done, -> interpreter.isEnd()
