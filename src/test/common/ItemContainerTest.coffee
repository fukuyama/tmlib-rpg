
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/ItemContainer.coffee')
require('../../main/common/UsableItem.coffee')

require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')

describe 'rpg.ItemContainer', ->
  rpg.system = rpg.system ? {}
  rpg.system.temp = rpg.system.temp ? {}

  describe '基本操作', ->
    c = null
    it '初期化', ->
      c = new rpg.ItemContainer()
    it 'セーブロード', ->
      json = rpg.utils.createJsonData(c)
      c = rpg.utils.createRpgObject(json)
    it 'アイテムを追加すると個数が増える', ->
      item = new rpg.Item(name:'Item01')
      c.contains(item).should.equal false
      c.itemCount.should.equal 0
      c.add item
      c.itemCount.should.equal 1
      c.contains(item).should.equal true
    it 'アイテムを削除すると個数が減る', ->
      item = c.getAt(0)
      c.contains(item).should.equal true
      c.itemCount.should.equal 1
      r = c.remove item
      r.should.equal true
      c.itemCount.should.equal 0
      c.contains(item).should.equal false
      r = c.remove item
      r.should.equal false
      c.itemCount.should.equal 0
      c.contains(item).should.equal false
    it '２種類追加', ->
      c.itemCount.should.equal 0
      c.add new rpg.Item(name:'Item01')
      c.itemCount.should.equal 1
      c.add new rpg.Item(name:'Item02')
      c.itemCount.should.equal 2
      c.itemlistCount.should.equal 2
      c.contains(new rpg.Item(name:'Item01')).should.equal true
      c.contains(new rpg.Item(name:'Item02')).should.equal true
    it 'セーブロード', ->
      json = rpg.utils.createJsonData(c)
      t = rpg.utils.createRpgObject(json)
      t.itemlistCount.should.equal 2
    it '名前で取得', ->
      item = c.find 'Item02'
      item.name.should.equal 'Item02'
      item = c.find 'Item01'
      item.name.should.equal 'Item01'
    it '名前で取得、無い場合は undefined', ->
      item = c.find 'Item03'
      (item is undefined).should.equal true
    it 'インデックスで取得、無い場合は undefined', ->
      item = c.getAt 1
      item.name.should.equal 'Item02'
      item = c.getAt 0
      item.name.should.equal 'Item01'
      item = c.getAt 3
      (item is undefined).should.equal true
      c.itemCount.should.equal 2
      c.itemlistCount.should.equal 2
    it '２種類削除', ->
      item1 = c.find 'Item01'
      item2 = c.find 'Item02'
      c.itemCount.should.equal 2
      c.remove item2
      c.itemCount.should.equal 1
      c.remove item1
      c.itemCount.should.equal 0
      c.contains(new rpg.Item(name:'Item01')).should.equal false
      c.contains(new rpg.Item(name:'Item02')).should.equal false
    it '同種２つ追加', ->
      c.itemCount.should.equal 0
      c.add new rpg.Item(name:'Item03')
      c.itemCount.should.equal 1
      c.add new rpg.Item(name:'Item03')
      c.itemCount.should.equal 2
      c.itemlistCount.should.equal 2
      c.contains(new rpg.Item(name:'Item03')).should.equal true
    it '同名アイテムの別インスタンスで削除はできない', ->
      item1 = new rpg.Item(name:'Item03')
      c.itemCount.should.equal 2
      c.remove item1
      c.itemCount.should.equal 2
    it '別名アイテムの別インスタンスで削除はできない', ->
      item1 = new rpg.Item(name:'NG')
      c.itemCount.should.equal 2
      c.remove item1
      c.itemCount.should.equal 2
    it '同種２つ削除', ->
      item1 = c.find 'Item03'
      c.itemCount.should.equal 2
      c.remove item1
      item2 = c.find 'Item03'
      c.itemCount.should.equal 1
      c.remove item2
      c.itemCount.should.equal 0
      c.contains(item2).should.equal false
    it '全削除', ->
      c.itemCount.should.equal 0
      c.add new rpg.Item(name:'Item03')
      c.itemCount.should.equal 1
      c.add new rpg.Item(name:'Item04')
      c.itemCount.should.equal 2
      c.clear()
      c.itemCount.should.equal 0
  describe 'スタックアイテム', ->
    c = null
    describe 'スタックコンテナ', ->
      describe 'スタック可能アイテム', ->
        describe '同名パターン１', ->
          it '追加するとスタックされる', ->
            c = new rpg.ItemContainer(stack:on)
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
            c.add new rpg.Item(name:'Item01',stack:true)
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            c.add new rpg.Item(name:'Item01',stack:true)
            c.itemCount.should.equal 2
            c.itemlistCount.should.equal 1
          it 'セーブロード', ->
            json = rpg.utils.createJsonData(c)
            t = rpg.utils.createRpgObject(json)
            t.itemlistCount.should.equal 1
          it '削除可能', ->
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            c.remove item
            r.should.equal true
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
        describe '同名パターン２', ->
          it '５種類入るスタックコンテナに', ->
            c = new rpg.ItemContainer(stack:on,max:5)
            c.itemCount.should.equal 0
          it '同名のスタック５アイテムを６個追加する', ->
            c.add new rpg.Item(name:'Item01',stack:true,maxStack:5)
            c.itemlistCount.should.equal 1
            c.add new rpg.Item(name:'Item01',stack:true,maxStack:5)
            c.add new rpg.Item(name:'Item01',stack:true,maxStack:5)
            c.itemlistCount.should.equal 1
            c.add new rpg.Item(name:'Item01',stack:true,maxStack:5)
            c.add new rpg.Item(name:'Item01',stack:true,maxStack:5)
            c.itemlistCount.should.equal 1
            c.add new rpg.Item(name:'Item01',stack:true,maxStack:5)
            c.itemCount.should.equal 6
            c.itemlistCount.should.equal 2
          it '同名アイテムの別インスタンスでは削除できない', ->
            c.remove(new rpg.Item(name:'Item01',stack:true,maxStack:5))
            c.itemCount.should.equal 6
            c.itemlistCount.should.equal 2
          it '別名アイテムの別インスタンスでは削除できない', ->
            c.remove(new rpg.Item(name:'NG',stack:true,maxStack:5))
            c.itemCount.should.equal 6
            c.itemlistCount.should.equal 2
          it 'アイテム１つ削除するとアイテムリストは１つになる', ->
            c.remove(c.getAt(0))
            c.itemCount.should.equal 5
            c.itemlistCount.should.equal 1
          it 'アイテム１つ追加アイテムリストは２つになる', ->
            c.add new rpg.Item(name:'Item01',stack:true,maxStack:5)
            c.itemlistCount.should.equal 2
          it 'セーブロード状態は変わらない', ->
            json = rpg.utils.createJsonData(c)
            c = rpg.utils.createRpgObject(json)
            c.itemCount.should.equal 6
            c.itemlistCount.should.equal 2
          it 'アイテム１つ削除するとアイテムリストは１つになる（ロード後）', ->
            c.remove(c.getAt(0))
            c.itemCount.should.equal 5
            c.itemlistCount.should.equal 1
          it 'アイテム１つ追加アイテムリストは２つになる（ロード後）', ->
            c.add new rpg.Item(name:'Item01',stack:true,maxStack:5)
            c.itemlistCount.should.equal 2
        describe '別名', ->
          it '追加するとスタックされない', ->
            c = new rpg.ItemContainer(stack:on)
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
            c.add new rpg.Item(name:'Item01',stack:true)
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            c.add new rpg.Item(name:'Item02',stack:true)
            c.itemCount.should.equal 2
            c.itemlistCount.should.equal 2
          it '削除可能', ->
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal true
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item02'
            item.stack.should.equal true
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
        describe 'スタックされたアイテムを使う', ->
          it '５種類入るスタックコンテナ', ->
            c = new rpg.ItemContainer(stack:on,max:5)
            c.itemCount.should.equal 0
          it '同名のスタック５アイテムを３個追加する', ->
            for i in [0 ... 3]
              item = new rpg.UsableItem(
                name:'Item01'
                stack:true
                maxStack:5
                lost:{max:2}
              )
              item.effect = -> true
              c.add item
            c.itemCount.should.equal 3
            c.itemlistCount.should.equal 1
          it 'アイテムを使う。１回目', ->
            item = c.find 'Item01'
            user = new rpg.Actor(name:'user')
            target = new rpg.Actor(name:'target')
            item.use user, target
            item.isLost().should.equal false
          it 'アイテムを使う。２回目', ->
            item = c.find 'Item01'
            user = new rpg.Actor(name:'user')
            target = new rpg.Actor(name:'target')
            item.use user, target
            item.isLost().should.equal true
          it '使い終わったから１つ減らす', ->
            item = c.find 'Item01'
            c.itemCount.should.equal 3
            c.itemlistCount.should.equal 1
            c.remove item
            c.itemCount.should.equal 2
            c.itemlistCount.should.equal 1
          it 'アイテムを使う。１回目（２こ目）', ->
            item = c.find 'Item01'
            user = new rpg.Actor(name:'user')
            target = new rpg.Actor(name:'target')
            item.use user, target
            item.isLost().should.equal false
          it 'アイテムを使う。２回目（２こ目）', ->
            item = c.find 'Item01'
            user = new rpg.Actor(name:'user')
            target = new rpg.Actor(name:'target')
            item.use user, target
            item.isLost().should.equal true
      describe 'スタック不可アイテム', ->
        describe '同名', ->
          it '追加してもスタックされない', ->
            c = new rpg.ItemContainer(stack:on)
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
            c.add new rpg.Item(name:'Item01',stack:false)
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            c.add new rpg.Item(name:'Item01',stack:false)
            c.itemCount.should.equal 2
            c.itemlistCount.should.equal 2
          it '削除可能', ->
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
        describe '別名', ->
          it '追加してもスタックされない', ->
            c = new rpg.ItemContainer(stack:on)
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
            c.add new rpg.Item(name:'Item01',stack:false)
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            c.add new rpg.Item(name:'Item02',stack:false)
            c.itemCount.should.equal 2
            c.itemlistCount.should.equal 2
          it '削除可能', ->
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item02'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
    describe '通常コンテナ', ->
      describe 'スタック可能アイテム', ->
        describe '同名', ->
          it '追加してもスタックされない', ->
            c = new rpg.ItemContainer()
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
            c.add new rpg.Item(name:'Item01',stack:true)
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            c.add new rpg.Item(name:'Item01',stack:true)
            c.itemCount.should.equal 2
            c.itemCount.should.equal 2
            c.itemlistCount.should.equal 2
          it 'セーブロード', ->
            json = rpg.utils.createJsonData(c)
            t = rpg.utils.createRpgObject(json)
            t.itemlistCount.should.equal 2
          it '削除可能', ->
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal true
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal true
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
        describe '別名', ->
          it '追加してもスタックされない', ->
            c = new rpg.ItemContainer()
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
            c.add new rpg.Item(name:'Item01',stack:true)
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            c.add new rpg.Item(name:'Item02',stack:true)
            c.itemCount.should.equal 2
            c.itemlistCount.should.equal 2
          it '削除可能', ->
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal true
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item02'
            item.stack.should.equal true
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
      describe 'スタック不可アイテム', ->
        describe '同名', ->
          it '追加してもスタックされない', ->
            c = new rpg.ItemContainer()
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
            c.add new rpg.Item(name:'Item01',stack:false)
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            c.add new rpg.Item(name:'Item01',stack:false)
            c.itemCount.should.equal 2
            c.itemCount.should.equal 2
            c.itemlistCount.should.equal 2
          it '削除可能', ->
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
        describe '別名', ->
          it '追加してもスタックされない', ->
            c = new rpg.ItemContainer()
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
            c.add new rpg.Item(name:'Item01',stack:false)
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            c.add new rpg.Item(name:'Item02',stack:false)
            c.itemCount.should.equal 2
            c.itemlistCount.should.equal 2
          it '削除可能', ->
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is undefined).should.equal false
            item.name.should.equal 'Item02'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
  describe '個数制限のコンテナ', ->
    c = null
    it '４つ追加するけど３つしか追加できない（同名）通常コンテナ', ->
      c = new rpg.ItemContainer(max:3)
      item = new rpg.Item(name:'Item01')
      c.itemCount.should.equal 0
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item01')
      c.itemCount.should.equal 1
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item01')
      c.itemCount.should.equal 2
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item01')
      c.itemCount.should.equal 3
      c.addCheck(item).should.equal false
      c.add new rpg.Item(name:'Item01')
      c.itemCount.should.equal 3
    it '４つ追加するけど３つしか追加できない（別名）通常コンテナ', ->
      c = new rpg.ItemContainer(max:3)
      item = new rpg.Item(name:'Item00')
      c.itemCount.should.equal 0
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item01')
      c.itemCount.should.equal 1
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item02')
      c.itemCount.should.equal 2
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item03')
      c.itemCount.should.equal 3
      c.addCheck(item).should.equal false
      c.add new rpg.Item(name:'Item04')
      c.itemCount.should.equal 3
    it '４つ追加するけどスタックされて追加ができる（同名のスタックアイテム）スタックコンテナ', ->
      c = new rpg.ItemContainer(max:3,stack:true)
      item = new rpg.Item(name:'Item01',stack:true)
      c.itemCount.should.equal 0
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item01',stack:true)
      c.itemCount.should.equal 1
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item01',stack:true)
      c.itemCount.should.equal 2
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item01',stack:true)
      c.itemCount.should.equal 3
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item01',stack:true)
      c.itemCount.should.equal 4
    it '４つ追加するけど３つしか追加できない（別名のスタックアイテム）スタックコンテナ', ->
      c = new rpg.ItemContainer(max:3,stack:true)
      item = new rpg.Item(name:'Item00',stack:true)
      c.itemCount.should.equal 0
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item01',stack:true)
      c.itemCount.should.equal 1
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item02',stack:true)
      c.itemCount.should.equal 2
      c.addCheck(item).should.equal true
      c.add new rpg.Item(name:'Item03',stack:true)
      c.itemCount.should.equal 3
      c.addCheck(item).should.equal false
      c.add new rpg.Item(name:'Item04',stack:true)
      c.itemCount.should.equal 3
