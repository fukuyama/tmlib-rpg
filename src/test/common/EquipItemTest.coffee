require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/State.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/ItemContainer.coffee')
require('../../main/common/EquipItem.coffee')
require('../../main/common/Effect.coffee')

describe 'rpg.EquipItem', ->
  item = null
  describe '基本', ->
    it 'init', ->
      item = new rpg.EquipItem name: 'EquipItem001'
      item.name.should.equal 'EquipItem001'
      item.equip.should.equal true
    it 'ability', ->
      item = new rpg.EquipItem
        name: 'EquipItem001'
        abilities: [
          {str:{type:'fix',val:10}}
        ]
      n = item.ability base:5, ability:'str'
      n.should.equal 10
    it '攻撃力設定', ->
      item = new rpg.EquipItem
        name: 'EquipItem001'
        patk: 50
      item.patk.should.equal 50
      item.str.should.equal 0
      item.price.should.equal 2500
    it '力アップ', ->
      item = new rpg.EquipItem
        name: 'EquipItem001'
        patk: 50
        str: 10
      item.patk.should.equal 50
      item.str.should.equal 10
  describe '装備可能判定', ->
    describe '１か所', ->
      it '装備場所チェック', ->
        item = new rpg.EquipItem
          name: 'EquipItem001'
          patk: 50
          equips: ['head']
      it '頭には装備可能', ->
        r = item.checkEquips 'head'
        r.should.equal true
      it '頭には装備可能', ->
        r = item.checkEquips ['head']
        r.should.equal true
      it '足には装備不可', ->
        r = item.checkEquips 'legs'
        r.should.equal false
      it '足には装備不可', ->
        r = item.checkEquips ['legs']
        r.should.equal false
      it '頭と足には装備不可', ->
        r = item.checkEquips ['head','legs']
        r.should.equal false
    describe '２か所', ->
      it '装備場所チェック（リスト）', ->
        item = new rpg.EquipItem
          name: 'EquipItem001'
          patk: 50
          equips: ['left_hand','right_hand']
      it '頭には装備不可', ->
        r = item.checkEquips 'head'
        r.should.equal false
      it '頭には装備不可', ->
        r = item.checkEquips ['head']
        r.should.equal false
      it '左手のみには装備不可', ->
        r = item.checkEquips 'left_hand'
        r.should.equal false
      it '左手のみには装備不可', ->
        r = item.checkEquips ['left_hand']
        r.should.equal false
      it '頭と足には装備不可', ->
        r = item.checkEquips ['head','legs']
        r.should.equal false
      it '両手なら装備可能', ->
        r = item.checkEquips ['left_hand','right_hand']
        r.should.equal true
    describe '装備可能条件', ->
      it '装備可能条件なしは、装備可能と判断', ->
        item = new rpg.EquipItem
          name: 'EquipItem001'
          patk: 50
          equips: ['left_hand','right_hand']
        battler = new rpg.Battler base:{str: 10}
        r = item.checkRequired battler
        r.should.equal true
      it 'str が 10 以上じゃないとダメ', ->
        item = new rpg.EquipItem
          name: 'EquipItem001'
          patk: 50
          equips: ['left_hand','right_hand']
          required: [
            ['str', '>=', 10]
          ]
        battler = new rpg.Battler base:{str: 10}
        battler.str.should.equal 10
        r = item.checkRequired battler
        r.should.equal true
        battler = new rpg.Battler base:{str: 9}
        battler.str.should.equal 9
        r = item.checkRequired battler
        r.should.equal false
      it 'str が 10 以上 vit が 5以下じゃないとダメ', ->
        item = new rpg.EquipItem
          name: 'EquipItem001'
          patk: 50
          equips: ['left_hand','right_hand']
          required: [
            ['str', '>=', 10]
            ['vit', '<=', 5]
          ]
        battler = new rpg.Battler base:{str: 10,vit:5}
        r = item.checkRequired battler
        r.should.equal true
        battler = new rpg.Battler base:{str: 10,vit:6}
        r = item.checkRequired battler
        r.should.equal false
