# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Cash)', () ->
  c = 0
  interpreter = null
  describe '所持金', ->
    describe '増やす', ->
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'ウェイト', (done) ->
        setTimeout(done,1000)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it '所持金を増やす', (done) ->
        c = rpg.game.party.cash
        interpreter.start [
          {type:'gain_cash',params:[100]}
          {type:'function',params:[done]}
        ]
      it '所持金が増えている', ->
        rpg.game.party.cash.should.equal (c + 100)
    describe '減らす', ->
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'ウェイト', (done) ->
        setTimeout(done,1000)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it '所持金を減らす', (done) ->
        rpg.game.party.cash += 100
        c = rpg.game.party.cash
        interpreter.start [
          {type:'lost_cash',params:[100]}
          {type:'function',params:[done]}
        ]
      it '所持金が減っている', ->
        rpg.game.party.cash.should.equal (c - 100)
    describe '減らす（０以下にはならない）', ->
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'ウェイト', (done) ->
        setTimeout(done,1000)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
      it '所持金を減らす', (done) ->
        rpg.game.party.cash += 100
        c = rpg.game.party.cash
        interpreter.start [
          {type:'lost_cash',params:[99999]}
          {type:'function',params:[done]}
        ]
      it '所持金が０になっている', ->
        rpg.game.party.cash.should.equal 0
    describe '増減', ->
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
      it 'ウェイト', (done) ->
        setTimeout(done,1000)
      it 'インタープリタ取得', ->
        interpreter = rpg.system.scene.interpreter
        c = rpg.game.party.cash
      it '所持金を増やす', (done) ->
        interpreter.start [
          {type:'cash',params:[500]}
          {type:'function',params:[done]}
        ]
      it '所持金が増えている', ->
        rpg.game.party.cash.should.equal (c + 500)
      it '所持金を減らす', (done) ->
        interpreter.start [
          {type:'cash',params:[-10]}
          {type:'function',params:[done]}
        ]
      it '所持金が減っている', ->
        rpg.game.party.cash.should.equal (c + 490)
