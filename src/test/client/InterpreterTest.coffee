
describe 'rpg.Interpreter', () ->
  describe '初期化', ->
    it '引数なし', ->
      interpreter = new rpg.Interpreter()
      interpreter.should.be.a 'object'
