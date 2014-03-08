
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/ItemContainer.coffee')
require('../../main/common/UsableItem.coffee')

ITEM_SCOPE = rpg.constants.ITEM_SCOPE

describe 'rpg.UsableItem', ->
  rpg.system = rpg.system ? {}
  rpg.system.temp = rpg.system.temp ? {}

  describe '基本属性', ->
    item = null
    it 'アイテムの初期化', ->
      item = new rpg.UsableItem()
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
  describe 'アイテムを使う', ->
    item = null
    it '１回使用するとなくなるアイテム', ->
      item = new rpg.UsableItem(lost:{max:1})
      item.effect = () -> true
      item.isLost().should.equal false
    it 'アイテムを使用する', ->
      user = new rpg.Actor()
      target = new rpg.Actor()
      r = item.use user, target
      r.should.equal true
    it 'アイテムがロスト', ->
      item.isLost().should.equal true
