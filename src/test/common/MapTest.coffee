
require('chai').should()

require('../../main/common/utils.coffee')
MAP = require('../../main/common/Map.coffee')

describe 'rpg.Map', () ->
  debug = (m) ->
    m.mapSheet = MAP.ASSETS['sample.mapsheet']
    m
  describe 'init', ->
    it 'default', ->
      m = new rpg.Map()
      m.mapSheet.should.equal 'sample.mapsheet'
      m.mapSheet = MAP.ASSETS['sample.mapsheet']
      m.mapSheet.width.should.equal 30
      m.mapSheet.height.should.equal 30

  describe 'isValid', ->
    m = debug new rpg.Map()
    it '0,0', ->
      m.isValid(0,0).should.equal true
    it '29,0', ->
      m.isValid(29,0).should.equal true
    it '0,29', ->
      m.isValid(0,29).should.equal true
    it '29,29', ->
      m.isValid(29,29).should.equal true
    it '30,29', ->
      m.isValid(30,29).should.equal false
    it '29,30', ->
      m.isValid(29,30).should.equal false
    it '30,30', ->
      m.isValid(30,30).should.equal false
    it '-1,0', ->
      m.isValid(-1,0).should.equal false
    it '0,-1', ->
      m.isValid(0,-1).should.equal false
    it '-1,-1', ->
      m.isValid(-1,-1).should.equal false

  describe 'isPassable', ->
    m = debug new rpg.Map()
    it '5,5,2', ->
      m.isPassable(5,5,2).should.equal true
    it '5,5,4', ->
      m.isPassable(5,5,4).should.equal true
    it '5,5,6', ->
      m.isPassable(5,5,6).should.equal true
    it '5,5,8', ->
      m.isPassable(5,5,8).should.equal true
    it '5,5,2', ->
      m.isPassable(10,10,2).should.equal false
    it '10,10,4', ->
      m.isPassable(10,10,4).should.equal false
    it '10,10,6', ->
      m.isPassable(10,10,6).should.equal false
    it '10,10,8', ->
      m.isPassable(10,10,8).should.equal false
