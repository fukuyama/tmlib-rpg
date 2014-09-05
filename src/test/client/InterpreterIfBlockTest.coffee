# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter', () ->
  interpreter = null
  describe '初期化', ->
    it '引数なし', ->
      interpreter = rpg.Interpreter()
      interpreter.should.be.a 'object'

  describe '条件分岐', ->
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
        it 'インタープリタ取得', ->
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
          message_clear()
          (rpg.system.temp.message is null).should.equal true
        it 'interpreter を実行する', ->
          interpreter.start commands
          interpreter.update()
        it 'message が "TEST1" になる', ->
          (rpg.system.temp.message isnt null).should.equal true
          rpg.system.temp.message.should.deep.equal ['TEST1']
        it 'クリア', ->
          message_clear()
          interpreter.update()
        it 'flag20 に 322 で、flag21 に 132', ->
          rpg.game.flag.set 'flag20', 322
          rpg.game.flag.set 'flag21', 132
          message_clear()
          (rpg.system.temp.message is null).should.equal true
        it 'interpreter を実行する', ->
          interpreter.start commands
          interpreter.update()
        it 'message が null のまま', ->
          (rpg.system.temp.message is null).should.equal true
        it 'クリア', ->
          message_clear()
          interpreter.update()
