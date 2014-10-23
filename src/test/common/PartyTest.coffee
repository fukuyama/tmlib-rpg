require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/UsableItem.coffee')
require('../../main/common/ItemContainer.coffee')
require('../../main/common/Party.coffee')

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Party', () ->
  party = null
  describe '初期化', () ->
    it '初期化', ->
      party = new rpg.Party()
    it '初期メンバー数は０', ->
      party.length.should.equal 0
    it '所持金は０', ->
      party.cash.should.equal 0
  describe '引数有', () ->
    it '初期化', ->
      party = new rpg.Party({cash:100})
    it '所持金は100', ->
      party.cash.should.equal 100
    it 'セーブロード後も100', ->
      json = rpg.utils.createJsonData(party)
      party = rpg.utils.createRpgObject(json)
      party.cash.should.equal 100
  describe '所持金', () ->
    it '初期化', ->
      party = new rpg.Party({cash:100})
    it '所持金は100', ->
      party.cash.should.equal 100
    it '所持金は０以下にならない', ->
      party.cash -= 999
      party.cash.should.equal 0
  describe 'メンバー操作', () ->
    a1 = null
    a2 = null
    it '初期化', ->
      party = new rpg.Party()
    it 'メンバーを追加できる', ->
      a1 = new rpg.Actor(name:'test1')
      a2 = new rpg.Actor(name:'test2')
      a3 = new rpg.Actor(name:'test3')
      party.length.should.equal 0
      party.add(a1)
      party.length.should.equal 1
      party.add(a2)
      party.length.should.equal 2
      party.add(a3)
      party.length.should.equal 3
    it 'メンバーリスト処理', ->
      nms = ''
      party.each((a) ->
        nms += a.name
      )
      nms.should.equal 'test1test2test3'
    it 'メンバーを削除できる', ->
      party.length.should.equal 3
      party.remove(a2)
      party.length.should.equal 2
      party.getAt(0).name.should.equal 'test1'
      party.getAt(1).name.should.equal 'test3'
    it '範囲外はnullを返す', ->
      (typeof party.getAt(10)).should.equal 'undefined'
  describe 'パーティのアイテム操作', () ->
    a1 = null
    a2 = null
    it '初期化', ->
      party = new rpg.Party()
    it 'バックパックにアイテム追加', ->
      party.backpack.itemCount.should.equal 0
      party.backpack.addItem new rpg.Item(name:'Item01')
      party.backpack.itemCount.should.equal 1
    it 'パーティの誰かにアイテム追加', ->
      a1 = new rpg.Actor(name:'test1',backpack:{max:3})
      a2 = new rpg.Actor(name:'test2',backpack:{max:3})
      party.length.should.equal 0
      party.add(a1)
      party.length.should.equal 1
      party.add(a2)
      r = party.addItem new rpg.Item(name:'Item01')
      r.should.equal true
    it 'みんな空なので先頭のアクターのバックアップに１つ入る', ->
      party.getAt(0).backpack.itemCount.should.equal 1
      party.getAt(1).backpack.itemCount.should.equal 0
    it 'パーティの誰かにアイテム追加２つ目なので、先頭のアクターへ', ->
      r = party.addItem new rpg.Item(name:'Item01')
      r.should.equal true
      party.getAt(0).backpack.itemCount.should.equal 2
      party.getAt(1).backpack.itemCount.should.equal 0
    it 'アクターのバックパックが最大３なので４つ目は二人目に入る', ->
      r = party.addItem new rpg.Item(name:'Item01')
      r.should.equal true
      r = party.addItem new rpg.Item(name:'Item01')
      r.should.equal true
      party.getAt(0).backpack.itemCount.should.equal 3
      party.getAt(1).backpack.itemCount.should.equal 1
    it 'アクターのバックパックが最大３なので７つ目はパーティのバックパックに入る', ->
      r = party.addItem new rpg.Item(name:'Item01')
      r.should.equal true
      r = party.addItem new rpg.Item(name:'Item01')
      r.should.equal true
      party.getAt(0).backpack.itemCount.should.equal 3
      party.getAt(1).backpack.itemCount.should.equal 3
      r = party.addItem new rpg.Item(name:'Item01')
      r.should.equal true
      party.backpack.itemCount.should.equal 2
    it '１番目のアクターの持つアイテムを削除する', ->
      item = party.getAt(0).backpack.getItem('Item01')
      party.removeItem item
      party.getAt(0).backpack.itemCount.should.equal 2
      party.getAt(1).backpack.itemCount.should.equal 3
      party.backpack.itemCount.should.equal 2
    it '２番目のアクターの持つアイテムを削除する', ->
      item = party.getAt(1).backpack.getItem('Item01')
      party.removeItem item
      party.getAt(0).backpack.itemCount.should.equal 2
      party.getAt(1).backpack.itemCount.should.equal 2
      party.backpack.itemCount.should.equal 2
    it 'バックパックの中のアイテムを削除する', ->
      item = party.backpack.getItem('Item01')
      party.removeItem item
      party.getAt(0).backpack.itemCount.should.equal 2
      party.getAt(1).backpack.itemCount.should.equal 2
      party.backpack.itemCount.should.equal 1
    it 'だれも持ってないアイテムは削除されない', ->
      item = new rpg.Item(name:'Item01')
      party.removeItem item
      party.getAt(0).backpack.itemCount.should.equal 2
      party.getAt(1).backpack.itemCount.should.equal 2
      party.backpack.itemCount.should.equal 1
    it '別のアイテムをパーティ用バックパックへ追加', ->
      r = party.backpack.addItem new rpg.Item(name:'Item03')
      r.should.equal true
      party.getAt(0).backpack.itemCount.should.equal 2
      party.getAt(1).backpack.itemCount.should.equal 2
      party.backpack.itemCount.should.equal 2
    it '別のアイテムを追加', ->
      r = party.addItem new rpg.Item(name:'Item02')
      r.should.equal true
      party.getAt(0).backpack.itemCount.should.equal 3
      party.getAt(1).backpack.itemCount.should.equal 2
      party.backpack.itemCount.should.equal 2
      r = party.addItem new rpg.Item(name:'Item02')
      r.should.equal true
      party.getAt(0).backpack.itemCount.should.equal 3
      party.getAt(1).backpack.itemCount.should.equal 3
      party.backpack.itemCount.should.equal 2
    it '誰かのアイテムを取得', ->
      item = party.getItem('Item01')
      item.name.should.equal 'Item01'
    it 'バックパックにしかないアイテムを取得', ->
      item = party.getItem('Item03')
      item.name.should.equal 'Item03'
    it '誰かのアイテムを取得して削除、多分先頭キャラ', ->
      item = party.getItem('Item01')
      item.name.should.equal 'Item01'
      party.removeItem(item)
      party.getAt(0).backpack.itemCount.should.equal 2
      party.getAt(1).backpack.itemCount.should.equal 3
      party.backpack.itemCount.should.equal 2
    it 'バックパックにしかないアイテムを削除', ->
      item = party.getItem('Item03')
      item.name.should.equal 'Item03'
      party.removeItem(item)
      party.getAt(0).backpack.itemCount.should.equal 2
      party.getAt(1).backpack.itemCount.should.equal 3
      party.backpack.itemCount.should.equal 1
    it 'スタックアイテムを２つ追加', ->
      r = party.addItem new rpg.Item(name:'Item05',stack:on)
      r.should.equal true
      party.getAt(0).backpack.itemCount.should.equal 3
      party.getAt(0).backpack.itemlistCount.should.equal 3
      party.getAt(1).backpack.itemCount.should.equal 3
      party.backpack.itemCount.should.equal 1
      r = party.addItem new rpg.Item(name:'Item05',stack:on)
      r.should.equal true
      party.getAt(0).backpack.itemCount.should.equal 4
      party.getAt(0).backpack.itemlistCount.should.equal 3
      party.getAt(1).backpack.itemCount.should.equal 3
      party.backpack.itemCount.should.equal 1
    it 'スタックアイテムを削除', ->
      item = party.getItem('Item05')
      item.name.should.equal 'Item05'
      party.removeItem(item)
      party.getAt(0).backpack.itemCount.should.equal 3
      party.getAt(0).backpack.itemlistCount.should.equal 3
      party.getAt(1).backpack.itemCount.should.equal 3
      party.backpack.itemCount.should.equal 1
      item = party.getItem('Item05')
      item.name.should.equal 'Item05'
      party.removeItem(item)
      party.getAt(0).backpack.itemCount.should.equal 2
      party.getAt(0).backpack.itemlistCount.should.equal 2
      party.getAt(1).backpack.itemCount.should.equal 3
      party.backpack.itemCount.should.equal 1
    it 'アイテムをすべて削除', ->
      party.getAt(0).backpack.itemCount.should.equal 2
      party.getAt(1).backpack.itemCount.should.equal 3
      party.backpack.itemCount.should.equal 1
      party.clearItem()
      party.getAt(0).backpack.itemCount.should.equal 0
      party.getAt(1).backpack.itemCount.should.equal 0
      party.backpack.itemCount.should.equal 0
