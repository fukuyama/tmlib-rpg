
describe 'rpg.WindowMessage', ->
  interpreter = null
  @timeout(10000)
  describe '文章表示', ->
    commands = [
      {type:'message',params:['TEST1']}
      {type:'message',params:['TEST2']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      setTimeout(done,2000)
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち2', (done) ->
      setTimeout(done,2000)
    it '次のメッセージ表示2', (done) ->
      emulate_key('enter',done)
  describe '文章表示２行', ->
    commands = [
      {type:'message',params:['TEST1\\nTEST1']}
      {type:'message',params:['TEST2\\nほえほえ']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      setTimeout(done,2000)
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち2', (done) ->
      setTimeout(done,2000)
    it '次のメッセージ表示2', (done) ->
      emulate_key('enter',done)
  describe '文章表示３行', ->
    commands = [
      {type:'message',params:['TEST1\\nTEST1\\nTEST1']}
      {type:'message',params:['TEST2\\nほえほえ\\nTEST2']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち2', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示2', (done) ->
      emulate_key('enter',done)
  describe '文章表示２行 x ４回', ->
    commands = [
      {type:'message',params:['TEST1\\nTEST1']}
      {type:'message',params:['TEST2\\nほえほえ']}
      {type:'message',params:['ほえほえあああ\\nあああああああ']}
      {type:'message',params:['ふにふに\\nXXXX']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち2', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示2', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち3', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示3', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち4', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示4', (done) ->
      emulate_key('enter',done)
  describe '文章表示３行 x ４回', ->
    commands = [
      {
        type:'message',
        params:['0123456789\\n01\\C[1]234\\C[0]56789\\n0123456789']
      }
      {type:'message',params:['AAAAAAAAAA\\nBBBBBBBBBB\\nCCCCCCCCCC']}
      {type:'message',params:['DDDDDDDDDD\\nEEEEEEEEEE\\nFFFFFFFFFF']}
      {type:'message',params:['GGGGGGGGGG\\nHHHHHHHHHH\\nIIIIIIIIII']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち2', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示2', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち3', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示3', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち4', (done) ->
      setTimeout(done,3000)
    it '次のメッセージ表示4', (done) ->
      emulate_key('enter',done)
  describe '表示位置変更', ->
    commands = [
      {type:'option',params:[{
        message:
          position: 1
      }]}
      {type:'message',params:['TEST1']}
      {type:'option',params:[{
        message:
          position: 2
      }]}
      {type:'message',params:['TEST2']}
      {type:'option',params:[{
        message:
          position: 3
      }]}
      {type:'message',params:['TEST2']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,2000)
    it '表示位置が一番上に', ->
      windowMessage = rpg.system.scene.windowMessage
      pos = windowMessage.options.message.position
      pos.should.equal 1
      windowMessage.y.should.equal 0
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,2000)
    it '表示位置が中央に', ->
      windowMessage = rpg.system.scene.windowMessage
      pos = windowMessage.options.message.position
      pos.should.equal 2
      windowMessage.y.should.equal (480 / 2 - windowMessage.height / 2)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      setTimeout(done,2000)
    it '表示位置が一番下に', ->
      windowMessage = rpg.system.scene.windowMessage
      pos = windowMessage.options.message.position
      pos.should.equal 3
      windowMessage.y.should.equal (480 - windowMessage.height)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
  describe 'カラー確認', ->
    commands = [
      {
        type:'message',
        params:[
          'A\\C[1]A\\C[2]A\\C[3]A\\C[4]A\\C[5]A\\C[6]A\\C[7]A\\C[0]'
        ]
      }
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      setTimeout(done,2000)
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
