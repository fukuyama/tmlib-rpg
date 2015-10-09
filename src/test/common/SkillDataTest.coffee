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
  skilllist = [require('../../data/test/skill/001.coffee')]
  skilllist = skilllist.concat require('../../data/test/skilllist.coffee')
  
  describe '攻撃', ->
    describe '通常攻撃', ->
      it '素手', ->
        user = new rpg.Actor(name:'user',team:'a')
        targets = [
          new rpg.Actor(name:'target1',team:'b')
        ]
        skill = new rpg.Skill skilllist[0]
        atkcx = skill.effect user,targets
        user.patk.should.equal 15
        targets[0].pdef.should.equal 15
        damage = Math.round atkcx.targets[0].hpdamage
        damage.should.equal 4
        atkcx.targets[0].attrs[0].should.equal '物理'

  describe '魔法', ->
    describe '回復', ->
      it '単体回復', ->
        user = new rpg.Actor(name:'user',team:'a')
        skill = new rpg.Skill skilllist[1]
        user.mcur.should.equal 15
        cx = skill.effect user, [user]
        (31 < cx.targets[0].hp and cx.targets[0].hp < 37).should.equal true, "hp=#{cx.targets[0].hp}"
        cx.user.mp.should.equal -4, "user.mp"
