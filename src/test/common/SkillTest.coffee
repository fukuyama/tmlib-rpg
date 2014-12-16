require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/State.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Skill.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/UsableItem.coffee')
require('../../main/common/ItemContainer.coffee')
require('../../main/common/EquipItem.coffee')
require('../../main/common/Weapon.coffee')
require('../../main/common/Armor.coffee')
require('../../main/common/Effect.coffee')

SKILL_SCOPE = rpg.constants.SKILL_SCOPE

TEST_STATES = {
  '武器攻撃時炎': new rpg.State {
    name: '武器攻撃時炎'
    attrs: [
      {attack:{attr:'炎',cond:'武器'}}
    ]
  }
}

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Skill', ->
  rpg.system = rpg.system ? {}
  rpg.system.db = {}
  skills =
    attack: new rpg.Skill
      name: '攻撃'
      scope:
        type: SKILL_SCOPE.TYPE.ENEMY
        range: SKILL_SCOPE.RANGE.ONE
      target:
        effects: [
          {hp:[['user.patk','/',2],'-',['target.pdef','/',4]],attrs:['物理','武器']}
        ]
  skill = null

  describe '攻撃', ->
    describe '通常攻撃', ->
      it '素手', ->
        user = new rpg.Actor(name:'user',team:'a')
        targets = [
          new rpg.Actor(name:'target1',team:'b')
        ]
        skill = skills['attack']
        atkcx = skill.effect user,targets
        user.patk.should.equal 15
        targets[0].pdef.should.equal 15
        atkcx.targets[0].hp.should.equal 3.75
        atkcx.targets[0].attrs[0].should.equal '物理'
      it '武器装備時', ->
        user = new rpg.Actor(name:'user',team:'a')
        user.weapon = new rpg.Weapon
          name: 'Weapon001'
          patk: 10
        targets = [
          new rpg.Actor(name:'target1',team:'b')
        ]
        skill = skills['attack']
        atkcx = skill.effect user,targets
        user.patk.should.equal 25
        targets[0].pdef.should.equal 15
        atkcx.targets[0].hp.should.equal 8.75
        atkcx.targets[0].attrs[0].should.equal '物理'
      it '武器防具装備時', ->
        user = new rpg.Actor(name:'user',team:'a')
        user.weapon = new rpg.Weapon
          name: 'Weapon001'
          patk: 10
        targets = [
          new rpg.Actor(name:'target1',team:'b')
        ]
        targets[0].upper_body = new rpg.Armor
          name: 'Armor001'
          pdef: 10
          equips: ['upper_body']
        skill = skills['attack']
        atkcx = skill.effect user,targets
        user.patk.should.equal 25
        targets[0].pdef.should.equal 25
        atkcx.targets[0].hp.should.equal 6.25
        atkcx.targets[0].attrs[0].should.equal '物理'
    describe '属性攻撃', ->
      it '武器防具装備時(炎属性武器)', ->
        rpg.system.db.state = (name) -> TEST_STATES[name]
        user = new rpg.Actor(name:'user',team:'a')
        user.weapon = new rpg.Weapon
          name: 'Weapon001'
          patk: 10
          states: ['武器攻撃時炎']
        targets = [
          new rpg.Actor(name:'target1',team:'b')
        ]
        targets[0].upper_body = new rpg.Armor
          name: 'Armor001'
          pdef: 10
          equips: ['upper_body']
        skill = skills['attack']
        atkcx = skill.effect user,targets
        user.patk.should.equal 25
        targets[0].pdef.should.equal 25
        atkcx.targets[0].hp.should.equal 6.25
        atkcx.targets[0].attrs.length.should.equal 3
        atkcx.targets[0].attrs[0].should.equal '物理'
        atkcx.targets[0].attrs[1].should.equal '武器'
        atkcx.targets[0].attrs[2].should.equal '炎'

  describe '回復スキル', ->
    describe '単体回復', ->
      it '回復量１０の単体回復スキル', ->
        skill = new rpg.Skill
          scope:
            type: SKILL_SCOPE.TYPE.FRIEND
            range: SKILL_SCOPE.RANGE.ONE
          user:
            effects:[
              {map: 2}
            ]
          target:
            effects:[
              {hp: -10}
            ]
      it '１１ダメージを受けてるので１０回復する', ->
        user = new rpg.Actor(name:'user')
        target = new rpg.Actor(name:'target')
        target.hp.should.equal target.maxhp
        target.hp -= 11
        target.hp.should.equal target.maxhp - 11
        log = {}
        r = skill.effectApply user, [target], log
        r.should.equal true
        target.hp.should.equal target.maxhp - 1
