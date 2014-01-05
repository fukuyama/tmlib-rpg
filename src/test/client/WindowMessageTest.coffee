
describe 'rpg.WindowMessage', ->
  describe '文章表示', ->
    interpreter = null
    commands = [
      {type:'message',params:['TEST1']}
      {type:'message',params:['TEST2']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
  describe '文章表示２行', ->
    interpreter = null
    commands = [
      {type:'message',params:['TEST1\\nTEST1']}
      {type:'message',params:['TEST2\\nほえほえ']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
  describe '文章表示３行', ->
    interpreter = null
    commands = [
      {type:'message',params:['TEST1\\nTEST1\\nTEST1']}
      {type:'message',params:['TEST2\\nほえほえ\\nTEST2']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
  describe '文章表示２行 x ４回', ->
    @timeout(10000)
    interpreter = null
    commands = [
      {type:'message',params:['TEST1\\nTEST1']}
      {type:'message',params:['TEST2\\nほえほえ']}
      {type:'message',params:['Aほえほえあああ\\nあああああああ']}
      {type:'message',params:['ふにふに\\nXXXX']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,2000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
  describe '文章表示３行 x ４回', ->
    @timeout(10000)
    interpreter = null
    commands = [
      {type:'message',params:['0123456789\\n0123456789\\n0123456789']}
      {type:'message',params:['AAAAAAAAAA\\nBBBBBBBBBB\\nCCCCCCCCCC']}
      {type:'message',params:['DDDDDDDDDD\\nEEEEEEEEEE\\nFFFFFFFFFF']}
      {type:'message',params:['GGGGGGGGGG\\nHHHHHHHHHH\\nIIIIIIIIII']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
