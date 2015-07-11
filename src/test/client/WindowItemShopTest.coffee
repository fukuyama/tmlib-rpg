
describe 'rpg.WindowItemShopTest', ->
  @timeout(10000)
  interpreter = null
  describe 'アイテムショップのテスト', ->
    describe '購入テスト', ->
      describe '購入アイテム一覧表示１', ->
        commands = [
          {type:'shop_item_menu',params:[{
            items: [1,2,3,4]
          }]}
        ]
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'wait', (done) ->
          setTimeout(done,1000)
        it 'コマンド実行', ->
          interpreter = rpg.system.scene.interpreter
          interpreter.start commands
        it 'wait', (done) ->
          setTimeout(done,1000)
        it '下に１回', (done) ->
          emulate_key('down',done)
        it 'アイテム１を選択', (done) ->
          emulate_key('enter',done)
        it 'ログが設定される', ->
          data = rpg.system.temp.log.item
          data.name.should.equal 'item 001'
          data.type.should.equal 'item'
          data.price.should.equal 10
          data.index.should.equal 0
          data.url.should.equal 'http://localhost:3000/client/sample/item/001.json'
      describe '購入アイテム一覧表示２', ->
        commands = [
          {type:'shop_item_menu',params:[{
            items: [1,2,3,4]
          }]}
        ]
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'wait', (done) ->
          setTimeout(done,1000)
        it 'コマンド実行', ->
          interpreter = rpg.system.scene.interpreter
          interpreter.start commands
        it 'wait', (done) ->
          setTimeout(done,1000)
        it '上に１回', (done) ->
          emulate_key('up',done)
        it 'アイテム４を選択（一覧の一番下を選択する）', (done) ->
          emulate_key('enter',done)
        it 'wait', (done) ->
          setTimeout(done,1000)
        it '数値入力で１に', (done) ->
          emulate_key('up',done)
        it '決定', (done) ->
          emulate_key('enter',done)
        it 'ログが設定される', ->
          data = rpg.system.temp.log.item
          data.name.should.equal 'cure I'
          data.type.should.equal 'item'
          data.price.should.equal 10
          data.index.should.equal 3
          data.url.should.equal 'http://localhost:3000/client/sample/item/004.json'
      describe '購入アイテム一覧表示３', ->
        commands = [
          {type:'shop_item_menu',params:[{
            items: [1]
            weapons: [1]
            armors: [1]
          }]}
        ]
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'wait', (done) ->
          setTimeout(done,1000)
        it 'コマンド実行', ->
          interpreter = rpg.system.scene.interpreter
          interpreter.start commands
        it 'wait', (done) ->
          setTimeout(done,1000)
        it '下に１回', (done) ->
          emulate_key('down',done)
        it '下に１回', (done) ->
          emulate_key('down',done)
        it '選択', (done) ->
          emulate_key('enter',done)
        it 'ログが設定される', ->
          data = rpg.system.temp.log.item
          data.name.should.equal '片手剣'
          data.type.should.equal 'weapon'
          data.price.should.equal 500
          data.index.should.equal 1
          data.url.should.equal 'http://localhost:3000/client/sample/weapon/001.json'
      describe '購入アイテム一覧表示４', ->
        commands = [
          {type:'shop_item_menu',params:[{
            items: [1]
            weapons: [1]
            armors: [1]
          }]}
        ]
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'wait', (done) ->
          setTimeout(done,1000)
        it 'コマンド実行', ->
          interpreter = rpg.system.scene.interpreter
          interpreter.start commands
        it 'wait', (done) ->
          setTimeout(done,1000)
        it '下に１回', (done) ->
          emulate_key('down',done)
        it '下に１回', (done) ->
          emulate_key('down',done)
        it '下に１回', (done) ->
          emulate_key('down',done)
        it '選択', (done) ->
          emulate_key('enter',done)
        it 'ログが設定される', ->
          data = rpg.system.temp.log.item
          data.name.should.equal '兜'
          data.type.should.equal 'armor'
          data.price.should.equal 250
          data.index.should.equal 2
          data.url.should.equal 'http://localhost:3000/client/sample/armor/001.json'
      describe '購入アイテム一覧表示５初期位置', ->
        commands = [
          {type:'shop_item_menu',params:[{
            index: 0
            items: [1]
            weapons: [1]
            armors: [1]
          }]}
        ]
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'wait', (done) ->
          setTimeout(done,1000)
        it 'コマンド実行', ->
          interpreter = rpg.system.scene.interpreter
          interpreter.start commands
        it 'wait', (done) ->
          setTimeout(done,1000)
        it '選択', (done) ->
          emulate_key('enter',done)
        it 'ログが設定される', ->
          data = rpg.system.temp.log.item
          data.name.should.equal 'item 001'
          data.type.should.equal 'item'
          data.price.should.equal 10
          data.index.should.equal 0
          data.url.should.equal 'http://localhost:3000/client/sample/item/001.json'
