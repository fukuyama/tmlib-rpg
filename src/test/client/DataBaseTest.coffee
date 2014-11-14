
describe 'rpg.DataBase', ->
  @timeout(10000)
  db = null
  beforeEach ->
    db = rpg.system.db

  describe '初期化', ->
    it '引数なし', ->
      dbd = rpg.DataBase()
      dbd.baseUrl.should.equal 'http://localhost:3000/client/'
      dbd.idformat.should.equal '000'

  describe 'アイテムデータ', ->
    describe 'アイテムのロード', ->
      it 'アイテムを取得する場合は、取得した後に呼ぶ関数を指定する', (done) ->
        db.preloadItem([2,1],(items) ->
          # ID は、item プロパティとして、url に使用する
          items[0].url.should.
            equal 'http://localhost:3000/client/data/item/002.json'
          items[1].url.should.
            equal 'http://localhost:3000/client/data/item/001.json'
          done()
        )
      it '通常アイテムをロード', (done) ->
        db.preloadItem([3],(items) ->
          item = items[0]
          item.url.should.
            equal 'http://localhost:3000/client/data/item/003.json'
          item.type.should.equal 'Item'
          done()
        )
      it '回復アイテムをロード', (done) ->
        db.preloadItem([4],(items) ->
          item = items[0]
          item.url.should.
            equal 'http://localhost:3000/client/data/item/004.json'
          item.type.should.equal 'UsableItem'
          done()
        )
      it '文字列指定でロード', (done) ->
        db.preloadItem(['test'],(items) ->
          item = items[0]
          item.url.should.
            equal 'http://localhost:3000/client/data/item/test.json'
          item.name.should.equal 'Test Item'
          done()
        )
        
  describe '武器データ', ->
    describe '武器のロード', ->
      it '武器を取得する場合は、取得した後に呼ぶ関数を指定する', (done) ->
        db.preloadWeapon([2,1],(items) ->
          # ID は、item プロパティとして、url に使用する
          items[0].url.should.
            equal 'http://localhost:3000/client/data/weapon/002.json'
          items[1].url.should.
            equal 'http://localhost:3000/client/data/weapon/001.json'
          done()
        )
      it '文字列指定でロード', (done) ->
        db.preloadWeapon(['001'],(items) ->
          item = items[0]
          item.url.should.
            equal 'http://localhost:3000/client/data/weapon/001.json'
          item.name.should.equal '片手剣'
          done()
        )

  describe '防具データ', ->
    describe '防具のロード', ->
      it '防具を取得する場合は、取得した後に呼ぶ関数を指定する', (done) ->
        db.preloadArmor([2,1],(items) ->
          # ID は、item プロパティとして、url に使用する
          items[0].url.should.
            equal 'http://localhost:3000/client/data/armor/002.json'
          items[1].url.should.
            equal 'http://localhost:3000/client/data/armor/001.json'
          done()
        )
      it '文字列指定でロード', (done) ->
        db.preloadArmor(['001'],(items) ->
          item = items[0]
          item.url.should.
            equal 'http://localhost:3000/client/data/armor/001.json'
          item.name.should.equal '兜'
          done()
        )

  describe 'callback　TEST', ->
    describe 'callback なし', ->
      it 'アイテム３種', ->
        db.preloadItem([2,1])
        db.preloadWeapon([2,1])
        db.preloadArmor([2,1])
      it 'wait', (done) ->
        setTimeout(done,1000)
    describe 'callback 複数あり', ->
      it 'アイテム３種順番に読まれる？', (done) ->
        count = 0
        db.preloadItem([2,1],(items) ->
          count.should.equal 0
          count += 1
        )
        db.preloadWeapon([2,1],(items) ->
          count.should.equal 1
          count += 1
        )
        db.preloadArmor([1],(items) ->
          count.should.equal 2
          count += 1
          done()
        )
    describe 'callback 空回しあり？', -> # TODO:むりぽ
      it 'アイテム３種順番に', (done) ->
        count = 0
        db.preloadItem([2,1],(items) ->
          count.should.equal 0
          count += 1
        )
        db.preloadWeapon([2,1],(items) ->
          count.should.equal 1
          count += 1
        )
        db.preloadArmor([1],(items) ->
          count.should.equal 2
          count += 1
        )
        db.preloadItem [], (items) ->
          count.should.equal 3
          count += 1
          done()
    describe 'callback 疑似 join', ->
      it 'アイテム３種を使ってロードされる', (done) ->
        count = 0
        loadcheck = (items) ->
          count += 1
          if count == 3
            done()
        db.preloadItem([2,1],loadcheck)
        db.preloadWeapon([2,1],loadcheck)
        db.preloadArmor([1],loadcheck)
      it 'アイテム３種を使ってロードされる２回目', (done) ->
        count = 0
        loadcheck = (items) ->
          count += 1
          if count == 3
            done()
        db.preloadItem([2,1],loadcheck)
        db.preloadWeapon([2,1],loadcheck)
        db.preloadArmor([1],loadcheck)

  describe 'マップデータ', ->
    describe 'mapUrl', ->
      it '文字列を渡すと、ファイル名として url を返す', ->
        db.mapUrl('abc').should.
          equal 'http://localhost:3000/client/data/map/abc.json'
      it '数値を渡すと、フォーマットしたファイル名として url を返す', ->
        db.mapUrl(1).should.
          equal 'http://localhost:3000/client/data/map/001.json'

    describe.skip 'マップのロード', ->
      it 'マップを取得する場合は、取得した後に呼ぶ関数を指定する', (done) ->
        db.preloadMap(1,(map) ->
          # ID は、map プロパティに、url が入る
          map.url.should.
            equal 'http://localhost:3000/client/data/map/001.json'
          map.mapSheet.name.should.
            equal '001'
          done()
        )
      it 'ウェイト', (done) ->
        tm.asset.Manager.assets = {}
        setTimeout(done,1000)

  describe 'ステートデータ', ->
    describe '基本ステート', ->
      # 基本ステートはあらかじめ読むしかない…感じ？
      it '読み込み', (done) ->
        db.preloadStates([1,2,3], (states) ->
          states[0].url.should.
            equal 'http://localhost:3000/client/data/state/001.json'
          states[0].name.should.
            equal 'State01'
          states[1].url.should.
            equal 'http://localhost:3000/client/data/state/002.json'
          states[1].name.should.
            equal 'State02'
          states[2].url.should.
            equal 'http://localhost:3000/client/data/state/003.json'
          states[2].name.should.
            equal 'State03'
          done()
        )
      it '番号で取得、読み込まれてるから同期実行', ->
        state = null
        state = db.state 1
        state.url.should.
          equal 'http://localhost:3000/client/data/state/001.json'
        state.name.should.
          equal 'State01'
      it '名前で取得、読み込まれてるから同期実行', ->
        state = null
        state = db.state 'State02'
        state.url.should.
          equal 'http://localhost:3000/client/data/state/002.json'
        state.name.should.
          equal 'State02'
      it '名前で取得、戻り値を使う', ->
        state = db.state 'State03'
        state.url.should.
          equal 'http://localhost:3000/client/data/state/003.json'
        state.name.should.
          equal 'State03'
    describe 'スクリプトで作成', ->
      it 'ステートの登録', ->
        db.registState {
          name: 'StateAA'
          url: 'http://localhost:3000/client/data/state/StateAA.json'
        }
      it '登録したステートの取得', ->
        state = db.state 'StateAA'
        state.url.should.
          equal 'http://localhost:3000/client/data/state/StateAA.json'
        state.name.should.
          equal 'StateAA'
