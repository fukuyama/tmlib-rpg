# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Message)', () ->
  interpreter = null
  @timeout(10000)
  describe '文章表示', ->
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'インタープリタ取得', ->
      rpg.system.scene.name.should.equal 'SceneMap'
      interpreter = rpg.system.scene.interpreter
    it '文章表示開始', ->
      interpreter.start [
        {type:'message',params:['TEST1']}
        {type:'message',params:['TEST2']}
      ]
    it '表示待ち', (done)->
      setTimeout(done,500)
    it '1回目 "TEST1" になる', ->
      m = rpg.system.scene.windowMessage.currentMessage
      m.should.equal 'TEST1'
    it 'ENTER', (done) ->
      emulate_key('enter',done)
    it '表示待ち', (done)->
      setTimeout(done,500)
    it '2回目 "TEST2" になる', ->
      m = rpg.system.scene.windowMessage.currentMessage
      m.should.equal 'TEST2'
    it 'ENTER', (done) ->
      emulate_key('enter',done)
  describe 'ループとメッセージ', ->
    commands = [
      {type:'option',params:[{
        message:
          close: off
      }]}
      {type:'flag',params:['system:i',0]}
      {type:'message',params:['START']}
      {type:'loop'}
      {type:'block',params:[
        {type:'flag',params:['system:i','+',1]}
        {type:'message',params:['TEST \\F[system:i]']}
        {type:'if',params:['flag','system:i','>=',5]}
        {type:'block',params:[
          {type:'break'}
        ]}
        {type:'end'}
      ]}
      {type:'end'}
      {type:'message',params:['END']}
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
    it 'メッセージ表示待ち START', (done) -> checkMessage callback:done, msg:'START'
    it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
    it 'メッセージ表示待ち TEST1', (done) -> checkMessage callback:done, msg:'TEST 1'
    it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
    it 'メッセージ表示待ち TEST2', (done) -> checkMessage callback:done, msg:'TEST 2'
    it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
    it 'メッセージ表示待ち TEST3', (done) -> checkMessage callback:done, msg:'TEST 3'
    it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
    it 'メッセージ表示待ち TEST4', (done) -> checkMessage callback:done, msg:'TEST 4'
    it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
    it 'メッセージ表示待ち TEST5', (done) -> checkMessage callback:done, msg:'TEST 5'
    it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
    it 'メッセージ表示待ち END', (done) -> checkMessage callback:done, msg:'END'
    it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
