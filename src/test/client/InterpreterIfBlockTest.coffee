# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(IfBlock)', () ->
  interpreter = null
  describe '初期化', ->
    it '引数なし', ->
      interpreter = rpg.Interpreter()
      interpreter.should.be.a 'object'

  describe 'フラグNO/OFFによる分岐', ->
    describe 'フラグがNO場合に分岐する(else なし)', ->
      commands = [
        {type:'if',params:['flag','flag1',on]}
        {type:'block',params:[
          {type:'message',params:['TEST1']}
        ]}
        {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'flag1をonにする', ->
        message_clear()
        (rpg.system.temp.message is null).should.equal true
        rpg.game.flag.on 'flag1'
      it 'interpreter を実行する', ->
        interpreter.start commands
        interpreter.update()
      it '分岐して "TEST1"になる', ->
        (rpg.system.temp.message is null).should.equal false
        rpg.system.temp.message.should.deep.equal ['TEST1']
      it 'クリア', ->
        message_clear()
        interpreter.update()
      it 'flag1をoffにする', ->
        message_clear()
        (rpg.system.temp.message is null).should.equal true
        rpg.game.flag.off 'flag1'
      it 'interpreter を実行する', ->
        interpreter.start commands
        interpreter.update()
      it '分岐しないので、message=null のまま', ->
        (rpg.system.temp.message is null).should.equal true
      it 'クリア', ->
        message_clear()
        interpreter.update()
    describe 'フラグがNO場合に分岐する(else あり)', ->
      commands = [
        {type:'if',params:['flag','flag1',on]}
        {type:'block',params:[
          {type:'message',params:['TEST1']}
        ]}
        {type:'else'}
        {type:'block',params:[
          {type:'message',params:['TEST2']}
        ]}
        {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'flag1をonにする', ->
        message_clear()
        (rpg.system.temp.message is null).should.equal true
        rpg.game.flag.on 'flag1'
      it 'interpreter を実行する', ->
        interpreter.start commands
        interpreter.update()
      it '分岐して "TEST1"になる', ->
        (rpg.system.temp.message is null).should.equal false
        rpg.system.temp.message.should.deep.equal ['TEST1']
      it 'クリア', ->
        message_clear()
        interpreter.update()
      it 'flag1をoffにする', ->
        message_clear()
        (rpg.system.temp.message is null).should.equal true
        rpg.game.flag.off 'flag1'
      it 'interpreter を実行する', ->
        interpreter.start commands
        interpreter.update()
      it 'else が実行されて "TEST2" になる', ->
        (rpg.system.temp.message is null).should.equal false
        rpg.system.temp.message.should.deep.equal ['TEST2']
      it 'クリア', ->
        message_clear()
        interpreter.update()
  describe 'フラグ値による分岐', ->
    describe 'flag20 が等しい(222)場合に分岐する', ->
      commands = [
          {type:'if',params:['flag','flag20','==',222]}
          {type:'block',params:[
            {type:'message',params:['TEST1']}
          ]}
          {type:'else'}
          {type:'block',params:[
            {type:'message',params:['TEST2']}
          ]}
          {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'flag20 を 222 にする', ->
        rpg.game.flag.set 'flag20', 222
      it 'interpreter を実行する', ->
        interpreter.start commands
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'message が "TEST1" になる', ->
        m = rpg.system.scene.windowMessage.currentMessage
        m.should.equal 'TEST1'
      it 'ENTER', (done) ->
        emulate_key('enter',done)
      it 'flag20 を 223 にする', ->
        rpg.game.flag.set 'flag20', 223
      it 'interpreter を実行する', ->
        interpreter.start commands
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'message が "TEST2" になる', ->
        m = rpg.system.scene.windowMessage.currentMessage
        m.should.equal 'TEST2'
      it 'ENTER', (done) ->
        emulate_key('enter',done)
    describe 'flag20 が等しくない(!223)場合に分岐する', ->
      commands = [
        {type:'if',params:['flag','flag20','!=',223]}
        {type:'block',params:[
          {type:'message',params:['TEST1']}
        ]}
        {type:'else'}
        {type:'block',params:[
          {type:'message',params:['TEST2']}
        ]}
        {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        rpg.system.scene.name.should.equal 'SceneMap'
        interpreter = rpg.system.scene.interpreter
      it 'flag20 を 222 にする', ->
        message_clear()
        rpg.game.flag.set 'flag20', 222
      it 'interpreter を実行する', ->
        interpreter.start commands
        interpreter.update()
      it 'message が "TEST1" になる', ->
        (rpg.system.temp.message isnt null).should.equal true
        rpg.system.temp.message.should.deep.equal ['TEST1']
      it 'クリア', ->
        message_clear()
        interpreter.update()
      it 'flag20 を 223 にする', ->
        message_clear()
        rpg.game.flag.set 'flag20', 223
      it 'interpreter を実行する', ->
        interpreter.start commands
        interpreter.update()
      it 'message が "TEST2" になる', ->
        (rpg.system.temp.message isnt null).should.equal true
        rpg.system.temp.message.should.deep.equal ['TEST2']
      it 'クリア', ->
        message_clear()
        interpreter.update()
    describe 'フラグ同士の比較による分岐', ->
      commands = [
        {type:'if',params:['flag','flag20','==','flag21']}
        {type:'block',params:[
          {type:'message',params:['TEST1']}
        ]}
        {type:'else'}
        {type:'block',params:[
          {type:'message',params:['TEST2']}
        ]}
        {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        rpg.system.scene.name.should.equal 'SceneMap'
        interpreter = rpg.system.scene.interpreter
      it 'flag20 / flag21 を 222 にする', ->
        message_clear()
        rpg.game.flag.set 'flag20', 222
        rpg.game.flag.set 'flag21', 222
      it 'interpreter を実行する', ->
        interpreter.start commands
        interpreter.update()
      it 'message が "TEST1" になる', ->
        (rpg.system.temp.message isnt null).should.equal true
        rpg.system.temp.message.should.deep.equal ['TEST1']
      it 'クリア', ->
        message_clear()
        interpreter.update()
      it 'flag20 を 223 にする', ->
        message_clear()
        rpg.game.flag.set 'flag20', 223
      it 'interpreter を実行する', ->
        interpreter.start commands
        interpreter.update()
      it 'message が "TEST2" になる', ->
        (rpg.system.temp.message isnt null).should.equal true
        rpg.system.temp.message.should.deep.equal ['TEST2']
      it 'クリア', ->
        message_clear()
        interpreter.update()
  describe 'ネストされた条件分岐', ->
    describe 'flag20 == 322 and flag21 == 232', ->
      commands = [
          {type:'if',params:['flag','flag20','==',322]}
          {type:'block',params:[
            {type:'if',params:['flag','flag21','==',232]}
            {type:'block',params:[
              {type:'message',params:['TEST1']}
            ]}
            {type:'end'}
          ]}
          {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'flag20 に 322 で、flag21 に 232', ->
        rpg.game.flag.set 'flag20', 322
        rpg.game.flag.set 'flag21', 232
      it 'interpreter を実行する', ->
        interpreter.start commands
      it 'message が "TEST1" になる', (done) ->
        checkMessage(done,'TEST1')
      it 'message が "TEST1" になる', ->
        getMessage().should.equal 'TEST1'
      it 'flag20 に 322 で、flag21 に 132', ->
        rpg.game.flag.set 'flag20', 322
        rpg.game.flag.set 'flag21', 132
      it 'enter', (done) ->
        emulate_key('enter',done)
      it 'interpreter を実行する', ->
        interpreter.start commands
      it 'message が "" になる', (done) ->
        checkMessage(done,'')
      it 'message が "" になる', ->
        getMessage().should.equal ''

  describe 'フラグやシステム値による分岐', ->
    describe 'flag30 == system.flag30', ->
      commands = [
          {type:'if',params:['flag','flag30','==','flag','system:flag30']}
          {type:'block',params:[
            {type:'message',params:['TEST1']}
          ]}
          {type:'else'}
          {type:'block',params:[
            {type:'message',params:['TEST2']}
          ]}
          {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'ウェイト', (done) ->
        setTimeout done, 1000
      it 'flag30 に 100 で、system.flag30 に 100', ->
        rpg.game.flag.set 'flag30', 100
        rpg.game.flag.system.set 'flag30', 100
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を実行する', ->
        interpreter.start commands
      it 'message が "TEST1" になる', (done) ->
        checkMessage(done,'TEST1')
      it 'message が "TEST1" になる', ->
        getMessage().should.equal 'TEST1'
      it 'enter', (done) ->
        emulate_key('enter',done)
      it 'flag30 に 100 で、system.flag30 に 200', ->
        rpg.game.flag.set 'flag30', 100
        rpg.game.flag.system.set 'flag30', 200
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を実行する', ->
        interpreter.start commands
      it 'message が "TEST2" になる', (done) ->
        checkMessage(done,'TEST2')
      it 'message が "TEST2" になる', ->
        getMessage().should.equal 'TEST2'
      it 'enter', (done) ->
        emulate_key('enter',done)

  describe 'フラグやログ値による分岐', ->
    describe 'flag30 == log.test.length', ->
      commands = [
          {type:'if',params:['flag','flag30','==','log','test.length']}
          {type:'block',params:[
            {type:'message',params:['TEST1']}
          ]}
          {type:'else'}
          {type:'block',params:[
            {type:'message',params:['TEST2']}
          ]}
          {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'ウェイト', (done) ->
        setTimeout done, 1000
      it 'flag30 に 4 で、rpg.system.temp.log に test=[1,2,3,4]', ->
        rpg.game.flag.set 'flag30', 4
        rpg.system.temp.log = {
          test: [1,2,3,4]
        }
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を実行する', ->
        interpreter.start commands
      it 'message が "TEST1" になる', (done) ->
        checkMessage(done,'TEST1')
      it 'message が "TEST1" になる', ->
        getMessage().should.equal 'TEST1'
      it 'enter', (done) ->
        emulate_key('enter',done)
      it 'flag30 に 5 で、rpg.system.temp.log に test=[1,2,3,4]', ->
        rpg.game.flag.set 'flag30', 5
        rpg.system.temp.log = {
          test: [1,2,3,4]
        }
      it 'interpreter を実行する', ->
        interpreter.start commands
      it 'message が "TEST2" になる', (done) ->
        checkMessage(done,'TEST2')
      it 'message が "TEST2" になる', ->
        getMessage().should.equal 'TEST2'
      it 'enter', (done) ->
        emulate_key('enter',done)
