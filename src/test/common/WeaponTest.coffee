require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/State.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/ItemContainer.coffee')
require('../../main/common/EquipItem.coffee')
require('../../main/common/Weapon.coffee')
require('../../main/common/Effect.coffee')

describe 'rpg.Weapon', ->
  it 'init', ->
    item = new rpg.Weapon name: 'Weapon001'
    item.name.should.equal 'Weapon001'
    item.equip.should.equal true
  it 'ability', ->
    item = new rpg.Weapon
      name: 'Weapon001'
      abilities: [
        {str:{type:'fix',val:10}}
      ]
    n = item.ability base:5, ability:'str'
    n.should.equal 10
  it '攻撃力設定', ->
    item = new rpg.Weapon
      name: 'Weapon001'
      patk: 50
    item.patk.should.equal 50
