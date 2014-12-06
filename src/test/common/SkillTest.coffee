require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/State.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Effect.coffee')
require('../../main/common/Skill.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/UsableItem.coffee')
require('../../main/common/ItemContainer.coffee')

SKILL_SCOPE = rpg.constants.SKILL_SCOPE

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Skill', ->

  describe '通常攻撃', ->
    it '素手', ->
      user = new rpg.Actor(name:'user',team:'a')
      targets = []
      target = new rpg.Actor(name:'target1',team:'b')
      target.hp -= 10
      targets.push target
      skill = new rpg.Skill(
        name: '攻撃'
        scope:{
          type: SKILL_SCOPE.TYPE.ENEMY
          range: SKILL_SCOPE.RANGE.ONE
        }
        target:
          effects: [
            {hp:[['user.patk','*',4],'-',['target.pdef','*',2]],attrs:['物理']}
          ]
      )
      log = {}
      atkcx = skill.effect user,[target],log
      atkcx.targets[0].hp.should.equals (user.patk * 4 - target.pdef * 2)

  describe.skip '回復スキル', ->
    it 'HPを１０回復する１度使えるアイテム', ->
      item = new rpg.Skill(
        target:
          effects:[
            {hp: -10}
          ]
      )
      item.isLost().should.equal false
    it '１１ダメージを受けてるので１０回復する', ->
      user = new rpg.Actor(name:'user')
      target = new rpg.Actor(name:'target')
      target.hp.should.equal target.maxhp
      target.hp -= 11
      target.hp.should.equal target.maxhp - 11
      r = item.use user, target
      r.should.equal true
      target.hp.should.equal target.maxhp - 1
