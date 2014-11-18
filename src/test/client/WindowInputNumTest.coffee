
describe 'rpg.WindowInputNum', () ->

  describe '数値入力処理', ->
    describe '通常入力テスト', ->
      interpreter = null
      commands = [
        {type:'input_num',params:['val01',{min:0,max:99}]}
      ]
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '実行中', (done) ->
        emulate_key('enter',done)
      it 'val01が 0 になる', ->
        rpg.game.flag.get('val01').should.equal 0
      it 'コマンド実行', ->
        interpreter.start commands
      it '上', (done) -> emulate_key('up',done)
      it '上', (done) -> emulate_key('up',done)
      it '決定', (done) -> emulate_key('enter',done)
      it 'val01が 2 になる', ->
        rpg.game.flag.get('val01').should.equal 2
      it 'コマンド実行', ->
        interpreter.start commands
      it '左', (done) -> emulate_key('left',done)
      it '下', (done) -> emulate_key('down',done)
      it '決定', (done) -> emulate_key('enter',done)
      it 'val01が 90 になる', ->
        rpg.game.flag.get('val01').should.equal 90
    describe '通常入力テスト、titleつき', ->
      interpreter = null
      commands = [
        {type:'input_num',params:['val01',{min:0,max:99,title:'TEST'}]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '実行中', (done) ->
        emulate_key('enter',done)
      it 'val01が 0 になる', ->
        rpg.game.flag.get('val01').should.equal 0
      it 'コマンド実行', ->
        interpreter.start commands
      it '上', (done) -> emulate_key('up',done)
      it '上', (done) -> emulate_key('up',done)
      it '決定', (done) -> emulate_key('enter',done)
      it 'val01が 2 になる', ->
        rpg.game.flag.get('val01').should.equal 2
      it 'コマンド実行', ->
        interpreter.start commands
      it '左', (done) -> emulate_key('left',done)
      it '下', (done) -> emulate_key('down',done)
      it '決定', (done) -> emulate_key('enter',done)
      it 'val01が 90 になる', ->
        rpg.game.flag.get('val01').should.equal 90
    describe '初期値が最初に設定される', ->
      interpreter = null
      commands = [
        {type:'input_num',params:['val01',
          {
            min:0,max:99,value:32
          }
        ]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '決定', (done) -> emulate_key('enter',done)
      it 'val01が初期値 32 になる', ->
        rpg.game.flag.get('val01').should.equal 32
    describe 'キャンセルした場合キャンセル値になる', ->
      interpreter = null
      commands = [
        {type:'input_num',params:['val01',
          {
            min:0,max:99
            value:0,cancel:-1,step:1
          }
        ]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it 'キャンセル', (done) ->
        emulate_key('escape',done)
      it 'val01がキャンセル値 -1 になる', ->
        rpg.game.flag.get('val01').should.equal -1

      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '上', (done) -> emulate_key('up',done)
      it 'キャンセル', (done) -> emulate_key('escape',done)
      it 'val01がキャンセル値 -1 になる', ->
        rpg.game.flag.get('val01').should.equal -1

    describe 'キャンセルできなくする。', ->
      interpreter = null
      commands = [
        {type:'input_num',params:['val01',
          {
            min:0,max:99,value:0,cancel:false
          }
        ]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '上で1を入力', (done) -> emulate_key('up',done)
      it 'キャンセルされない', (done) -> emulate_key('escape',done)
      it '上で2を入力', (done) -> emulate_key('up',done)
      it '決定', (done) -> emulate_key('enter',done)
      it 'val01が入力した 2 になる', ->
        rpg.game.flag.get('val01').should.equal 2

    describe '一番左で左を押すと最大値になる', ->
      interpreter = null
      commands = [
        {type:'input_num',params:['val01',
          {
            min:0,max:55,value:0
          }
        ]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '左', (done) -> emulate_key('left',done)
      it 'さらに左', (done) -> emulate_key('left',done)
      it '決定', (done) -> emulate_key('enter',done)
      it 'val01が最大の 55 になる', ->
        rpg.game.flag.get('val01').should.equal 55

    describe '一番右で右を押すと最小値になる', ->
      interpreter = null
      commands = [
        {type:'input_num',params:['val01',
          {
            min:21,max:55,value:30
          }
        ]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '上で値を変更', (done) -> emulate_key('up',done)
      it '上で値を変更', (done) -> emulate_key('up',done)
      it '右で最少値にする', (done) -> emulate_key('right',done)
      it '決定', (done) -> emulate_key('enter',done)
      it 'val01が最少の 21 になる', ->
        rpg.game.flag.get('val01').should.equal 21

    describe 'ステップを指定するとステップ刻みでの入力になる', ->
      interpreter = null
      commands = [
        {type:'input_num',params:['val01',
          {
            min:0,max:99
            value:0,cancel:-1,step:5
          }
        ]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '上で値を変更', (done) -> emulate_key('up',done)
      it '決定', (done) -> emulate_key('enter',done)
      it 'val01が 5 になる', ->
        rpg.game.flag.get('val01').should.equal 5
    describe 'ステップが１０の場合は、１の位は変更できない（初期位置が１０の桁）', ->
      interpreter = null
      commands = [
        {type:'input_num',params:['val01',
          {
            min:0,max:99
            value:0,cancel:-1,step:10
          }
        ]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it '右に移動しない', (done) -> emulate_key('right',done)
      it '上で値を変更で１０になる', (done) -> emulate_key('up',done)
      it '決定', (done) -> emulate_key('enter',done)
      it 'val01が 10 になる', ->
        rpg.game.flag.get('val01').should.equal 10
  describe '文章＋数値入力処理', ->
    @timeout(10000)
    describe '通常', ->
      interpreter = null
      commands = [
        {type:'message',params:['数値を入力してください。']}
        {type:'input_num',params:['val01',{min:0,max:99999}]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it 'メッセージ表示待ち2', (done) ->
        setTimeout(done,2000)
      it '表示位置は下でメッセージの上に数値入力', ->
        windowMessage = rpg.system.scene.windowMessage
        windowInputNum = windowMessage.windowInputNum
        windowMessage.y.should.equal (480 - windowMessage.height)
        windowInputNum.y.should.equal (windowMessage.y - windowInputNum.height)
      it '実行中', (done) ->
        emulate_key('enter',done)
      it 'val01が 0 になる', ->
        rpg.game.flag.get('val01').should.equal 0
    describe '上に配置', ->
      interpreter = null
      commands = [
        {type:'option',params:[{message: position: 1}]}
        {type:'message',params:['数値を入力してください。']}
        {type:'input_num',params:['val01',{min:0,max:99999}]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it 'メッセージ表示待ち2', (done) ->
        setTimeout(done,2000)
      it '表示位置は下でメッセージの上に数値入力', ->
        windowMessage = rpg.system.scene.windowMessage
        windowInputNum = windowMessage.windowInputNum
        windowMessage.y.should.equal 0
        windowInputNum.y.should.equal windowMessage.height
      it '実行中', (done) ->
        emulate_key('enter',done)
      it 'val01が 0 になる', ->
        rpg.game.flag.get('val01').should.equal 0
    describe '中央に配置', ->
      interpreter = null
      commands = [
        {type:'option',params:[{message: position: 2}]}
        {type:'message',params:['数値を入力してください。']}
        {type:'input_num',params:['val01',{min:0,max:99999}]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it '初期化', ->
        rpg.game.flag.set('val01',10)
        rpg.game.flag.get('val01').should.equal 10
      it 'コマンド実行', ->
        interpreter = rpg.system.scene.interpreter
        interpreter.start commands
      it 'メッセージ表示待ち2', (done) ->
        setTimeout(done,2000)
      it '表示位置は下でメッセージの上に数値入力', ->
        windowMessage = rpg.system.scene.windowMessage
        windowInputNum = windowMessage.windowInputNum
        windowMessage.y.should.equal (480 / 2 - windowMessage.height / 2)
        windowInputNum.y.should.equal windowMessage.y - windowInputNum.height
      it '実行中', (done) ->
        emulate_key('enter',done)
      it 'val01が 0 になる', ->
        rpg.game.flag.get('val01').should.equal 0
