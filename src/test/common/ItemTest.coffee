
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Item.coffee')

describe 'rpg.Item', ->
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
