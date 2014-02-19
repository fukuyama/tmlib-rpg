
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/ItemContainer.coffee')

describe 'rpg.Item', ->
  rpg.system = rpg.system ? {}
  rpg.system.temp = rpg.system.temp ? {}

  describe '基本属性', ->
    item = null
    it 'アイテムの初期化', ->
      item = new rpg.Item()
    it '名前がある', ->
      (item.name is null).should.equal false
      item.name.should.equal ''
    it '名前を付ける', ->
      item.name = 'Name00'
      (item.name is null).should.equal false
      item.name.should.equal 'Name00'
    it '価格がある', ->
      (item.price is null).should.equal false
      item.price.should.equal 1
    it '価格を設定', ->
      item.price = 100
      item.price.should.equal 100
  describe '使えるかどうか調べる', ->
    item = null
    it 'アイテムの初期化', ->
      item = new rpg.Item({usable: true})
    it '使える場合 true', ->
      item.usable.should.equal true
    it 'アイテムの初期化', ->
      item = new rpg.Item({usable: false})
    it '使えない場合 false', ->
      item.usable.should.equal false
    it '設定できない', ->
      try
        item.usable = true
        item.usable.should.equal true
      item.usable.should.equal false
    it '戦闘中に使えるかどうか？', ->
      # 文字列を設定すると判定時にそのメソッドを使う
      item = new rpg.Item({usable: 'battle'})
    it '戦闘中は、true', ->
      rpg.system.temp.battle = true
      item.usable.should.equal true
    it 'それ以外は、false', ->
      rpg.system.temp.battle = false
      item.usable.should.equal false
  describe '装備できるかどうか調べる', ->
    item = null
    it 'アイテムの初期化', ->
      item = new rpg.Item({equip: true})
    it '装備できる場合 true', ->
      item.equip.should.equal true
    it 'アイテムの初期化', ->
      item = new rpg.Item({equip: false})
    it '装備できない場合 false', ->
      item.equip.should.equal false
    it '設定できない', ->
      try
        item.equip = true
        item.equip.should.equal true
      item.equip.should.equal false
  describe 'スタックできるかどうか調べる', ->
    item = null
    it 'アイテムの初期化', ->
      item = new rpg.Item({stack: true})
    it '装備できる場合 true', ->
      item.stack.should.equal true
    it 'アイテムの初期化', ->
      item = new rpg.Item({stack: false})
    it '装備できない場合 false', ->
      item.stack.should.equal false
    it '設定できない', ->
      try
        item.stack = true
        item.stack.should.equal true
      item.stack.should.equal false
  describe 'コンテナ化（アイテムにアイテムを入れられるようにする機能）', ->
    describe '基本機能', ->
      item = null
      it '初期化', ->
        item = new rpg.Item({name:'Item01',container:{}})
        (item is null).should.equal false
        item.name.should.equal 'Item01'
      it 'アイテム追加', ->
        item.addItem(new rpg.Item({name:'Item02'}))
      it 'アイテム取得', ->
        item.getItem(0).name.should.equal 'Item02'
      it 'アイテム数確認', ->
        item.itemCount.should.equal 1
      it 'アイテム削除', ->
        item.removeItem(item.getItem(0))
        item.itemCount.should.equal 0
    describe 'コンテナタイプを指定する', ->
      item = null
      it '初期化（デフォルトがmaxCountのコンテナなので入れられる最大値のみを設定する）', ->
        item = new rpg.Item({name:'Item01',container:{max:2}})
        item.itemCount.should.equal 0
      it 'アイテム追加', ->
        item.addItem(new rpg.Item({name:'Item02'}))
        item.itemCount.should.equal 1
      it 'アイテム追加', ->
        item.addItem(new rpg.Item({name:'Item02'}))
        item.itemCount.should.equal 2
      it 'アイテム追加', ->
        item.addItem(new rpg.Item({name:'Item02'}))
        item.itemCount.should.equal 2
      it 'アイテム追加確認', ->
        r = item.container.addCheck(new rpg.Item({name:'Item02'}))
        r.should.equal false
    describe 'スタックアイテム', ->
      c = null
      it '５種類入るスタックコンテナに', ->
        c = new rpg.Item({name:'コンテナアイテム',container:{max:5,stack:true}})
        c.itemCount.should.equal 0
      it '同名のスタック５アイテムを６個追加する', ->
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
      it 'アイテムリストは２つになる', ->
        c.itemlistCount.should.equal 2
