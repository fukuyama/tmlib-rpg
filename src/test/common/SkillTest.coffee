require('chai').should()

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

require('../../test/common/System.coffee')

SCOPE = rpg.constants.SCOPE

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

  skills =
    attack: new rpg.Skill
      name: '攻撃'
      scope:
        type: SCOPE.TYPE.ENEMY
        range: SCOPE.RANGE.ONE
      target:
        effects: [
          {hpdamage:[['user.patk','/',2],'-',['target.pdef','/',4]],attrs:['物理','武器']}
        ]
  skill = null
  user = null
  targets = null

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
        atkcx.targets[0].hpdamage.should.equal 3.75
        atkcx.targets[0].attrs[0].should.equal '物理'
      it 'セーブロード', ->
        json = rpg.utils.createJsonData(skill)
        skill = rpg.utils.createRpgObject(json)
        skill = skills['attack']
        atkcx = skill.effect user,targets
        user.patk.should.equal 15
        targets[0].pdef.should.equal 15
        atkcx.targets[0].hpdamage.should.equal 3.75
        atkcx.targets[0].attrs[0].should.equal '物理'
        jsontest = rpg.utils.createJsonData(skill)
        jsontest.should.equal json
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
        atkcx.targets[0].hpdamage.should.equal 8.75
        atkcx.targets[0].attrs[0].should.equal '物理'
      it 'セーブロード', ->
        json = rpg.utils.createJsonData(skill)
        skill = rpg.utils.createRpgObject(json)
        skill = skills['attack']
        atkcx = skill.effect user,targets
        user.patk.should.equal 25
        targets[0].pdef.should.equal 15
        atkcx.targets[0].hpdamage.should.equal 8.75
        atkcx.targets[0].attrs[0].should.equal '物理'
        jsontest = rpg.utils.createJsonData(skill)
        jsontest.should.equal json
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
        atkcx.targets[0].hpdamage.should.equal 6.25
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
        atkcx.targets[0].hpdamage.should.equal 6.25
        atkcx.targets[0].attrs.length.should.equal 3
        atkcx.targets[0].attrs[0].should.equal '物理'
        atkcx.targets[0].attrs[1].should.equal '武器'
        atkcx.targets[0].attrs[2].should.equal '炎'

  describe '回復スキル', ->
    describe '単体回復', ->
      it '回復量１０の単体回復スキル', ->
        skill = new rpg.Skill
          scope:
            type: SCOPE.TYPE.FRIEND
            range: SCOPE.RANGE.ONE
          user:
            effects:[
              {mp: -5}
            ]
          target:
            effects:[
              {hp: 10}
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
        user.mp.should.equal user.maxmp - 5
        target.hp.should.equal target.maxhp - 1
    describe '全体回復', ->
      it '回復量１０の全体回復スキル', ->
        skill = new rpg.Skill
          scope:
            type: SCOPE.TYPE.FRIEND
            range: SCOPE.RANGE.MULTI
          user:
            effects:[
              {mp: -2}
            ]
          target:
            effects:[
              {hp: 10}
            ]
      it '１１ダメージを受けてるので１０回復する', ->
        user = new rpg.Actor(name:'user')
        target1 = new rpg.Actor(name:'target1')
        target1.hp -= 11
        target2 = new rpg.Actor(name:'target2')
        target2.hp -= 12
        log = {}
        r = skill.effectApply user, [target1,target2], log
        r.should.equal true
        user.mp.should.equal user.maxmp - 2
        target1.hp.should.equal target1.maxhp - 1
        target2.hp.should.equal target2.maxhp - 2
