# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Flag)', () ->
  interpreter = null
  describe '初期化', ->
    it '引数なし', ->
      interpreter = rpg.Interpreter()
      interpreter.should.be.a 'object'

  describe 'フラグ操作', ->
    @timeout(10000)
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'インタープリタ取得', ->
      interpreter = rpg.system.scene.interpreter
    it 'flag1 を off　にするコマンドを実行', (done) ->
      rpg.game.flag.is('flag1').should.equal off
      interpreter.start [
        {type:'flag',params:['flag1',off]}
        {type:'function',params:[done]}
      ]
    it 'flag1 が off になっている', ->
      rpg.game.flag.is('flag1').should.equal off
    it 'flag1 を on　にするコマンドを実行', (done) ->
      rpg.game.flag.is('flag1').should.equal off
      interpreter.start [
        {type:'flag',params:['flag1',on]}
        {type:'function',params:[done]}
      ]
    it 'flag1 が on になっている', ->
      rpg.game.flag.is('flag1').should.equal on
    it 'flag1 を on　にするコマンドを実行', (done) ->
      rpg.game.flag.is('flag1').should.equal on
      interpreter.start [
        {type:'flag',params:['flag1',on]}
        {type:'function',params:[done]}
      ]
    it 'flag1 が on になっている', ->
      rpg.game.flag.is('flag1').should.equal on
    it 'flag1 を off　にするコマンドを実行', (done) ->
      rpg.game.flag.is('flag1').should.equal on
      interpreter.start [
        {type:'flag',params:['flag1',off]}
        {type:'function',params:[done]}
      ]
    it 'flag1 が off になっている', ->
      rpg.game.flag.is('flag1').should.equal off
    it 'flag2 を on にするコマンドを実行', (done)->
      rpg.game.flag.is('flag1').should.equal off
      rpg.game.flag.is('flag2').should.equal off
      interpreter.start [
        {type:'flag',params:['flag2',on]}
        {type:'function',params:[done]}
      ]
    it 'flag1 が off, flag2 が on になっている', ->
      rpg.game.flag.is('flag1').should.equal off
      rpg.game.flag.is('flag2').should.equal on
    it 'flag1 を on にするコマンドを実行', (done)->
      rpg.game.flag.is('flag1').should.equal off
      rpg.game.flag.is('flag2').should.equal on
      interpreter.start [
        {type:'flag',params:['flag1',on]}
        {type:'function',params:[done]}
      ]
    it 'flag1 が on, flag2 が on になっている', ->
      rpg.game.flag.is('flag1').should.equal on
      rpg.game.flag.is('flag2').should.equal on
    it 'flag1 の値を flag2 に設定するコマンドを実行', (done)->
      rpg.game.flag.clear()
      rpg.game.flag.is('flag1').should.equal off
      rpg.game.flag.is('flag2').should.equal off
      interpreter.start [
        {type:'flag',params:['flag1',on]}
        {type:'flag',params:['flag2','=','flag1']}
        {type:'function',params:[done]}
      ]
    it 'flag1 が on, flag2 が on になっている', ->
      rpg.game.flag.is('flag1').should.equal on
      rpg.game.flag.is('flag2').should.equal on

  describe '文章表示とフラグの組み合わせ', ->
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'インタープリタ取得', ->
      rpg.system.scene.name.should.equal 'SceneMap'
      interpreter = rpg.system.scene.interpreter
    it 'message の間にフラグがある場合は、update が2回必要', ->
      message_clear()
      (rpg.system.temp.message is null).should.equal true
      interpreter.start [
        {type:'message',params:['TEST1']}
        {type:'flag',params:['flag1',off]}
        {type:'message',params:['TEST2']}
      ]
    it 'update 1回目 "TEST1" になる', ->
      message_clear()
      interpreter.update()
      (rpg.system.temp.message isnt null).should.equal true
      rpg.system.temp.message.should.deep.equal ['TEST1']
    it 'update 2回目 "TEST2" になる', ->
      message_clear()
      interpreter.update()
      (rpg.system.temp.message isnt null).should.equal true
      rpg.system.temp.message.should.deep.equal ['TEST2']
    it 'クリア', ->
      message_clear()
      interpreter.update()

  describe 'フラグ操作(数値)', ->
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'インタープリタ取得', ->
      interpreter = rpg.system.scene.interpreter
    it 'flag10 に 100 を設定', ->
      rpg.game.flag.clear()
      rpg.game.flag.get('flag10').should.equal 0
      interpreter.start [
        {type:'flag',params:['flag10','=',100]}
      ]
      interpreter.update()
      rpg.game.flag.get('flag10').should.equal 100
    it 'flag10 に 100 を加算', ->
      rpg.game.flag.get('flag10').should.equal 100
      interpreter.start [
        {type:'flag',params:['flag10','+',100]}
      ]
      interpreter.update()
      rpg.game.flag.get('flag10').should.equal 200
    it 'flag10 に 100 を減算', ->
      rpg.game.flag.get('flag10').should.equal 200
      interpreter.start [
        {type:'flag',params:['flag10','-',100]}
      ]
      interpreter.update()
      rpg.game.flag.get('flag10').should.equal 100
    it 'flag10 を2倍', ->
      rpg.game.flag.get('flag10').should.equal 100
      interpreter.start [
        {type:'flag',params:['flag10','*',2]}
      ]
      interpreter.update()
      rpg.game.flag.get('flag10').should.equal 200
    it 'flag10 を5で割る', ->
      rpg.game.flag.get('flag10').should.equal 200
      interpreter.start [
        {type:'flag',params:['flag10','/',5]}
      ]
      interpreter.update()
      rpg.game.flag.get('flag10').should.equal 40
    it 'flag10 に flag11 を足す', ->
      interpreter.start [
        {type:'flag',params:['flag10','=',10]}
        {type:'flag',params:['flag11','=',20]}
        {type:'flag',params:['flag10','+','flag11']}
      ]
      interpreter.update()
      rpg.game.flag.get('flag10').should.equal 30
      rpg.game.flag.get('flag11').should.equal 20
