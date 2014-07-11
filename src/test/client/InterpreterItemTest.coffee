# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Item)', () ->
  interpreter = null
  @timeout(10000)
  describe 'アイテム関連のイベント', ->
    describe '個別のアイテム操作', ->
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 0
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it '１番目のアクターにアイテムを渡す', (done) ->
        interpreter.start [
          {type:'gain_item',params:[1,1,0]}
          {type:'function',params:[done]}
        ]
      it '１番目のアクターのアイテムが増える', ->
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
      it '２番目のアクターにアイテムを渡す', (done) ->
        interpreter.start [
          {type:'gain_item',params:[{item:1,actor:1}]}
          {type:'function',params:[done]}
        ]
      it '２番目のアクターのアイテムが増える', ->
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 1
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
      it 'パーティの袋にアイテムを入れる', (done) ->
        interpreter.start [
          {type:'gain_item',params:[{item:2,num:2,backpack:0}]}
          {type:'function',params:[done]}
        ]
      it 'パーティの袋のアイテムが増える', ->
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 1
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
        backpack = rpg.game.party.backpack
        backpack.itemCount.should.equal 2
      it 'パーティの袋のアイテムを削除', (done) ->
        interpreter.start [
          {type:'lost_item',params:[{item:2,backpack:0}]}
          {type:'function',params:[done]}
        ]
      it 'パーティの袋のアイテムが減る', ->
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 1
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
        backpack = rpg.game.party.backpack
        backpack.itemCount.should.equal 1
      it '２番目のアクターのアイテムを捨てる', (done) ->
        interpreter.start [
          {type:'lost_item',params:[{item:1,actor:1}]}
          {type:'function',params:[done]}
        ]
      it '２番目のアクターのアイテムが減る', ->
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
        backpack = rpg.game.party.backpack
        backpack.itemCount.should.equal 1
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
      it 'すべて削除する', (done) ->
        interpreter.start [
          {type:'clear_item',params:[]}
          {type:'function',params:[done]}
        ]
      it '全て削除される', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 0
    describe 'パーティアイテム操作', ->
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'アイテムを１つ増やす', (done) ->
        interpreter.start [
          {type:'gain_item',params:[{item:2}]}
          {type:'function',params:[done]}
        ]
      it '先頭プレイヤーのアイテムが１つ増える', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
      it 'もうアイテムを１つ増やす', (done) ->
        interpreter.start [
          {type:'gain_item',params:[2]}
          {type:'function',params:[done]}
        ]
      it '先頭プレイヤーのアイテムが２つになる', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 2
      it 'アイテムを１０こ増やす', (done) ->
        interpreter.start [
          {type:'gain_item',params:[1,10]}
          {type:'function',params:[done]}
        ]
      it '先頭プレイヤーが８こ、２番目が４こ', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 4
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 8
      it '増やしたアイテムを削除する', (done) ->
        interpreter.start [
          {type:'lost_item',params:[2]}
          {type:'function',params:[done]}
        ]
      it '先頭プレイヤーのアイテムが減る', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 4
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 7
      it '増やしたアイテムを削除する（複数）', (done) ->
        interpreter.start [
          {type:'lost_item',params:[1,7]}
          {type:'function',params:[done]}
        ]
      it '合計で７つ減る', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 3
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
      it 'アイテムを2こ増やす', (done) ->
        interpreter.start [
          {type:'gain_item',params:[{item:2,num:2}]}
          {type:'function',params:[done]}
        ]
      it '２こ増えている', ->
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 3
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 3
      it 'すべて削除する', (done) ->
        interpreter.start [
          {type:'clear_item',params:[]}
          {type:'function',params:[done]}
        ]
      it '全て削除される', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 0