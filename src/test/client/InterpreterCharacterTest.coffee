# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Interpreter(Character)', () ->
  interpreter = null
  @timeout(10000)
  describe 'キャラクター関連のイベント', ->
    describe 'キャラクターの表示', ->
      it 'マップシーンへ移動', (done) ->
        loadTestMap(done)
