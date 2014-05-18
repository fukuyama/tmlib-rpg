
describe 'rpg.DataBase', ->
  @timeout(10000)
  db = null
  beforeEach ->
    db = rpg.system.db

  describe '初期化', ->
    it '引数なし', ->
      db = rpg.DataBase()
      db.baseUrl.should.equal 'http://localhost:3000/client/'
      db.idformat.should.equal '000'

  describe 'アイテムデータ', ->
    describe 'itemUrl', ->
      it '文字列を渡すと、ファイル名として url を返す', ->
        db.itemUrl('abc').should.
          equal 'http://localhost:3000/client/data/item/abc.json'
      it '数値を渡すと、フォーマットしたファイル名として url を返す', ->
        db.itemUrl(1).should.
          equal 'http://localhost:3000/client/data/item/001.json'

    describe.skip 'アイテムの一覧', ->
      it 'アイテムの一覧を取得する', (done) ->
        db.itemlist((items)->
          items[0].item.should.
            equal 'http://localhost:3000/client/data/item/001.json'
          done()
        )
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
      it '通常アイテムをロード', (done) ->
        db.item([3],(items) ->
          item = items[0]
          item.item.should.
            equal 'http://localhost:3000/client/data/item/003.json'
          item.type.should.equal 'Item'
          done()
        )
      it '回復アイテムをロード', (done) ->
        db.item([4],(items) ->
          item = items[0]
          item.item.should.
            equal 'http://localhost:3000/client/data/item/004.json'
          item.type.should.equal 'UsableItem'
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

  describe 'ステートデータ', ->
    describe '基本ステート', ->
      # 基本ステートはあらかじめ読むしかない…感じ？
      it '読み込み', (done) ->
        db.state([1,2,3], (states) ->
          states[0].state.should.
            equal 'http://localhost:3000/client/data/state/001.json'
          states[0].name.should.
            equal 'State01'
          states[1].state.should.
            equal 'http://localhost:3000/client/data/state/002.json'
          states[1].name.should.
            equal 'State02'
          states[2].state.should.
            equal 'http://localhost:3000/client/data/state/003.json'
          states[2].name.should.
            equal 'State03'
          done()
        )
      it '番号で取得、読み込まれてるから同期実行', ->
        state = null
        db.state(1,(states) -> state = states[0])
        state.state.should.
          equal 'http://localhost:3000/client/data/state/001.json'
        state.name.should.
          equal 'State01'
      it '名前で取得、読み込まれてるから同期実行', ->
        state = null
        db.state('State02',(states) -> state = states[0])
        state.state.should.
          equal 'http://localhost:3000/client/data/state/002.json'
        state.name.should.
          equal 'State02'
      it '名前で取得、戻り値を使う', ->
        state = db.state('State03')
        state.state.should.
          equal 'http://localhost:3000/client/data/state/003.json'
        state.name.should.
          equal 'State03'
