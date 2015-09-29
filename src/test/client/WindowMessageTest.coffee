
describe 'rpg.WindowMessage', ->
  interpreter = null
  @timeout(10000)
  describe '文章表示（基本）', ->
    commands = [
      {type:'message',params:['TEST1']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      checkMessage(done,'TEST1')
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'おわり', (done) ->
      checkMessageClose(done)
  describe '文章表示１行ｘ３', ->
    commands = [
      {type:'message',params:['TEST1']}
      {type:'message',params:['TEST2','TEST3']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      checkMessage(done,'TEST1')
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち2', (done) ->
      checkMessage(done,'TEST2')
    it '次のメッセージ表示2', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち3', (done) ->
      checkMessage(done,'TEST3')
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示3', (done) ->
      emulate_key('enter',done)
    it 'おわり', (done) ->
      checkMessageClose(done)
  describe '文章表示クリア', ->
    commands = [
      {type:'message',params:['TEST2\\nTEST3']}
      {type:'message',params:['\\clearTEST1']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      checkMessage(done,'TEST2\\nTEST3')
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち2', (done) ->
      checkMessage(done,'TEST1')
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示2', (done) ->
      emulate_key('enter',done)
  describe '文章表示２行x２', ->
    commands = [
      {type:'message',params:['TEST1\\nTEST2']}
      {type:'message',params:['TEST3\\nほえほえ']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      checkMessage(done,'TEST1\\nTEST2')
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち2', (done) ->
      checkMessage(done,'TEST3\\nほえほえ')
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示2', (done) ->
      emulate_key('enter',done)
    it 'おわり', (done) ->
      checkMessage(done,'')
  describe '文章表示３行x２', ->
    commands = [
      {type:'message',params:['TEST1\\nTEST1\\nTEST1']}
      {type:'message',params:['TEST2\\nほえほえ\\nTEST2']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      checkMessage(done,'TEST1\\nTEST1\\nTEST1')
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち2', (done) ->
      checkMessage(done,'TEST2\\nほえほえ\\nTEST2')
    it '次のメッセージ表示2', (done) ->
      emulate_key('enter',done)
  describe '文章表示２行x４', ->
    commands = [
      {type:'message',params:['TEST1\\nTEST1']}
      {type:'message',params:['TEST2\\nほえほえ']}
      {type:'message',params:['ほえほえあああ\\nあああああああ']}
      {type:'message',params:['ふにふに\\nXXXX']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'ウェイト', (done) ->
      setTimeout(done,2000)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      checkMessage(done,'TEST1\\nTEST1')
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち2', (done) ->
      checkMessage(done,'TEST2\\nほえほえ')
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it '次のメッセージ表示2', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち3', (done) ->
      checkMessage done, 'ほえほえあああ\\nあああああああ'
    it 'ウェイト', (done) ->
      setTimeout(done,2000)
    it '次のメッセージ表示3', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち4', (done) ->
      checkMessage done, 'ふにふに\\nXXXX'
    it 'ウェイト', (done) ->
      setTimeout(done,2000)
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
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち1', (done) ->
      checkMessage done, '0123456789\\n0123456789\\n0123456789'
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち2', (done) ->
      checkMessage done, 'AAAAAAAAAA\\nBBBBBBBBBB\\nCCCCCCCCCC'
    it '次のメッセージ表示2', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち3', (done) ->
      checkMessage done, 'DDDDDDDDDD\\nEEEEEEEEEE\\nFFFFFFFFFF'
    it '次のメッセージ表示3', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち4', (done) ->
      checkMessage done, 'GGGGGGGGGG\\nHHHHHHHHHH\\nIIIIIIIIII'
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
      {type:'message',params:['TEST3']}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち', (done) ->
      checkMessage done, 'TEST1'
    it '表示位置が一番上に', ->
      windowMessage = rpg.system.scene.windowMessage
      pos = windowMessage.options.message.position
      pos.should.equal 1
      windowMessage.y.should.equal 0
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      checkMessage done, 'TEST2'
    it '表示位置が中央に', ->
      windowMessage = rpg.system.scene.windowMessage
      pos = windowMessage.options.message.position
      pos.should.equal 2
      windowMessage.y.should.equal (480 / 2 - windowMessage.height / 2)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
    it 'メッセージ表示待ち', (done) ->
      checkMessage done, 'TEST3'
    it '表示位置が一番下に', ->
      windowMessage = rpg.system.scene.windowMessage
      pos = windowMessage.options.message.position
      pos.should.equal 3
      windowMessage.y.should.equal (480 - windowMessage.height)
    it '次のメッセージ表示', (done) ->
      emulate_key('enter',done)
  describe '継続表示', ->
    commands = [
      {type:'option',params:[{
        message:
          close: off
      }]}
      {type:'message',params:['TEST1']}
      {type:'flag',params:['flag10',on]}
      {type:'message',params:['TEST2']}
      {type:'flag',params:['flag10',off]}
      {type:'message',params:['TEST3']}
      {type:'option',params:[{
        message:
          close: on
      }]}
    ]
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'ウェイト', (done) ->
      setTimeout(done,1000)
    it 'コマンド実行', ->
      interpreter = rpg.system.scene.interpreter
      interpreter.start commands
    it 'メッセージ表示待ち', (done) -> checkMessage callback:done, msg:'TEST1'
    it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
    it 'メッセージ表示待ち', (done) -> checkMessage callback:done, msg:'TEST2'
    it 'フラグ確認 flag10==true', -> rpg.game.flag.is('flag10').should.equal true
    it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
    it 'メッセージ表示待ち', (done) -> checkMessage callback:done, msg:'TEST3'
    it 'フラグ確認 flag10==false', -> rpg.game.flag.is('flag10').should.equal false
    it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
    it 'メッセージ表示待ち', (done) -> checkMessage callback:done, msg:''
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
      checkMessage done,'AAAAAAAA'
    it '次のメッセージ表示1', (done) ->
      emulate_key('enter',done)

  describe 'ポーズ処理', ->
    describe '自動ページ送り', ->
      commands = [
        {
          type:'message',
          params:[
            '自動でページが送られるよ。'
            'OK'
          ]
        }
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '自動送りモード10', ->
        rpg.system.scene.windowMessage.setAutoMode 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it 'メッセージ表示待ち1', (done) ->
        checkMessage done, 'OK'
      it '自動送りモードOFF', ->
        rpg.system.scene.windowMessage.setAutoMode off
      it '次のメッセージ表示1', (done) ->
        emulate_key('enter',done)

    describe 'ポーズスキップ待ちなし', ->
      commands = [
        {
          type:'message',
          params:[
            'ポーズがスキップされるよ。\\skip'
            'OK'
          ]
        }
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it 'メッセージ表示待ち1', (done) ->
        checkMessage done, 'OK'
      it '次のメッセージ表示1', (done) ->
        emulate_key('enter',done)

    describe 'ポーズスキップ１秒', ->
      commands = [
        {
          type:'message',
          params:[
            'ポーズがスキップされるよ。\\skip[30]'
            'OK'
          ]
        }
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it 'メッセージ表示待ち1', (done) ->
        checkMessage done, 'OK'
      it '次のメッセージ表示1', (done) ->
        emulate_key('enter',done)
