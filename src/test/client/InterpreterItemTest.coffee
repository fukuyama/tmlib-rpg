# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Item)', () ->
  interpreter = null
  describe 'アイテム関連のイベント', ->
    @timeout(10000)
    it 'マップシーンへ移動', (done) ->
      loadTestMap(done)
    it 'インタープリタ取得', ->
      interpreter = rpg.system.scene.interpreter
    it 'アイテムを１つ増やす', ->
      interpreter.start [
        {type:'item',params:['add','Item01']}
      ]
