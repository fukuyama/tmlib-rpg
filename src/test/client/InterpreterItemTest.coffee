# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Item)', () ->
  interpreter = null
  @timeout(10000)
  describe 'アイテム関連のイベント', ->
    describe '個別のアイテム操作', ->
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'ウェイト', (done) ->
        setTimeout(done,1000)
      it 'アクターチェック', ->
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it '１番目のアクターにアイテムを渡す', (done) ->
        interpreter.start [
          {type:'gain_item',params:[1,1,0]}
          {type:'function',params:[done]}
        ]
      it '１番目のアクターのアイテムが増える', ->
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 2
      it '２番目のアクターにアイテムを渡す', (done) ->
        interpreter.start [
          {type:'gain_item',params:[{id:1,actor:1}]}
          {type:'function',params:[done]}
        ]
      it '２番目のアクターのアイテムが増える', ->
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 1
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 2
      it 'パーティの袋にアイテムを入れる', (done) ->
        interpreter.start [
          {type:'gain_item',params:[{id:2,num:2,backpack:true}]}
          {type:'function',params:[done]}
        ]
      it 'パーティの袋のアイテムが増える', ->
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 1
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 2
        backpack = rpg.game.party.backpack
        backpack.itemCount.should.equal 2
      it 'パーティの袋のアイテムを削除', (done) ->
        interpreter.start [
          {type:'lost_item',params:[{id:2,backpack:true}]}
          {type:'function',params:[done]}
        ]
      it 'パーティの袋のアイテムが減る', ->
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 1
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 2
        backpack = rpg.game.party.backpack
        backpack.itemCount.should.equal 1
      it '２番目のアクターのアイテムを捨てる', (done) ->
        interpreter.start [
          {type:'lost_item',params:[{id:1,actor:1}]}
          {type:'function',params:[done]}
        ]
      it '２番目のアクターのアイテムが減る', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 2
        backpack = rpg.game.party.backpack
        backpack.itemCount.should.equal 1
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
      it 'すべて削除する', (done) ->
        interpreter.start [
          {type:'clear_item',params:[]}
          {type:'function',params:[done]}
        ]
      it '全て削除される', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 0
    describe 'パーティアイテム操作', ->
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'ウェイト', (done) ->
        setTimeout(done,1000)
      it 'アクターの所持数限界確認', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemMax = 8
        actor.backpack.itemMax.should.equal 8
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'アイテムを１つ増やす', (done) ->
        interpreter.start [
          {type:'gain_item',params:[{id:2}]}
          {type:'function',params:[done]}
        ]
      it '先頭プレイヤーのアイテムが１つ増える', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 2
      it 'もうアイテムを１つ増やす', (done) ->
        interpreter.start [
          {type:'gain_item',params:[2]}
          {type:'function',params:[done]}
        ]
      it '先頭プレイヤーのアイテムが２つになる', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 3
      it 'アイテムを１０こ増やす', (done) ->
        interpreter.start [
          {type:'gain_item',params:[1,10]}
          {type:'function',params:[done]}
        ]
      it '先頭プレイヤーが８こ、２番目が４こ', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 5
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 8
      it '増やしたアイテムを削除する', (done) ->
        interpreter.start [
          {type:'lost_item',params:[2]}
          {type:'function',params:[done]}
        ]
      it '先頭プレイヤーのアイテムが減る', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 5
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 7
      it '増やしたアイテムを削除する（複数）', (done) ->
        interpreter.start [
          {type:'lost_item',params:[1,7]}
          {type:'function',params:[done]}
        ]
      it '合計で７つ減る', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 4
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
      it 'アイテムを2こ増やす', (done) ->
        interpreter.start [
          {type:'gain_item',params:[{id:2,num:2}]}
          {type:'function',params:[done]}
        ]
      it '２こ増えている', ->
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 4
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 3
      it 'すべて削除する', (done) ->
        interpreter.start [
          {type:'clear_item',params:[]}
          {type:'function',params:[done]}
        ]
      it '全て削除される', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 0
    describe '武器アイテム操作', ->
      n = 0
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'ウェイト', (done) ->
        setTimeout(done,1000)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'アイテム所持数確認', ->
        actor = rpg.game.party.getAt(0)
        n = actor.backpack.itemCount
      it '武器を１つ増やす', (done) ->
        interpreter.start [
          {type:'gain_weapon',params:[{id:1}]}
          {type:'function',params:[done]}
        ]
      it '１つ増えている', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal (n + 1)
      it '武器を１つ減らす', (done) ->
        interpreter.start [
          {type:'lost_weapon',params:[{id:1}]}
          {type:'function',params:[done]}
        ]
      it '１つ減っている', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal n

    describe '防具アイテム操作', ->
      n = 0
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'ウェイト', (done) ->
        setTimeout(done,1000)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'アイテム所持数確認', ->
        actor = rpg.game.party.getAt(0)
        n = actor.backpack.itemCount
      it '防具を１つ増やす', (done) ->
        interpreter.start [
          {type:'gain_armor',params:[1]}
          {type:'function',params:[done]}
        ]
      it '１つ増えている', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal (n + 1)
      it '防具を１つ減らす', (done) ->
        interpreter.start [
          {type:'lost_armor',params:[1]}
          {type:'function',params:[done]}
        ]
      it '１つ減っている', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal n

    describe '防具アイテム装備', ->
      n = 0
      it 'マップシーンへ移動', (done) ->
        reloadTestMap(done)
      it 'ウェイト', (done) ->
        setTimeout(done,1000)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'アイテム所持数確認', ->
        actor = rpg.game.party.getAt(0)
        n = actor.backpack.itemCount
      it '装備してない', ->
        actor = rpg.game.party.getAt(0)
        (actor.head is null).should.equal true
      it '防具を持ってないので装備できない', (done) ->
        interpreter.start [
          {type:'equip_armor',params:[0,1]}
          {type:'function',params:[done]}
        ]
      it '装備してない', ->
        actor = rpg.game.party.getAt(0)
        (actor.head is null).should.equal true
      it '防具を１つ増やす', (done) ->
        interpreter.start [
          {type:'gain_armor',params:[1]}
          {type:'function',params:[done]}
        ]
      it '１つ増えている', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal (n + 1)
      it '装備してない', ->
        actor = rpg.game.party.getAt(0)
        (actor.head is null).should.equal true
      it '防具を装備する', (done) ->
        interpreter.start [
          {type:'equip_armor',params:[0,1]}
          {type:'function',params:[done]}
        ]
      it '装備している', ->
        actor = rpg.game.party.getAt(0)
        actor.head.name.should.equal '兜'

    describe 'preload テスト', ->
      describe 'preload テスト１', ->
        n = 0
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'ウェイト', (done) ->
          setTimeout(done,1000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'アイテム所持数確認', ->
          actor = rpg.game.party.getAt(0)
          n = actor.backpack.itemCount
        it 'preload アイテム２つ', (done) ->
          interpreter.start [
            {type:'preload_item',params:[{
              items: [1,2]
            }]}
            {type:'gain_item',params:[1]}
            {type:'gain_item',params:[1]}
            {type:'function',params:[done]}
          ]
        it '２つ増えている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n + 2)
      describe 'preload テスト２', ->
        n = 0
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'ウェイト', (done) ->
          setTimeout(done,1000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'アイテム所持数確認', ->
          actor = rpg.game.party.getAt(0)
          n = actor.backpack.itemCount
        it 'preload アイテム２つ 武器２つ　防具５つ', (done) ->
          interpreter.start [
            {type:'preload_item',params:[{
              items: [1,2]
              weapons: [1,2]
              armors: [1,2,3,4,5]
            }]}
            {type:'function',params:[done]}
          ]
    describe '購入処理', ->
      describe '基本', ->
        n = 0
        c = 0
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'ウェイト', (done) ->
          setTimeout(done,1000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'アイテム所持数確認', ->
          actor = rpg.game.party.getAt(0)
          n = actor.backpack.itemCount
          item = actor.backpack.getItem('item 003')
          (item is undefined).should.equal true
        it '所持金を増やす', ->
          rpg.game.party.cash += 10
          c = rpg.game.party.cash
        it 'アイテムを１つ購入', (done) ->
          interpreter.start [
            {type:'buy_item',params:[3]}
            {type:'function',params:[done]}
          ]
        it '１つ増えている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n + 1)
          actor.backpack.getItem('item 003').name.should.equal 'item 003'
        it '所持金が減っている', ->
          rpg.game.party.cash.should.equal (c - 10)
      describe 'プライス違い', ->
        n = 0
        c = 0
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'ウェイト', (done) ->
          setTimeout(done,1000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'アイテム所持数確認', ->
          actor = rpg.game.party.getAt(0)
          n = actor.backpack.itemCount
        it '所持金を増やす', ->
          rpg.game.party.cash += 100
          c = rpg.game.party.cash
        it 'アイテムを１つ購入（ただし値段は、100）', (done) ->
          interpreter.start [
            {type:'buy_item',params:[id:1,price:100]}
            {type:'function',params:[done]}
          ]
        it '１つ増えている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n + 1)
        it '所持金が減っている', ->
          rpg.game.party.cash.should.equal (c - 100)
      describe '武器', ->
        n = 0
        c = 0
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'ウェイト', (done) ->
          setTimeout(done,1000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'アイテム所持数確認', ->
          actor = rpg.game.party.getAt(0)
          n = actor.backpack.itemCount
          item = actor.backpack.getItem('片手剣')
          (item is undefined).should.equal true
        it '所持金を増やす', ->
          rpg.game.party.cash += 1000
          c = rpg.game.party.cash
        it 'アイテムを１つ購入', (done) ->
          interpreter.start [
            {type:'buy_weapon',params:[1]}
            {type:'function',params:[done]}
          ]
        it '１つ増えている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n + 1)
          actor.backpack.getItem('片手剣').name.should.equal '片手剣'
        it '所持金が減っている', ->
          actor = rpg.game.party.getAt(0)
          item = actor.backpack.getItem('片手剣')
          rpg.game.party.cash.should.equal (c - item.price)
      describe '防具', ->
        n = 0
        c = 0
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'ウェイト', (done) ->
          setTimeout(done,1000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'アイテム所持数確認', ->
          actor = rpg.game.party.getAt(0)
          n = actor.backpack.itemCount
          item = actor.backpack.getItem('兜')
          (item is undefined).should.equal true
        it '所持金を増やす', ->
          rpg.game.party.cash += 1000
          c = rpg.game.party.cash
        it 'アイテムを１つ購入', (done) ->
          interpreter.start [
            {type:'buy_armor',params:[1]}
            {type:'function',params:[done]}
          ]
        it '１つ増えている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n + 1)
          actor.backpack.getItem('兜').name.should.equal '兜'
        it '所持金が減っている', ->
          actor = rpg.game.party.getAt(0)
          item = actor.backpack.getItem('兜')
          rpg.game.party.cash.should.equal (c - item.price)

      describe 'ショップアイテムの購入', ->
        n = 0
        c = 0
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'ウェイト', (done) ->
          setTimeout(done,1000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'アイテム所持数確認', ->
          actor = rpg.game.party.getAt(0)
          n = actor.backpack.itemCount
          item = actor.backpack.getItem('兜')
          (item is undefined).should.equal true
        it '所持金を増やす', ->
          rpg.game.party.cash += 1000
          c = rpg.game.party.cash
        it 'アイテムを１つ購入', (done) ->
          rpg.system.temp.log = {
            item:
              index: 1
              type: 'armor'
              name: '兜'
              url: 'http://localhost:3000/client/data/armor/001.json'
              num: 1
              price: 100
          }
          interpreter.start [
            {type:'buy_shop_item'}
            {type:'function',params:[done]}
          ]
        it '１つ増えている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n + 1)
          actor.backpack.getItem('兜').name.should.equal '兜'
        it '所持金が減っている', ->
          actor = rpg.game.party.getAt(0)
          item = actor.backpack.getItem('兜')
          rpg.game.party.cash.should.equal (c - 100)

    describe '販売処理', ->
      describe '基本', ->
        n = 0
        c = 0
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'ウェイト', (done) ->
          setTimeout(done,1000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'アイテム所持数確認', ->
          actor = rpg.game.party.getAt(0)
          n = actor.backpack.itemCount
        it '所持金を確認', ->
          c = rpg.game.party.cash
        it 'アイテムを１つ増やす', (done) ->
          interpreter.start [
            {type:'gain_item',params:[3]}
            {type:'function',params:[done]}
          ]
        it '１つ増えている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n + 1)
          actor.backpack.getItem('item 003').name.should.equal 'item 003'
          n = actor.backpack.itemCount
        it 'アイテムを１つ売る', (done) ->
          interpreter.start [
            {type:'sell_item',params:[3]}
            {type:'function',params:[done]}
          ]
        it '１つ減っている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n - 1)
          item = actor.backpack.getItem('item 003')
          (item is undefined).should.equal true
        it '所持金が増えている', ->
          rpg.game.party.cash.should.equal (c + 2)
      describe '割り切れない price', ->
        n = 0
        c = 0
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'ウェイト', (done) ->
          setTimeout(done,1000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'アイテム所持数確認', ->
          actor = rpg.game.party.getAt(0)
          n = actor.backpack.itemCount
        it '所持金を確認', ->
          c = rpg.game.party.cash
        it 'アイテムを１つ増やす', (done) ->
          interpreter.start [
            {type:'gain_item',params:[9]}
            {type:'function',params:[done]}
          ]
        it '１つ増えている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n + 1)
          actor.backpack.getItem('heal III').name.should.equal 'heal III'
          n = actor.backpack.itemCount
        it 'アイテムを１つ売る', (done) ->
          interpreter.start [
            {type:'sell_item',params:[9]}
            {type:'function',params:[done]}
          ]
        it '１つ減っている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n - 1)
          item = actor.backpack.getItem('heal III')
          (item is undefined).should.equal true
        it '所持金が増えている', ->
          rpg.game.party.cash.should.equal (c + 10)
      describe 'プライス違い', ->
        n = 0
        c = 0
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'ウェイト', (done) ->
          setTimeout(done,1000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'アイテム所持数確認', ->
          actor = rpg.game.party.getAt(0)
          n = actor.backpack.itemCount
        it '所持金を確認', ->
          c = rpg.game.party.cash
        it 'アイテムを１つ増やす', (done) ->
          interpreter.start [
            {type:'gain_item',params:[1]}
            {type:'function',params:[done]}
          ]
        it '１つ増えている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n + 1)
          n = actor.backpack.itemCount
        it 'アイテムを１つ売る（100で売る）', (done) ->
          interpreter.start [
            {type:'sell_item',params:[id:1,price:100]}
            {type:'function',params:[done]}
          ]
        it '１つ減っている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n - 1)
        it '所持金が増えている', ->
          rpg.game.party.cash.should.equal (c + 100)
      describe '武器', ->
        n = 0
        c = 0
        iprice = 0
        it 'マップシーンへ移動', (done) ->
          reloadTestMap(done)
        it 'ウェイト', (done) ->
          setTimeout(done,1000)
        it 'インタープリタ取得', ->
          interpreter = rpg.system.scene.interpreter
        it 'アイテム所持数確認', ->
          actor = rpg.game.party.getAt(0)
          n = actor.backpack.itemCount
          item = actor.backpack.getItem('片手斧')
          (item is undefined).should.equal true
        it '所持金を確認', ->
          c = rpg.game.party.cash
        it 'アイテムを１つ増やす', (done) ->
          interpreter.start [
            {type:'gain_weapon',params:[2]}
            {type:'function',params:[done]}
          ]
        it '１つ増えている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n + 1)
          item = actor.backpack.getItem('片手斧')
          item.name.should.equal '片手斧'
          iprice = item.price
          n = actor.backpack.itemCount
        it 'アイテムを１つ売る', (done) ->
          interpreter.start [
            {type:'sell_weapon',params:[2]}
            {type:'function',params:[done]}
          ]
        it '１つ減っている', ->
          actor = rpg.game.party.getAt(0)
          actor.backpack.itemCount.should.equal (n - 1)
          item = actor.backpack.getItem('片手斧')
          (item is undefined).should.equal true
        it '所持金が増えている', ->
          rpg.game.party.cash.should.equal (c + iprice / 5)
