# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Character)', () ->
  interpreter = null
  @timeout(10000)
  describe 'キャラクター関連のイベント', ->
    describe '状態変更', ->
      describe 'すり抜け', ->
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を開始する すり抜け on に', (done)->
          commands = [
            {type:'move_to',params:[0,0]}
            {type:'transparent',params:['player',on]}
            {type:'move_route',params:[
              'player'
              [
                {type: 'moveDown'}
                {type: 'moveRight'}
                {type: 'moveRight'}
              ]
            ]}
          ]
          interpreter.start commands
          checkWait done, -> interpreter.isEnd()
        it '移動完了待ち', (done) ->
          checkWait done, ->
            pc = rpg.system.player.character
            pc.mapX == 2 and pc.mapY == 1
        it '状態確認 transparent=true', ->
          pc = rpg.system.player.character
          pc.transparent.should.equal true
          pc.mapX.should.equal 2
          pc.mapY.should.equal 1
      describe 'プレイヤー非表示', ->
        it 'マップシーンへ移動', (done) ->
          loadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it '状態確認 visible=on', ->
          pc = rpg.system.player.character
          pc.visible.should.equal true
        it 'interpreter を開始する visible off に', (done)->
          commands = [
            {type:'visible',params:['player',off]}
            {type:'message',params:['TEST']}
          ]
          interpreter.start commands
          checkWait done, -> interpreter.isEnd()
        it '状態確認 visible=off', ->
          pc = rpg.system.player.character
          pc.visible.should.equal false
        it 'メッセージ表示待ち2', (done) ->
          setTimeout(done,2000)
        it 'Enter', (done) ->
          emulate_key('enter',done)
        it 'interpreter を開始する visible on に', (done)->
          commands = [
            {type:'visible',params:['player',on]}
          ]
          interpreter.start commands
          checkWait done, -> interpreter.isEnd()
        it '状態確認 visible=on', ->
          pc = rpg.system.player.character
          pc.visible.should.equal true
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
          checkWait done, -> interpreter.isEnd()
        it '移動確認', (done) ->
          checkWait done, ->
            pc = rpg.system.player.character
            pc.mapX == 20 and pc.mapY == 20
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
          checkWait done, -> interpreter.isEnd()
        it '移動確認', (done) ->
          checkWait done, ->
            pc = rpg.system.player.character
            pc.mapX == 2 and pc.mapY == 1
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
          c.moveTo 5, 10
          c.mapX.should.equal 5
          c.mapY.should.equal 10
          interpreter.start commands
          checkWait done, -> interpreter.isEnd()
        it '移動確認', ->
          c = rpg.system.scene.map.events['Event001']
          c.mapX.should.equal 1
          c.mapY.should.equal 1
          c.moveTo(5,5)
    describe '移動ルート設定', ->
      describe '移動ルート設定 0,0 から左回り', ->
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
        route = [
          [0,2]
          [2,2]
          [2,0]
          [0,0]
        ]
        routeIndex = 0
        _routeCheck = (done) ->
          c  = rpg.system.player.character
          if route[routeIndex]?
            [x,y] = route[routeIndex]
            if c.mapX == x and c.mapY == y
              routeIndex++
            if route.length == routeIndex
              done()
        routeCheck = null
        it 'マップシーンへ移動', (done) ->
          loadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を開始する', ->
          interpreter.start commands
        it 'enterframe 設定', (done) ->
          routeCheck = _routeCheck.bind(@,done)
          rpg.system.scene.on 'enterframe', routeCheck
        it 'enterframe 削除', ->
          rpg.system.scene.off 'enterframe', routeCheck
          routeIndex.should.equal 4
    describe 'マップ移動', ->
      describe 'マップを移動する基本形', ->
        commands = [
          {type:'move_map',params:[2,5,5,8]}
        ]
        it 'マップシーンへ移動', (done) ->
          loadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を開始する', (done)->
          interpreter.start commands
          checkWait done, -> interpreter.isEnd()
        it '移動確認', (done) ->
          checkMapMove '002',5,5,'up',done
      describe 'マップを２回移動する', ->
        commands = [
          {type:'move_map',params:[2,5,5,8]}
          {type:'wait',params:[30]}
          {type:'move_map',params:[2,15,15,6]}
        ]
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を開始する', ->
          interpreter.start commands
        it '移動確認', (done) ->
          checkMapMove '002',5,5,'up',done
        it '移動確認', (done) ->
          checkMapMove '002',15,15,'right',done
      describe 'マップを移動するメッセージ付', ->
        commands = [
          {type:'move_map',params:[1,0,0,2]}
          {type:'message',params:['マップ移動前']}
          {type:'move_map',params:[2,15,5,8]}
          {type:'message',params:['マップ移動後']}
          {type:'move_map',params:[1,0,0,2]}
        ]
        it 'マップシーンへ移動', (done) ->
          loadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を開始する', (done)->
          interpreter.start commands
          setTimeout(done,200)
        it 'メッセージ表示待ち1', (done) ->
          setTimeout(done,2000)
        it 'Enter', (done) ->
          emulate_key('enter',done)
        it 'メッセージ表示待ち2', (done) ->
          setTimeout(done,2000)
        it '移動確認', (done) ->
          checkMapMove '002',15,5,'up',done
        it 'Enter', (done) ->
          emulate_key('enter',done)
        it '待ち', (done) ->
          setTimeout(done,1000)
        it '移動確認', (done) ->
          checkMapMove '001',0,0,'down',done
      describe 'マップを移動するトランジションあり', ->
        commands = [
          {type:'move_map',params:[1,0,0,2]}
          {type:'setup_transition'}
          {type:'move_map',params:[2,5,5,8]}
          {type:'start_transition'}
        ]
        it 'マップシーンへ移動', (done) ->
          loadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を開始する', (done)->
          interpreter.start commands
          checkWait done, -> interpreter.isEnd()
        it '移動確認', (done) ->
          checkMapMove '002',5,5,'up',done
          map = rpg.system.scene.map
          pc = rpg.system.player.character
          map.url.should.equal 'http://localhost:3000/client/data/map/002.json'
          pc.mapX.should.equal 5
          pc.mapY.should.equal 5
          pc.direction.should.equal 'up'
      describe 'マップを移動するトランジションあり、遅め', ->
        commands = [
          {type:'setup_transition',params:[{frame:90}]}
          {type:'move_map',params:[2,5,5,8]}
          {type:'start_transition'}
        ]
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'interpreter を開始する', (done)->
          interpreter.start commands
          checkWait done, -> interpreter.isEnd()
        it '移動確認', (done) ->
          checkMapMove '002',5,5,'up',done
          map = rpg.system.scene.map
          pc = rpg.system.player.character
          map.url.should.equal 'http://localhost:3000/client/data/map/002.json'
          pc.mapX.should.equal 5
          pc.mapY.should.equal 5
          pc.direction.should.equal 'up'
        it '戻し', (done) ->
          reloadTestMap(done)
