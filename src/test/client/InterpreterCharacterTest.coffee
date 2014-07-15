# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Character)', () ->
  interpreter = null
  @timeout(10000)
  describe 'キャラクター関連のイベント', ->
    describe '場所移動', ->
      describe 'プレイヤーの場所を移動 20,20', ->
        commands = [
          {type:'move_to',params:['player',20,20]}
        ]
        it 'マップシーンへ移動', (done) ->
          loadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を開始する', (done)->
          interpreter.start commands
          setTimeout(done,200)
        it '移動確認', ->
          rpg.system.player.character.mapX.should.equal 20
          rpg.system.player.character.mapY.should.equal 20
      describe 'プレイヤーの場所を移動 2,1', ->
        commands = [
          {type:'move_to',params:['player',2,1]}
        ]
        it 'マップシーンへ移動', (done) ->
          loadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を開始する', (done)->
          interpreter.start commands
          setTimeout(done,200)
        it '移動確認', ->
          rpg.system.player.character.mapX.should.equal 2
          rpg.system.player.character.mapY.should.equal 1
      describe 'キャラクターの場所を移動 2,2', ->
        commands = [
          {type:'move_to',params:['Event001',1,1]}
        ]
        it 'マップシーンへ移動', (done) ->
          loadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を開始する', (done)->
          c = rpg.system.scene.map.events['Event001']
          c.mapX.should.equal 5
          c.mapY.should.equal 10
          interpreter.start commands
          setTimeout(done,200)
        it '移動確認', ->
          c = rpg.system.scene.map.events['Event001']
          c.mapX.should.equal 1
          c.mapY.should.equal 1
          c.moveTo(5,5)
    describe '移動ルート設定', ->
      describe 'プレイヤーの場所を移動 20,20', ->
        commands = [
          {type:'move_to',params:['player',0,0]}
          {type:'move_route',params:[
            'player'
            [
              {name: 'moveDown', params: [2]}
              {name: 'moveRight', params: [2]}
              {name: 'moveUp'}
              {name: 'moveUp'}
              {name: 'moveLeft'}
              {name: 'moveLeft'}
            ]
          ]}
        ]
        it 'マップシーンへ移動', (done) ->
          loadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を開始する', (done)->
          interpreter.start commands
          setTimeout(done,200)
    describe.skip 'マップを移動する', ->
      commands = [
        {type:'move_map',params:[2,5,5]}
      ]
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'interpreter を開始する', (done)->
        interpreter.start commands
        setTimeout(done,200)
      it '移動確認', ->
        rpg.system.scene.map.id.should.equal 2
        rpg.system.player.character.mapX.should.equal 20
        rpg.system.player.character.mapY.should.equal 20
