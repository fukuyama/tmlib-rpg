require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Enemy.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/UsableCounter.coffee')
require('../../main/common/ItemContainer.coffee')

require('../../main/common/Skill.coffee')
require('../../main/common/Effect.coffee')

require('../../test/common/System.coffee')

require('../../main/common/ai/RandomAI.coffee')

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.EnemyTest', () ->
  enemy = null
  item = null
  describe 'ＤＢ初期化', ->
    it 'load', (done) ->
      rpg.system.db.preloadSkill [0,1], (skills) -> done()

  describe 'エネミーー生成', ->
    it '生成するとデフォルト値で初期化される', ->
      enemy = new rpg.Enemy()
    it '初期化されている', ->
      enemy.str.should.equal 10
      enemy.vit.should.equal 10
      enemy.dex.should.equal 10
      enemy.agi.should.equal 10
      enemy.int.should.equal 10
      enemy.sen.should.equal 10
      enemy.luc.should.equal 10
      enemy.cha.should.equal 10
      enemy.basehp.should.equal 10
      enemy.basemp.should.equal 10
    it 'セーブロード', ->
      enemy = new rpg.Enemy(base:{str:11})
      json = rpg.utils.createJsonData(enemy)
      a = rpg.utils.createRpgObject(json)
      a.str.should.equal 11
      a.vit.should.equal 10
      a.dex.should.equal 10
      a.agi.should.equal 10
      a.int.should.equal 10
      a.sen.should.equal 10
      a.luc.should.equal 10
      a.cha.should.equal 10
      a.basehp.should.equal 10
      a.basemp.should.equal 10
