
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
          data.price.should.equal 1
          data.index.should.equal 0
          data.id.should.equal 'http://localhost:3000/client/data/item/001.json'
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
        it 'ログが設定される', ->
          data = rpg.system.temp.log.item
          data.name.should.equal 'cure I'
          data.price.should.equal 10
          data.index.should.equal 3
          data.id.should.equal 'http://localhost:3000/client/data/item/004.json'
