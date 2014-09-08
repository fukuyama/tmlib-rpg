# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(LoopBlock)', () ->
  interpreter = null
  @timeout(10000)
  describe 'ループ制御', ->
    describe '基本ループ（フラグ利用）', ->
      describe 'flag30 が on の間ループする', ->
        commands = [
          {type:'loop'}
          {type:'block',params:[
            {type:'message',params:['TEST1']}
            {type:'if',params:['flag','flag30',off]}
            {type:'block',params:[
              {type:'break'}
            ]}
            {type:'end'}
          ]}
          {type:'end'}
        ]
        it 'マップシーンへ移動', (done) ->
          message_clear()
          loadTestMap(done)
        it 'ウェイト', (done)->
          setTimeout(done,2000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'flag30 を on にする', ->
          rpg.game.flag.on 'flag30'
        it 'interpreter を開始する', (done)->
          interpreter.start commands
          setTimeout(done,200)
        it 'message が "TEST1" になる', ->
          getMessage().should.equal 'TEST1'
        it '次のメッセージ表示', (done) ->
          emulate_key('enter',done)
        it 'ループまち', (done)->
          checkMessage(done,'TEST1')
        it 'message が "TEST1" になる', ->
          getMessage().should.equal 'TEST1'
        it 'flag30 を off にする', (done)->
          rpg.game.flag.off 'flag30'
          setTimeout(done,200)
        it '次のメッセージ表示', (done) ->
          emulate_key('enter',done)
        it 'ループまち', (done)->
          checkMessage(done,'')
        it 'message が "" になる', ->
          getMessage().should.equal ''
      describe 'ループ 3回', ->
        commands = [
          {type:'flag',params:['flag30','=',0]}
          {type:'loop'}
          {type:'block',params:[
            {type:'flag',params:['flag30','+',1]}
            {type:'message',params:['TEST\\F[flag30]']}
            {type:'if',params:['flag','flag30','>=',3]}
            {type:'block',params:[
              {type:'break'}
            ]}
            {type:'end'}
          ]}
          {type:'end'}
        ]
        it 'マップシーンへ移動', (done) ->
          loadTestMap(done)
        it 'ウェイト', (done)->
          setTimeout(done,2000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を実行する1', ->
          interpreter.start commands
        it 'ループまち', (done)->
          checkMessage(done,'TEST1')
        it 'message が "TEST1" になる', ->
          getMessage().should.equal 'TEST1'
        it 'flag30は、1になる', ->
          rpg.game.flag.get('flag30').should.equal 1
        it '次のメッセージ表示', (done) ->
          emulate_key('enter',done)
        it 'ループまち', (done)->
          checkMessage(done,'TEST2')
        it 'message が "TEST2" になる', ->
          getMessage().should.equal 'TEST2'
        it 'flag30は、2になる', ->
          rpg.game.flag.get('flag30').should.equal 2
        it '次のメッセージ表示', (done) ->
          emulate_key('enter',done)
        it 'ループまち', (done)->
          checkMessage(done,'TEST3')
        it 'message が "TEST3" になる', ->
          getMessage().should.equal 'TEST3'
        it 'flag30は、3になる', ->
          rpg.game.flag.get('flag30').should.equal 3
        it '次のメッセージ表示', (done) ->
          emulate_key('enter',done)
        it 'ループまち', (done)->
          checkMessage(done,'')
        it 'message が "" になる', ->
          getMessage().should.equal ''

      describe 'システム変数ループ 3回', ->
        commands = [
          {type:'flag',params:['system:i','=',0]}
          {type:'loop'}
          {type:'block',params:[
            {type:'flag',params:['system:i','+',1]}
            {type:'message',params:['TEST\\F[system:i]']}
            {type:'if',params:['flag','system:i','>=',3]}
            {type:'block',params:[
              {type:'break'}
            ]}
            {type:'end'}
          ]}
          {type:'end'}
        ]
        it 'マップシーンへ移動', (done) ->
          loadTestMap(done)
        it 'ウェイト', (done)->
          setTimeout(done,2000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を実行する1', ->
          interpreter.start commands
        it 'ループまち', (done) ->
          checkMessage(done,'TEST1')
        it 'message が "TEST1" になる', ->
          getMessage().should.equal 'TEST1'
        it '次のメッセージ表示', (done) ->
          emulate_key('enter',done)
        it 'ループまち', (done) ->
          checkMessage(done,'TEST2')
        it 'message が "TEST2" になる', ->
          getMessage().should.equal 'TEST2'
        it '次のメッセージ表示', (done) ->
          emulate_key('enter',done)
        it 'ループまち', (done) ->
          checkMessage(done,'TEST3')
        it 'message が "TEST3" になる', ->
          getMessage().should.equal 'TEST3'
        it '次のメッセージ表示', (done) ->
          emulate_key('enter',done)
