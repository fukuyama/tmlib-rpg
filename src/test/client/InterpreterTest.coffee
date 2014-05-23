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

  describe '選択肢分岐', ->
    describe 'はい／いいえの分岐', ->
      commands = [
        {type:'select',params:[['はい','いいえ'],{index:0,cancel:0}]}
        {type:'block',params:[
          {type:'flag',params:['flag10',on]}
        ]}
        {type:'block',params:[
          {type:'flag',params:['flag20',on]}
        ]}
        {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'flag10はoff', ->
        rpg.game.flag.off 'flag10'
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20はoff', ->
        rpg.game.flag.off 'flag20'
        rpg.game.flag.is('flag20').should.equal off
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'interpreter を実行する（「はい」を選択してください）', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '実行中', (done) ->
        emulate_key('enter',done)
      it 'flag10がonになる', ->
        rpg.game.flag.is('flag10').should.equal on
      it 'flag20はoffになる', ->
        rpg.game.flag.is('flag20').should.equal off

      it 'flag10はoff', ->
        rpg.game.flag.off 'flag10'
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20はoff', ->
        rpg.game.flag.off 'flag20'
        rpg.game.flag.is('flag20').should.equal off
        message_clear()
      it 'interpreter を実行する（「いいえ」を選択してください）', ->
        interpreter.start commands
      it '実行中', (done) ->
        emulate_key('down',done)
      it '実行中', (done) ->
        emulate_key('enter',done)
      it 'flag10がoffになる', ->
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20はonになる', ->
        rpg.game.flag.is('flag20').should.equal on
    describe 'ABCの分岐（メッセージあり）', ->
      commands = [
        {type:'message',params:['選択してください。']}
        {type:'select',params:[['A','B','C'],{index:1,cancel:0}]}
        {type:'block',params:[
          {type:'flag',params:['flag10',on]}
        ]}
        {type:'block',params:[
          {type:'flag',params:['flag20',on]}
        ]}
        {type:'block',params:[
          {type:'flag',params:['flag30',on]}
        ]}
        {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'flag10をoff', ->
        rpg.game.flag.off 'flag10'
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20をoff', ->
        rpg.game.flag.off 'flag20'
        rpg.game.flag.is('flag20').should.equal off
      it 'flag30をoff', ->
        rpg.game.flag.off 'flag30'
        rpg.game.flag.is('flag30').should.equal off
      it 'マップロード', (done)->
        loadTestMap(done)
      it 'interpreter を実行する(Bを選択)', (done) ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
        setTimeout(done,1000) # メッセージ表示待ち
      it '実行中 B がデフォルトで選択されてる', (done) ->
        emulate_key('enter',done)
      it 'flag10は off になる', ->
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20は on になる', ->
        rpg.game.flag.is('flag20').should.equal on
      it 'flag30は off になる', ->
        rpg.game.flag.is('flag30').should.equal off
    describe 'デフォルトで選択肢を選択しない', ->
      commands = [
        {type:'select',params:[['はい','いいえ'],{index:-1,cancel:0}]}
        {type:'block',params:[
          {type:'flag',params:['flag10',on]}
        ]}
        {type:'block',params:[
          {type:'flag',params:['flag20',on]}
        ]}
        {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'flag10はoff', ->
        rpg.game.flag.off 'flag10'
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20はoff', ->
        rpg.game.flag.off 'flag20'
        rpg.game.flag.is('flag20').should.equal off
      it 'マップロード', (done) ->
        loadTestMap(done)
      it 'interpreter を実行する（「はい」を選択してください）', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '実行中', (done) ->
        emulate_key('down',done)
      it '実行中', (done) ->
        emulate_key('enter',done)
      it 'flag10がonになる', ->
        rpg.game.flag.is('flag10').should.equal on
      it 'flag20はoffになる', ->
        rpg.game.flag.is('flag20').should.equal off
    describe 'キャンセルした場合の選択肢を設定', ->
      commands = [
        {type:'select',params:[['はい','いいえ'],{index:0,cancel:2}]}
        {type:'block',params:[
          {type:'flag',params:['flag10',on]}
        ]}
        {type:'block',params:[
          {type:'flag',params:['flag20',on]}
        ]}
        {type:'block',params:[
          {type:'flag',params:['flag30',on]}
        ]}
        {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'flag10はoff', ->
        rpg.game.flag.off 'flag10'
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20はoff', ->
        rpg.game.flag.off 'flag20'
        rpg.game.flag.is('flag20').should.equal off
      it 'flag30はoff', ->
        rpg.game.flag.off 'flag30'
        rpg.game.flag.is('flag30').should.equal off
      it 'マップロード', (done)->
        loadTestMap(done)
      it 'キャンセルしてください', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '実行中', (done) ->
        emulate_key('escape',done)
      it 'flag10はoffになる', ->
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20はoffになる', ->
        rpg.game.flag.is('flag20').should.equal off
      it 'flag30はonになる', ->
        rpg.game.flag.is('flag30').should.equal on
    describe 'キャンセルした場合に「いいえ」になる', ->
      commands = [
        {type:'select',params:[['はい','いいえ'],{index:0,cancel:1}]}
        {type:'block',params:[
          {type:'flag',params:['flag10',on]}
        ]}
        {type:'block',params:[
          {type:'flag',params:['flag20',on]}
        ]}
        {type:'end'}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'flag10はoff', ->
        rpg.game.flag.off 'flag10'
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20はoff', ->
        rpg.game.flag.off 'flag20'
        rpg.game.flag.is('flag20').should.equal off
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'キャンセルしてください', ->
        interpreter.start commands
      it '実行中', (done) ->
        emulate_key('escape',done)
      it 'flag10はoffになる', ->
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20はonになる', ->
        rpg.game.flag.is('flag20').should.equal on
