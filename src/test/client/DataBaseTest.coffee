
describe 'rpg.DataBase', ->
  @timeout(10000)
  db = null
  beforeEach ->
    db = rpg.system.db

  describe '初期化', ->
    it '引数なし', ->
      db = rpg.DataBase()
      db.baseUrl.should.equal 'http://localhost:3000/client/'
      db.dataPath.should.equal 'data/'
      db.itemPath.should.equal 'item/'
      db.idformat.should.equal '000'

  describe 'アイテムデータ', ->
    describe 'itemUrl', ->
      it '文字列を渡すと、ファイル名として url を返す', ->
        db.itemUrl('abc').should.
          equal 'http://localhost:3000/client/data/item/abc.json'
      it '数値を渡すと、フォーマットしたファイル名として url を返す', ->
        db.itemUrl(1).should.
          equal 'http://localhost:3000/client/data/item/001.json'

    describe 'アイテムのロード', ->
      it 'アイテムを取得する場合は、取得した後に呼ぶ関数を指定する', (done) ->
        db.item([2,1],(items) ->
          # ID は、item プロパティに、url が入る
          items[0].item.should.
            equal 'http://localhost:3000/client/data/item/002.json'
          items[1].item.should.
            equal 'http://localhost:3000/client/data/item/001.json'
          done()
        )
      it '通常アイテム', (done) ->
        db.item([3],(items) ->
          item = items[0]
          item.item.should.
            equal 'http://localhost:3000/client/data/item/003.json'
          item.type.should.equal 'Item'
          done()
        )

  describe 'マップデータ', ->
    describe 'mapUrl', ->
      it '文字列を渡すと、ファイル名として url を返す', ->
        db.mapUrl('abc').should.
          equal 'http://localhost:3000/client/data/map/abc.json'
      it '数値を渡すと、フォーマットしたファイル名として url を返す', ->
        db.mapUrl(1).should.
          equal 'http://localhost:3000/client/data/map/001.json'

    describe 'マップのロード', ->
      it 'マップを取得する場合は、取得した後に呼ぶ関数を指定する', (done) ->
        db.map(1,(map) ->
          # ID は、map プロパティに、url が入る
          map.map.should.
            equal 'http://localhost:3000/client/data/map/001.json'
          map.mapSheet.name.should.
            equal '001'
          done()
        )
