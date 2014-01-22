# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter', () ->

  describe '初期化', ->
    it '引数なし', ->
      interpreter = rpg.Interpreter()
      interpreter.should.be.a 'object'

  describe '文章表示', ->
    interpreter = rpg.Interpreter()
    it 'message start', ->
      (rpg.system.temp.message is null).should.equal true
      interpreter.start [
        {type:'message',params:['TEST1']}
        {type:'message',params:['TEST2']}
      ]
    it 'message update', ->
      interpreter.update()
      rpg.system.temp.message.should.deep.equal [
        'TEST1','TEST2'
      ]
      message_clear()
      interpreter.update()

  describe 'フラグ操作', ->
    rpg.system.newGame()
    interpreter = rpg.Interpreter()
    it 'flag1 を off -> off', ->
      rpg.game.flag.is('flag1').should.equal off
      interpreter.start [
        {type:'flag',params:['flag1',off]}
      ]
      interpreter.update()
      rpg.game.flag.is('flag1').should.equal off
    it 'flag1 を off -> on', ->
      rpg.game.flag.is('flag1').should.equal off
      interpreter.start [
        {type:'flag',params:['flag1',on]}
      ]
      interpreter.update()
      rpg.game.flag.is('flag1').should.equal on
    it 'flag1 を on -> on', ->
      rpg.game.flag.is('flag1').should.equal on
      interpreter.start [
        {type:'flag',params:['flag1',on]}
      ]
      interpreter.update()
      rpg.game.flag.is('flag1').should.equal on
    it 'flag1 を on -> off', ->
      rpg.game.flag.is('flag1').should.equal on
      interpreter.start [
        {type:'flag',params:['flag1',off]}
      ]
      interpreter.update()
      rpg.game.flag.is('flag1').should.equal off
    it 'flag1 を off, flag2 を on', ->
      rpg.game.flag.is('flag1').should.equal off
      rpg.game.flag.is('flag2').should.equal off
      interpreter.start [
        {type:'flag',params:['flag2',on]}
      ]
      interpreter.update()
      rpg.game.flag.is('flag1').should.equal off
      rpg.game.flag.is('flag2').should.equal on
    it 'flag1 を on, flag2 は on のまま', ->
      rpg.game.flag.is('flag1').should.equal off
      rpg.game.flag.is('flag2').should.equal on
      interpreter.start [
        {type:'flag',params:['flag1',on]}
      ]
      interpreter.update()
      rpg.game.flag.is('flag1').should.equal on
      rpg.game.flag.is('flag2').should.equal on
    it 'flag1 の値を flag2 に設定', ->
      rpg.game.flag.clear()
      rpg.game.flag.is('flag1').should.equal off
      rpg.game.flag.is('flag2').should.equal off
      interpreter.start [
        {type:'flag',params:['flag1',on]}
        {type:'flag',params:['flag2','=','flag1']}
      ]
      interpreter.update()
      rpg.game.flag.is('flag1').should.equal on
      rpg.game.flag.is('flag2').should.equal on

  describe '文章表示とフラグの組み合わせ', ->
    rpg.system.newGame()
    interpreter = rpg.Interpreter()
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
    rpg.system.newGame()
    interpreter = rpg.Interpreter()
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

  describe '条件分岐', ->
    describe 'フラグNO/OFFによる分岐', ->
      describe 'フラグがNO場合に分岐する(else なし)', ->
        rpg.system.newGame()
        interpreter = rpg.Interpreter()
        commands = [
          {type:'if',params:['flag','flag1',on]}
          {type:'block',params:[
            {type:'message',params:['TEST1']}
          ]}
          {type:'end'}
        ]
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
        rpg.system.newGame()
        interpreter = rpg.Interpreter()
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
        interpreter = rpg.Interpreter()
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
        interpreter = rpg.Interpreter()
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
    describe 'ネストされた条件分岐', ->
      describe 'flag20 == 322 and flag21 == 232', ->
        interpreter = rpg.Interpreter()
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

  describe 'ループ制御', ->
    describe '基本ループ（フラグ利用）', ->
      describe 'flag30 が on の間ループする', ->
        interpreter = rpg.Interpreter()
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
        it 'flag30 を on にする', ->
          message_clear()
          rpg.game.flag.on 'flag30'
        it 'interpreter を開始する', ->
          interpreter.start commands
          (rpg.system.temp.message is null).should.equal true
        it 'interpreter を実行する', ->
          interpreter.update()
        it 'message が "TEST1" になる', ->
          (rpg.system.temp.message isnt null).should.equal true
          rpg.system.temp.message.should.deep.equal ['TEST1']
        it 'クリア', ->
          message_clear()
          (rpg.system.temp.message is null).should.equal true
        it 'interpreter を実行する', ->
          interpreter.update()
        it 'message が "TEST1" になる', ->
          (rpg.system.temp.message isnt null).should.equal true
          rpg.system.temp.message.should.deep.equal ['TEST1']
          message_clear()
        it 'flag30 を off にする', ->
          rpg.game.flag.off 'flag30'
        it 'interpreter を実行する', ->
          interpreter.update()
        it 'message が null になる', ->
          (rpg.system.temp.message is null).should.equal true
      describe 'ループ 3回', ->
        interpreter = rpg.Interpreter()
        commands = [
          {type:'flag',params:['flag30','=',0]}
          {type:'loop'}
          {type:'block',params:[
            {type:'flag',params:['flag30','+',1]}
            {type:'message',params:['TEST1']}
            {type:'if',params:['flag','flag30','>=',3]}
            {type:'block',params:[
              {type:'break'}
            ]}
            {type:'end'}
          ]}
          {type:'end'}
        ]
        it 'interpreter を実行する1', ->
          interpreter.start commands
          message_clear()
          (rpg.system.temp.message is null).should.equal true
          interpreter.update()
          (rpg.system.temp.message isnt null).should.equal true
          rpg.system.temp.message.should.deep.equal ['TEST1']
          rpg.game.flag.get('flag30').should.equal 1
        it 'interpreter を実行する2', ->
          message_clear()
          (rpg.system.temp.message is null).should.equal true
          interpreter.update()
          (rpg.system.temp.message isnt null).should.equal true
          rpg.system.temp.message.should.deep.equal ['TEST1']
          rpg.game.flag.get('flag30').should.equal 2
        it 'interpreter を実行する3', ->
          message_clear()
          (rpg.system.temp.message is null).should.equal true
          interpreter.update()
          (rpg.system.temp.message isnt null).should.equal true
          rpg.system.temp.message.should.deep.equal ['TEST1']
          rpg.game.flag.get('flag30').should.equal 3
        it 'interpreter を実行する4', ->
          message_clear()
          (rpg.system.temp.message is null).should.equal true
          interpreter.update()
          (rpg.system.temp.message is null).should.equal true


  describe 'ウェイト', ->
    describe '指定したフレーム数分処理を止める', ->
      interpreter = rpg.Interpreter()
      commands = [
        {type:'wait',params:[5]}
        {type:'message',params:['TEST1']}
        {type:'wait',params:[5]}
        {type:'message',params:['TEST2']}
      ]
      it 'interpreter を開始', ->
        message_clear()
        interpreter.start commands
      for i in [1 .. 5]
        it 'message は null', ->
          (rpg.system.temp.message is null).should.equal true
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

  describe '選択肢分岐', ->
    describe 'はい／いいえの分岐', ->
      interpreter = null
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
      interpreter = null
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
      interpreter = null
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
      interpreter = null
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
      rpg.system.newGame()
      interpreter = null
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
      it 'flag10はoff', ->
        rpg.game.flag.off 'flag10'
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20はoff', ->
        rpg.game.flag.off 'flag20'
        rpg.game.flag.is('flag20').should.equal off
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'キャンセルしてください', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '実行中', (done) ->
        emulate_key('escape',done)
      it 'flag10はoffになる', ->
        rpg.game.flag.is('flag10').should.equal off
      it 'flag20はonになる', ->
        rpg.game.flag.is('flag20').should.equal on
