require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Item.coffee')
require('../../main/common/UsableCounter.coffee')
require('../../main/common/ItemContainer.coffee')
require('../../main/common/Effect.coffee')

{
  USABLE
} = rpg.constants

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Actor', () ->
  json = null
  actor = null
  item = null
  describe 'アクター生成', ->
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
      actor.basehp.should.equal 10
      actor.basemp.should.equal 10
    it 'セーブロード', ->
      actor = new rpg.Actor(base:{str:11})
      json = rpg.utils.createJsonData(actor)
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
  describe 'プロパティ', ->
    describe 'jobプロパティ', ->
      it 'getter/setter/defaultがある', ->
        actor = new rpg.Actor()
      it 'default', ->
        actor.job.should.equal '（なし）'
      it 'setter', ->
        actor.job = '冒険者'
      it 'getter', ->
        actor.job.should.equal '冒険者'
      it 'セーブロード(冒険者)', ->
        json = rpg.utils.createJsonData(actor)
        a = rpg.utils.createRpgObject(json)
        a.job.should.equal '冒険者'
      it 'setter', ->
        actor.job = null
      it 'default', ->
        actor.job.should.equal '（なし）'
      it 'セーブロード(なし)', ->
        json = rpg.utils.createJsonData(actor)
        a = rpg.utils.createRpgObject(json)
        a.job.should.equal '（なし）'
    describe 'subjobプロパティ', ->
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
    describe 'プロパティ操作', ->
      it 'hpの増減', ->
        actor = new rpg.Actor()
        actor.hp.should.equal actor.maxhp
        actor.hp -= 10
        actor.hp.should.equal actor.maxhp - 10
      it 'hpの増減 maxhp 以上にはできない', ->
        actor.hp.should.equal actor.maxhp - 10
        actor.hp += 20
        actor.hp.should.equal actor.maxhp
  describe 'アイテム操作関連', ->
    describe '１つ追加して捨てる', ->
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
      it 'セーブロード', ->
        json = rpg.utils.createJsonData(actor)
        a = rpg.utils.createRpgObject(json)
        (a.backpack instanceof rpg.Item).should.equal true, 'backpack Item check'
        (a.backpack._container instanceof rpg.ItemContainer).should.equal true, 'ItemContainer check'
        a.backpack.itemCount.should.equal 1
        jsontest = rpg.utils.createJsonData(a)
        jsontest.should.equal json
      it '１つ捨てる', ->
        actor.backpack.removeItem item
        actor.backpack.itemCount.should.equal 0
    describe '沢山追加', ->
      it '１２個入るバックパックで初期化（デフォルトで入れ物を持っている）', ->
        actor = new rpg.Actor(backpack:{max:12,stack:on})
      it '最初は空', ->
        actor.backpack.itemCount.should.equal 0
      it '５こ入れる', ->
        for i in [0 ... 5]
          actor.backpack.addItem new rpg.Item(name:'Item01')
        actor.backpack.itemCount.should.equal 5
        actor.backpack.itemlistCount.should.equal 5
      it 'スタックアイテムを５こ入れる', ->
        for i in [0 ... 5]
          actor.backpack.addItem new rpg.Item(name:'Item02',stack:on)
        actor.backpack.itemCount.should.equal 10
        actor.backpack.itemlistCount.should.equal 6
      it '追加で６こ入れる', ->
        for i in [0 ... 6]
          actor.backpack.addItem new rpg.Item(name:'Item03')
        actor.backpack.itemCount.should.equal 16
        actor.backpack.itemlistCount.should.equal 12
      it '追加で１こが入らない', ->
        r = actor.backpack.addItem new rpg.Item(name:'Item04')
        r.should.equal false
        actor.backpack.itemCount.should.equal 16
        actor.backpack.itemlistCount.should.equal 12
      it 'スタックアイテムは追加できる', ->
        r = actor.backpack.addItem new rpg.Item(name:'Item02',stack:on)
        r.should.equal true
        actor.backpack.itemCount.should.equal 17
        actor.backpack.itemlistCount.should.equal 12
      it '削除したら追加で１こが入る（スタック不可アイテム）', ->
        item = actor.backpack.getItem 'Item01'
        item.name.should.equal 'Item01'
        r = actor.backpack.removeItem item
        r.should.equal true
        actor.backpack.itemCount.should.equal 16
        actor.backpack.itemlistCount.should.equal 11
        r = actor.backpack.addItem new rpg.Item(name:'Item05')
        r.should.equal true
        actor.backpack.itemCount.should.equal 17
        actor.backpack.itemlistCount.should.equal 12
  describe 'アイテムを使う', ->
    describe '消費型アイテムを使用するとアイテムがなくなる', ->
      it '１つ入れる', ->
        actor = new rpg.Actor(backpack:{max:12})
        item = new rpg.Item(name:'Item01',lost:{max:1},usable: USABLE.ALL)
        item.effectApply = () -> true
        actor.backpack.addItem item
        actor.backpack.itemCount.should.equal 1
      it 'アイテムを使うとなくなる', ->
        target = new rpg.Actor()
        item = actor.backpack.getItem 'Item01'
        actor.useItem item, [target]
        actor.backpack.itemCount.should.equal 0
    describe '２回で消費するアイテムを２回使用するとアイテムがなくなる', ->
      it '１つ入れる', ->
        actor = new rpg.Actor(backpack:{max:12})
        item = new rpg.Item(name:'Item01',lost:{max:2},usable: USABLE.ALL)
        item.effectApply = () -> true
        actor.backpack.addItem item
        actor.backpack.itemCount.should.equal 1
      it '１回目は使用しても減らない', ->
        target = new rpg.Actor()
        item = actor.backpack.getItem 'Item01'
        actor.useItem item, [target]
        actor.backpack.itemCount.should.equal 1
      it '２回目に使用すると減る', ->
        target = new rpg.Actor()
        item = actor.backpack.getItem 'Item01'
        actor.useItem item, [target]
        actor.backpack.itemCount.should.equal 0
    describe '２回で消費するアイテムでスタック可能だと問題がある', ->
      it '２つ入れる', ->
        actor = new rpg.Actor(backpack:{max:12})
        item = new rpg.Item(name:'Item01',lost:{max:2},stack:true,usable: USABLE.ALL)
        item.effectApply = () -> true
        actor.backpack.addItem item
        actor.backpack.itemCount.should.equal 1
        actor.backpack.itemlistCount.should.equal 1
        item = new rpg.Item(name:'Item01',lost:{max:2},stack:true,usable: USABLE.ALL)
        item.effectApply = () -> true
        actor.backpack.addItem item
        actor.backpack.itemCount.should.equal 2
        actor.backpack.itemlistCount.should.equal 1
      it '効果が無い場合は減らない', ->
        target = new rpg.Actor()
        item = actor.backpack.getItem 'Item01'
        item.effectApply = () -> false # デバックのため一時的に効果なし
        actor.useItem item, [target]
        actor.backpack.itemCount.should.equal 2
        actor.backpack.itemlistCount.should.equal 1
        item.effectApply = () -> true # もどし
      it '１回目は使用しても減らない', ->
        target = new rpg.Actor()
        item = actor.backpack.getItem 'Item01'
        actor.useItem item, [target]
        actor.backpack.itemCount.should.equal 2
        actor.backpack.itemlistCount.should.equal 1
      it '２回目に使用すると減る', ->
        target = new rpg.Actor()
        item = actor.backpack.getItem 'Item01'
        actor.useItem item, [target]
        actor.backpack.itemCount.should.equal 1
        actor.backpack.itemlistCount.should.equal 1
      it 'まだあるので使ってみる', ->
        target = new rpg.Actor()
        item = actor.backpack.getItem 'Item01'
        actor.useItem item, [target]
        actor.backpack.itemCount.should.equal 1
        actor.backpack.itemlistCount.should.equal 1
      it '残り１こで残使用量１を使う（なくなる）', ->
        target = new rpg.Actor()
        item = actor.backpack.getItem 'Item01'
        actor.useItem item, [target]
        actor.backpack.itemCount.should.equal 0
        actor.backpack.itemlistCount.should.equal 0
