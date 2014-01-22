require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Battler.coffee')

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.Battler', () ->
  battler = null
  describe 'バトラー生成', ->
    it '生成するとデフォルト値で初期化される', ->
      battler = new rpg.Battler()
    it '初期化されている', ->
      battler.str.should.equal 10
      battler.vit.should.equal 10
      battler.dex.should.equal 10
      battler.agi.should.equal 10
      battler.int.should.equal 10
      battler.sen.should.equal 10
      battler.luc.should.equal 10
      battler.cha.should.equal 10
      battler.minhp.should.equal 10
      battler.minmp.should.equal 10
  describe 'バトラー初期化', ->
    it '初期値を指定', ->
      battler = new rpg.Battler(
        base:
          str: 11
          vit: 12
          dex: 13
          agi: 14
          int: 15
          sen: 16
          luc: 17
          cha: 18
          minhp: 19
          minmp: 20
      )
    it '初期化されている', ->
      battler.str.should.equal 11
      battler.vit.should.equal 12
      battler.dex.should.equal 13
      battler.agi.should.equal 14
      battler.int.should.equal 15
      battler.sen.should.equal 16
      battler.luc.should.equal 17
      battler.cha.should.equal 18
      battler.minhp.should.equal 19
      battler.minmp.should.equal 20
  describe '各パラメータを取得する', ->
    it '初期化', ->
      battler = new rpg.Battler(
        base:
          str: 18
          vit: 17
          dex: 16
          agi: 15
          int: 14
          sen: 13
          luc: 12
          cha: 11
          minhp: 10
          minmp: 9
      )
    it '攻撃力を取得', ->
      battler.patk.should.equal 26
    it '防御力を取得', ->
      battler.pdef.should.equal 24
    it '攻撃魔力を取得', ->
      battler.matk.should.equal 20
    it '回復魔力を取得', ->
      battler.mcur.should.equal 20
    it '魔力防御力を取得', ->
      battler.mdef.should.equal 19

    it '最大ヒットポイントを取得', ->
      battler.maxhp.should.equal 42
    it '最大マジックポイントを取得', ->
      battler.maxmp.should.equal 28
