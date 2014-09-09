
describe 'rpg.WindowItemTest', ->
  @timeout(10000)
  describe 'アイテムを捨てる', ->
    it 'マップシーンへ移動', (done) ->
      reloadTestMap(done)
    it 'wait', (done) ->
      setTimeout(done,1000)
    it '通常アイテムをロード', (done) ->
      db = rpg.system.db
      db.preloadItem([3],(items) ->
        actor = rpg.game.party.getAt(0)
        item = items[0]
        actor.backpack.addItem item
        item.url.should.
          equal 'http://localhost:3000/client/data/item/003.json'
        item.type.should.equal 'Item'
        done()
      )
    it 'メニュー表示', (done) ->
      emulate_key('enter',done)
    it 'どうぐ', (done) ->
      emulate_key('down',done)
    it '選択', (done) ->
      emulate_key('enter',done)
    it 'アクター選択', (done) ->
      emulate_key('enter',done)
    it 'カーソル移動下', (done) ->
      emulate_key('down',done)
    it 'アイテム選択', (done) ->
      emulate_key('enter',done)
    it 'カーソル移動下', (done) ->
      emulate_key('down',done)
    it 'カーソル移動下', (done) ->
      emulate_key('down',done)
    it 'アイテム数確認 1', ->
      actor = rpg.game.party.getAt(0)
      actor.backpack.itemCount.should.equal 2
    it '選択', (done) ->
      emulate_key('enter',done)
    it 'メッセージ待ち', (done) ->
      setTimeout(done,2000)
    it 'メッセージ', (done) ->
      emulate_key('enter',done)
    it 'アイテム数確認 2', ->
      actor = rpg.game.party.getAt(0)
      actor.backpack.itemCount.should.equal 1
    it 'カーソル位置確認', ->
      wmm = rpg.system.scene.windowMapMenu
      w = wmm.findWindowTree (o) -> o instanceof rpg.WindowItemList
      w.index.should.equal 0
    it 'キャンセル', (done) ->
      emulate_key('escape',done)
    it 'キャンセル', (done) ->
      emulate_key('escape',done)
    it 'キャンセル', (done) ->
      emulate_key('escape',done)

  describe 'アイテムをトレード', ->
    describe '渡す', ->
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'アイテム数確認', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
      it 'メニュー表示', (done) ->
        emulate_key('enter',done)
      it 'どうぐへ移動', (done) ->
        emulate_key('down',done)
      it 'メニュー選択', (done) ->
        emulate_key('enter',done)
      it 'アクター選択', (done) ->
        emulate_key('enter',done)
      it 'アイテム選択', (done) ->
        emulate_key('enter',done)
      it 'わたすへ移動', (done) ->
        emulate_key('down',done)
      it 'メニュー選択', (done) ->
        emulate_key('enter',done)
      it '２番目のアクターに移動', (done) ->
        emulate_key('down',done)
      it 'アクター選択', (done) ->
        emulate_key('enter',done)
      it 'アイテム欄選択', (done) ->
        emulate_key('enter',done)
      it 'アイテム数確認', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 1
      it 'メッセージ待ち', (done) ->
        setTimeout(done,2000)
      it 'メッセージ', (done) ->
        emulate_key('enter',done)
      it 'キャンセル', (done) ->
        emulate_key('escape',done)
      it 'キャンセル', (done) ->
        emulate_key('escape',done)

    describe '交換', ->
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'wait', (done) ->
        setTimeout(done,1000)
      it '通常アイテムをロード', (done) ->
        db = rpg.system.db
        db.preloadItem([3],(items) ->
          actor = rpg.game.party.getAt(1)
          item = items[0]
          actor.backpack.addItem item
          item.url.should.
            equal 'http://localhost:3000/client/data/item/003.json'
          item.type.should.equal 'Item'
          done()
        )
      it 'アイテム数確認', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
        item = actor.backpack.getItem(0)
        item.name.should.equal 'item 001'
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 1
        item = actor.backpack.getItem(0)
        item.name.should.equal 'item 003'
      it 'メニュー表示', (done) ->
        emulate_key('enter',done)
      it 'どうぐへ移動', (done) ->
        emulate_key('down',done)
      it 'メニュー選択', (done) ->
        emulate_key('enter',done)
      it 'アクター選択', (done) ->
        emulate_key('enter',done)
      it 'アイテム選択', (done) ->
        emulate_key('enter',done)
      it 'わたすへ移動', (done) ->
        emulate_key('down',done)
      it 'メニュー選択', (done) ->
        emulate_key('enter',done)
      it '２番目のアクターに移動', (done) ->
        emulate_key('down',done)
      it 'アクター選択', (done) ->
        emulate_key('enter',done)
      it 'アイテム欄選択', (done) ->
        emulate_key('enter',done)
      it 'アイテム数確認', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
        item = actor.backpack.getItem(0)
        item.name.should.equal 'item 003'
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 1
        item = actor.backpack.getItem(0)
        item.name.should.equal 'item 001'
      it 'メッセージ待ち', (done) ->
        setTimeout(done,2000)
      it 'メッセージ', (done) ->
        emulate_key('enter',done)
      it 'キャンセル', (done) ->
        emulate_key('escape',done)
      it 'キャンセル', (done) ->
        emulate_key('escape',done)
      it 'キャンセル', (done) ->
        emulate_key('escape',done)

  describe 'アイテムを使う', ->
    describe '単体アイテム', ->
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'アクターにダメージ', ->
        actor = rpg.game.party.getAt(1)
        actor.hp -= 20
      it '通常アイテムをロード', (done) ->
        db = rpg.system.db
        db.preloadItem([4],(items) ->
          actor = rpg.game.party.getAt(0)
          item = items[0]
          actor.backpack.addItem item
          item.url.should.
            equal 'http://localhost:3000/client/data/item/004.json'
          item.type.should.equal 'UsableItem'
          done()
        )
      it 'メニュー表示', (done) ->
        emulate_key('enter',done)
      it 'どうぐへ移動', (done) ->
        emulate_key('down',done)
      it 'メニュー選択', (done) ->
        emulate_key('enter',done)
      it 'アクター選択', (done) ->
        emulate_key('enter',done)
      it '２番目のアイテムに移動', (done) ->
        emulate_key('down',done)
      it 'アイテム選択', (done) ->
        emulate_key('enter',done)
      it 'つかうメニュー選択', (done) ->
        emulate_key('enter',done)
      it '２番目のアクターに移動', (done) ->
        emulate_key('down',done)
      it 'アクター選択', (done) ->
        emulate_key('enter',done)
      it 'HP確認', ->
        actor = rpg.game.party.getAt(1)
        actor.hp.should.equal (actor.maxhp - 10)
      it 'メッセージ待ち', (done) ->
        setTimeout(done,1000)
      it 'メッセージ', (done) ->
        emulate_key('enter',done)
      it 'メッセージ待ち', (done) ->
        setTimeout(done,1000)
      it 'メッセージ', (done) ->
        emulate_key('enter',done)
      it 'キャンセル', (done) ->
        emulate_key('escape',done)
      it 'キャンセル', (done) ->
        emulate_key('escape',done)
      it 'キャンセル', (done) ->
        emulate_key('escape',done)

    describe '複数アイテム', ->
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'wait', (done) ->
        setTimeout(done,1000)
      it 'アクターにダメージ', ->
        actor = rpg.game.party.getAt(0)
        actor.hp -= 20
        actor = rpg.game.party.getAt(1)
        actor.hp -= 20
      it '通常アイテムをロード', (done) ->
        db = rpg.system.db
        db.preloadItem([5],(items) ->
          actor = rpg.game.party.getAt(0)
          item = items[0]
          actor.backpack.addItem item
          item.url.should.
            equal 'http://localhost:3000/client/data/item/005.json'
          item.type.should.equal 'UsableItem'
          done()
        )
      it 'メニュー表示', (done) ->
        emulate_key('enter',done)
      it 'どうぐへ移動', (done) ->
        emulate_key('down',done)
      it 'メニュー選択', (done) ->
        emulate_key('enter',done)
      it 'アクター選択', (done) ->
        emulate_key('enter',done)
      it '２番目のアイテムに移動', (done) ->
        emulate_key('down',done)
      it 'アイテム選択', (done) ->
        emulate_key('enter',done)
      it 'つかうメニュー選択', (done) ->
        emulate_key('enter',done)
      it 'HP確認', ->
        actor = rpg.game.party.getAt(1)
        actor.hp.should.equal (actor.maxhp - 10)
      it 'メッセージ表示待ち', (done) ->
        checkMessage callback:done, msg:'あくたー１ は　heal I を使った。'
      it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
      it 'メッセージ表示待ち', (done) ->
        checkMessage
          callback:done
          msg:'あくたー１ の hp が 10 回復した。'
      it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
      it 'メッセージ表示待ち', (done) ->
        checkMessage
          callback:done
          msg:'あくたー２ の hp が 10 回復した。'
      it '次のメッセージ表示', (done) -> emulateKey callback:done, key: 'enter'
      it 'キャンセル', (done) -> emulateKey callback:done, key: 'escape'
      it 'キャンセル', (done) -> emulateKey callback:done, key: 'escape'
      it 'キャンセル', (done) -> emulateKey callback:done, key: 'escape'
