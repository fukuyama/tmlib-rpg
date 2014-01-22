require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')
require('../../main/common/Actor.coffee')
require('../../main/common/Party.coffee')

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Party', () ->
  describe '初期化', () ->
    party = null
    it '初期化', ->
      party = new rpg.Party()
    it '初期メンバー数は０', ->
      party.length.should.equal 0
  describe 'メンバー操作', () ->
    party = null
    a1 = null
    a2 = null
    it '初期化', ->
      party = new rpg.Party()
    it 'メンバーを追加できる', ->
      a1 = new rpg.Actor(name:'test1')
      a2 = new rpg.Actor(name:'test2')
      a3 = new rpg.Actor(name:'test3')
      party.length.should.equal 0
      party.add(a1)
      party.length.should.equal 1
      party.add(a2)
      party.length.should.equal 2
      party.add(a3)
      party.length.should.equal 3
    it 'メンバーリスト処理', ->
      nms = ''
      party.each((a) ->
        nms += a.name
      )
      nms.should.equal 'test1test2test3'
    it 'メンバーを削除できる', ->
      party.length.should.equal 3
      party.remove(a2)
      party.length.should.equal 2
      party.getAt(0).name.should.equal 'test1'
      party.getAt(1).name.should.equal 'test3'
    it '範囲外はnullを返す', ->
      console.log party.getAt(10)
      (typeof party.getAt(10)).should.equal 'undefined'
