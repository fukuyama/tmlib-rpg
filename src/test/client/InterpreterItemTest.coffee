# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Item)', () ->
  interpreter = null
  @timeout(10000)
  describe 'アイテム関連のイベント', ->
    describe 'パーティアイテム操作', ->
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it 'アイテムを１つ増やす', (done) ->
        interpreter.start [
          {type:'item',params:['add',2]}
        ]
        setTimeout(done,500)
      it '先頭プレイヤーのアイテムが１つ増える', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 1
      it 'もうアイテムを１つ増やす', (done) ->
        interpreter.start [
          {type:'item',params:['add',2]}
        ]
        setTimeout(done,500)
      it '先頭プレイヤーのアイテムが２つになる', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 2
      it 'アイテムを１０こ増やす', (done) ->
        interpreter.start [
          {type:'item',params:['add',1,10]}
        ]
        setTimeout(done,500)
      it '先頭プレイヤーが８こ、２番目が４こ', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 4
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 8
      it '増やしたアイテムを削除する', (done) ->
        interpreter.start [
          {type:'item',params:['remove',2]}
        ]
        setTimeout(done,500)
      it '先頭プレイヤーのアイテムが減る', ->
        rpg.game.party.backpack.itemCount.should.equal 0
        actor = rpg.game.party.getAt(1)
        actor.backpack.itemCount.should.equal 4
        actor = rpg.game.party.getAt(0)
        actor.backpack.itemCount.should.equal 7
