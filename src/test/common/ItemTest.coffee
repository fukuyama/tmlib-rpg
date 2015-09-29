
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/ItemContainer.coffee')
require('../../main/common/Effect.coffee')

describe 'rpg.Item', ->
  item = null
  item1 = null
  item2 = null
  rpg.system = rpg.system ? {}
  rpg.system.temp = rpg.system.temp ? {}

  describe '基本属性', ->
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
    it 'ヘルプは空', ->
      item.help.should.equal ''
    it 'セーブロード', ->
      json = rpg.utils.createJsonData(item)
      item = rpg.utils.createRpgObject(json)
      item.name.should.equal 'Name00'
      item.price.should.equal 100
  describe 'ヘルプテキスト', ->
    it 'アイテムの初期化', ->
      item = new rpg.Item(
        url: '001'
        help: 'help001'
      )
      item2 = new rpg.Item(
        url: '002'
        help: 'help002'
      )
    it 'ヘルプテキスト取得', ->
      (item instanceof rpg.Item).should.equal true
      item.help.should.equal 'help001'
    it 'セーブロード', ->
      json = rpg.utils.createJsonData(item)
      obj = JSON.parse(json)
      obj.d.url.should.equal '001'
      (obj.d.help?).should.equal false
      item = rpg.utils.createRpgObject(json)
      (item instanceof rpg.Item).should.equal true
      item.url.should.equal '001'
      item.help.should.equal 'help001'
  describe 'ログメッセージテキスト', ->
    it 'アイテムの初期化', ->
      item = new rpg.Item(
        url: '001'
        help: 'help001'
        message: 'message001'
      )
      item2 = new rpg.Item(
        url: '002'
        help: 'help002'
        message: 'message002'
      )
    it 'テキスト取得', ->
      (item instanceof rpg.Item).should.equal true
      item.message.should.equal 'message001'
      item2.message.should.equal 'message002'
    it 'セーブロード', ->
      json = rpg.utils.createJsonData(item)
      obj = JSON.parse(json)
      obj.d.url.should.equal '001'
      (obj.d.message?).should.equal false
      item = rpg.utils.createRpgObject(json)
      (item instanceof rpg.Item).should.equal true
      item.url.should.equal '001'
      item.message.should.equal 'message001'
  describe '使えるかどうか調べる', ->
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
      it '初期化', ->
        item = new rpg.Item({name:'Item01',container:{}})
        (item is undefined).should.equal false
        item.name.should.equal 'Item01'
      it 'アイテム追加', ->
        item.addItem(new rpg.Item({name:'Item02'}))
      it 'アイテム取得', ->
        item.getItem(0).name.should.equal 'Item02'
      it 'アイテム取得全部', ->
        item.eachItem (item) ->
          item.name.should.equal 'Item02'
      it 'アイテム名で取得', ->
        item.getItem('Item02').name.should.equal 'Item02'
      it 'アイテム数確認', ->
        item.itemCount.should.equal 1
      it 'アイテム取得失敗', ->
        (item.getItem(1) is undefined).should.equal true
      it 'アイテム名で取得失敗', ->
        (item.getItem('xxxx') is undefined).should.equal true
      it '関係ないアイテム削除は失敗', ->
        r = item.removeItem(new rpg.Item(name:'Item02'))
        r.should.equal false
        item.itemCount.should.equal 1
      it 'アイテム削除', ->
        r = item.removeItem(item.getItem(0))
        r.should.equal true
        item.itemCount.should.equal 0
      it 'さらにアイテム削除は失敗', ->
        r = item.removeItem(item)
        r.should.equal false
        item.itemCount.should.equal 0
    describe 'コンテナタイプを指定する', ->
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
        r = item._container.addCheck(new rpg.Item({name:'Item02'}))
        r.should.equal false
      it 'セーブロード', ->
        json = rpg.utils.createJsonData(item)
        item = rpg.utils.createRpgObject(json)
        r = item._container.addCheck(new rpg.Item({name:'Item02'}))
        r.should.equal false
        item.itemCount.should.equal 2
      it 'アイテムクリア', ->
        item.itemCount.should.equal 2
        item.clearItem()
        item.itemCount.should.equal 0
    describe 'スタックアイテム', ->
      c = null
      it '５種類入るスタックコンテナに', ->
        c = new rpg.Item({name:'コンテナアイテム',container:{max:5,stack:true}})
        c.itemCount.should.equal 0
      it '同名のスタック５アイテムを６個追加する', ->
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.itemlistCount.should.equal 1
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.itemlistCount.should.equal 1
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.itemlistCount.should.equal 1
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.itemCount.should.equal 6
      it 'アイテムリストは２つになる', ->
        c.itemlistCount.should.equal 2
      it 'アイテム１つ削除するとアイテムリストは１つになる', ->
        c.removeItem(c.getItem(0))
        c.itemCount.should.equal 5
        c.itemlistCount.should.equal 1
      it 'アイテム１つ追加アイテムリストは２つになる', ->
        c.addItem new rpg.Item(name:'Item01',stack:true,maxStack:5)
        c.itemlistCount.should.equal 2
      it '中身チェック', ->
        c._container.items[0].constructor.name.should.equal 'Item'
        c.getItem('Item01').name.should.equal 'Item01'
      it 'セーブロード', ->
        json = rpg.utils.createJsonData(c)
        t = rpg.utils.createRpgObject(json)
        t.itemCount.should.equal 6
        t.itemlistCount.should.equal 2
