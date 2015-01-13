
# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Picture)', () ->
  interpreter = null
  @timeout(10000)
  describe 'ピクチャーの操作１', ->
    describe 'ピクチャーの表示', ->
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を開始する', (done)->
        interpreter.start [
          {type:'picture',params:[{key:'image1',src:'test_001.png',x:100,y:100}]}
        ]
        checkWait done, -> interpreter.isEnd()
    describe 'ピクチャーの移動', ->
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を開始する', (done)->
        interpreter.start [
          {type:'picture',params:[{key:'image1',x:200,y:100}]}
        ]
        checkWait done, -> interpreter.isEnd()
    describe 'ピクチャーの削除', ->
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を開始する', (done)->
        interpreter.start [
          {type:'picture_remove',params:[{key:'image1'}]}
        ]
        checkWait done, -> interpreter.isEnd()
  describe 'ピクチャーの操作２', ->
    describe 'ピクチャーの表示', ->
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を開始する', (done)->
        interpreter.start [
          {type:'picture',params:[{key:'image1',src:'test_001.png',x:100,y:100}]}
          {type:'picture',params:[{key:'image2',src:'test_001.png',x:100,y:200}]}
        ]
        checkWait done, -> interpreter.isEnd()
    describe 'ピクチャーの移動', ->
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を開始する', (done)->
        interpreter.start [
          {type:'picture',params:[{key:'image1',x:200,y:100}]}
        ]
        checkWait done, -> interpreter.isEnd()
    describe 'ピクチャーの削除', ->
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を開始する', (done)->
        interpreter.start [
          {type:'picture_remove',params:[{key:'image1'}]}
          {type:'picture_remove',params:[{key:'image2'}]}
        ]
        checkWait done, -> interpreter.isEnd()
