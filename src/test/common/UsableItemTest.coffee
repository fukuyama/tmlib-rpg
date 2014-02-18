
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/UsableItem.coffee')

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
    it 'アイテムの初期化', ->
      item = new rpg.UsableItem(lost:'count',lostParams:1)
      item.effect = () -> true
    it '使う', ->
      user = new rpg.Actor()
      target = new rpg.Actor()
      # Actor,Actor
      item.use user, target
