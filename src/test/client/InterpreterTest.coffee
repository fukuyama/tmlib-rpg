
describe 'rpg.Interpreter', () ->
  describe '初期化', ->
    it '引数なし', ->
      interpreter = new rpg.Interpreter()
      interpreter.should.be.a 'object'

  describe '文章表示', ->
    interpreter = new rpg.Interpreter()
    it 'message start', ->
      interpreter.start [
        {type:'message',params:['TEST1']}
        {type:'message',params:['TEST2']}
      ]
    it 'message update', ->
      interpreter.update()
      rpg.system.temp.message.should.deep.equal [
        'TEST1','TEST2'
      ]
