require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/UsableItem.coffee')
require('../../main/common/ItemContainer.coffee')

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Actor', () ->
  describe 'アクター生成', ->
    actor = null
    it '生成するとデフォルト値で初期化される', ->
      actor = new rpg.Actor()
    it '初期化されている', ->
      actor.str.should.equal 10
      actor.vit.should.equal 10
      actor.dex.should.equal 10
      actor.agi.should.equal 10
      actor.int.should.equal 10
      actor.sen.should.equal 10
      actor.luc.should.equal 10
      actor.cha.should.equal 10
      actor.minhp.should.equal 10
      actor.minmp.should.equal 10
  describe 'プロパティ', ->
    describe 'jobプロパティ', ->
      actor = null
      it 'getter/setter/defaultがある', ->
        actor = new rpg.Actor()
      it 'default', ->
        actor.job.should.equal '（なし）'
      it 'setter', ->
        actor.job = '冒険者'
      it 'getter', ->
        actor.job.should.equal '冒険者'
      it 'setter', ->
        actor.job = null
      it 'default', ->
        actor.job.should.equal '（なし）'
    describe 'subjobプロパティ', ->
      actor = null
      it 'getter/setter/defaultがある', ->
        actor = new rpg.Actor()
      it 'default', ->
        actor.subjob.should.equal '（なし）'
      it 'setter', ->
        actor.subjob = '料理人'
      it 'getter', ->
        actor.subjob.should.equal '料理人'
      it 'setter', ->
        actor.subjob = null
      it 'default', ->
        actor.subjob.should.equal '（なし）'
  describe 'アイテム操作関連', ->
    actor = null
    item = null
    it '１２個入るバックパックで初期化（デフォルトで入れ物を持っている）', ->
      actor = new rpg.Actor(backpack:{max:12})
    it '最初は空', ->
      # バックパック
      actor.backpack.itemCount.should.equal 0
    it '１つ入れる', ->
      # バックパック
      item = new rpg.Item(name:'Item01')
      actor.backpack.addItem item
      actor.backpack.itemCount.should.equal 1
    it '１つ捨てる', ->
      actor.backpack.removeItem item
      actor.backpack.itemCount.should.equal 0
  describe 'アイテムを使う', ->
    actor = null
    item = null
    it '消費型アイテムを使用するとアイテムがなくなる', ->
      actor = new rpg.Actor(backpack:{max:12})
    it '１つ入れる', ->
      # バックパック
      item = new rpg.UsableItem(name:'Item01',lost:{max:1})
      item.effect = () -> true
      actor.backpack.addItem item
      actor.backpack.itemCount.should.equal 1
    it 'アイテムを使う', ->
      target = new rpg.Actor()
      actor.useItem item, [target]
      actor.backpack.itemCount.should.equal 0
