chai = require('chai')
chai.should()
assert = chai.assert

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/State.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Skill.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/UsableCounter.coffee')
require('../../main/common/ItemContainer.coffee')
require('../../main/common/EquipItem.coffee')
require('../../main/common/Weapon.coffee')
require('../../main/common/Armor.coffee')
require('../../main/common/Effect.coffee')

SKILL_SCOPE = rpg.constants.SKILL_SCOPE

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'Skill Data', ->

  describe '攻撃', ->
    describe '通常攻撃', ->
      it '素手', ->
        user = new rpg.Actor(name:'user',team:'a')
        targets = [
          new rpg.Actor(name:'target1',team:'b')
        ]
        skill = new rpg.Skill require('../../data/test/skill/001.coffee')
        atkcx = skill.effect user,targets
        user.patk.should.equal 15
        targets[0].pdef.should.equal 15
        damage = Math.round atkcx.targets[0].hpdamage
        damage.should.equal 4
        atkcx.targets[0].attrs[0].should.equal '物理'
