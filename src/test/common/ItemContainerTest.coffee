
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/ItemContainer.coffee')

describe 'rpg.ItemContainer', ->
  rpg.system = rpg.system ? {}
  rpg.system.temp = rpg.system.temp ? {}

  describe '基本操作', ->
    c = null
    it '初期化', ->
      c = new rpg.ItemContainer()
    it 'アイテムを追加すると個数が増える', ->
      item = new rpg.Item(name:'Item01')
      c.contains(item).should.equal false
      c.itemCount.should.equal 0
      c.add item
      c.itemCount.should.equal 1
      c.contains(item).should.equal true
    it 'アイテムを削除すると個数が減る', ->
      item = c.itemlist()[0]
      c.contains(item).should.equal true
      c.itemCount.should.equal 1
      c.remove item
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
    it '名前で取得', ->
      item = c.find 'Item02'
      item.name.should.equal 'Item02'
      item = c.find 'Item01'
      item.name.should.equal 'Item01'
    it '名前で取得、無い場合はnull', ->
      item = c.find 'Item03'
      (item is null).should.equal true
    it 'インデックスで取得、無い場合はnull', ->
      item = c.getAt 1
      item.name.should.equal 'Item02'
      item = c.getAt 0
      item.name.should.equal 'Item01'
      item = c.getAt 3
      (item is null).should.equal true
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
    it '同種２つ削除', ->
      item1 = c.find 'Item03'
      c.itemCount.should.equal 2
      c.remove item1
      item2 = c.find 'Item03'
      c.itemCount.should.equal 1
      c.remove item2
      c.itemCount.should.equal 0
      c.contains(item2).should.equal false
  describe 'スタックアイテム', ->
    c = null
    describe 'スタックコンテナ', ->
      describe 'スタック可能アイテム', ->
        describe '同名', ->
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
          it '削除可能', ->
            item = c.getAt 0
            (item is null).should.equal false
            item.name.should.equal 'Item01'
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is null).should.equal false
            item.name.should.equal 'Item01'
            c.remove item
            r.should.equal true
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
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
            (item is null).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal true
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is null).should.equal false
            item.name.should.equal 'Item02'
            item.stack.should.equal true
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 0
            c.itemlistCount.should.equal 0
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
            (item is null).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is null).should.equal false
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
            (item is null).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is null).should.equal false
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
          it '削除可能', ->
            item = c.getAt 0
            (item is null).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal true
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is null).should.equal false
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
            (item is null).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal true
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is null).should.equal false
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
            (item is null).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is null).should.equal false
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
            (item is null).should.equal false
            item.name.should.equal 'Item01'
            item.stack.should.equal false
            r = c.remove item
            r.should.equal true
            c.itemCount.should.equal 1
            c.itemlistCount.should.equal 1
            item = c.getAt 0
            (item is null).should.equal false
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
