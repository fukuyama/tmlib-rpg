# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter', () ->
  interpreter = null
  describe '初期化', ->
    it '引数なし', ->
      interpreter = rpg.Interpreter()
      interpreter.should.be.a 'object'

  describe 'ウェイト', ->
    describe '指定したフレーム数分処理を止める', ->
      commands = [
        {type:'wait',params:[5]}
        {type:'message',params:['TEST1']}
        {type:'wait',params:[5]}
        {type:'message',params:['TEST2']}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
        rpg.system.scene.interpreterUpdate = off
      it 'interpreter を開始', ->
        message_clear()
      it 'message は null', ->
        (rpg.system.temp.message is null).should.equal true
        interpreter.start commands
      for i in [1 .. 5]
        it 'interpreter を更新 '+i+'フレーム', ->
          interpreter.isRunning().should.equal true
          interpreter.update()
      it 'message が "TEST1" になる', ->
        (rpg.system.temp.message isnt null).should.equal true
        rpg.system.temp.message.should.deep.equal ['TEST1']
        message_clear()
      for i in [1 .. 5]
        it 'message は null', ->
          (rpg.system.temp.message is null).should.equal true
        it 'interpreter を更新 '+i+'フレーム', ->
          interpreter.isRunning().should.equal true
          interpreter.update()
      it 'message が "TEST2" になる', ->
        (rpg.system.temp.message isnt null).should.equal true
        rpg.system.temp.message.should.deep.equal ['TEST2']
        message_clear()
      it 'クリア', ->
        interpreter.update()
        interpreter.isRunning().should.equal false
        rpg.system.scene.interpreterUpdate = on
  describe 'イベント操作', ->
    describe 'イベント削除', ->
      commands = [
        {type:'delete',params:['Event001']}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'イベント実行', (done) ->
        interpreter.start commands
        checkWait done, -> interpreter.isEnd()
      it '削除確認', ->
        c = rpg.system.scene.map.events['Event001']
        (c?).should.equal false




