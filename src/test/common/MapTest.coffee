
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Character.coffee')
require('../../main/common/Map.coffee')
require('../../main/common/Flag.coffee')
require('../../main/common/EventPage.coffee')
require('../../main/common/Event.coffee')

mapSheet = require('./MapTestData.coffee')

describe 'rpg.Mapの仕様', () ->
  debug = (m) ->
    m.mapSheet = mapSheet
    m.events = []
    for l in m.mapSheet.layers when l.type is 'objectgroup'
      for obj in l.objects
        params = JSON.parse(obj.properties.init)[0]
        m.events[obj.name] = new rpg.Event(params)
    m
  rpg.system = rpg.system ? {}
  rpg.game = {}
  rpg.game.player = {}
  rpg.game.player.character = new rpg.Character({
    mapX: 0
    mapY: 0
  })
  rpg.game.flag = new rpg.Flag()

  describe '初期化', ->
    m = new rpg.Map()
    it 'sample.mapsheet の設定 debug', ->
      m.mapSheet = mapSheet
    it 'sample.mapsheet の width は、30', ->
      m.mapSheet.width.should.equal 30
    it 'sample.mapsheet の height は、30', ->
      m.mapSheet.height.should.equal 30

  describe 'isValid サンプルマップのサイズ 30, 30 の場合', ->
    m = debug new rpg.Map()
    it '0,0 はマップ範囲内なので true', ->
      m.isValid(0,0).should.equal true
    it '29,0 はマップ範囲内なので true', ->
      m.isValid(29,0).should.equal true
    it '0,29 はマップ範囲内なので true', ->
      m.isValid(0,29).should.equal true
    it '29,29 はマップ範囲内なので true', ->
      m.isValid(29,29).should.equal true
    it '30,29 はマップ範囲外なので false', ->
      m.isValid(30,29).should.equal false
    it '29,30 はマップ範囲外なので false', ->
      m.isValid(29,30).should.equal false
    it '30,30 はマップ範囲外なので false', ->
      m.isValid(30,30).should.equal false
    it '-1,0 はマップ範囲外なので false', ->
      m.isValid(-1,0).should.equal false
    it '0,-1 はマップ範囲外なので false', ->
      m.isValid(0,-1).should.equal false
    it '-1,-1 はマップ範囲外なので false', ->
      m.isValid(-1,-1).should.equal false

  describe 'isPassable サンプルマップの 5, 5' +
  '、タイルＩＤが全て 0 で、全方向移動可能な場合', ->
    m = debug new rpg.Map()
    it 'プレイヤー位置設定', ->
      rpg.game.player.character.mapX = 0
      rpg.game.player.character.mapY = 0
    it '5,5 から下(2)へ移動可能(true)', ->
      m.isPassable(5,5,2).should.equal true
    it '5,5 から左(4)へ移動可能(true)', ->
      m.isPassable(5,5,4).should.equal true
    it '5,5 から右(6)へ移動可能(true)', ->
      m.isPassable(5,5,6).should.equal true
    it '5,5 から上(8)へ移動可能(true)', ->
      m.isPassable(5,5,8).should.equal true

  describe 'isPassable サンプルマップの 10, 10' +
  '、タイルＩＤが全て 1 で、全方向移動不可能な場合', ->
    m = debug new rpg.Map()
    it '10,10 から下(2)へ移動不可能(false)', ->
      m.isPassable(10,10,2).should.equal false
    it '10,10 から左(4)へ移動不可能(false)', ->
      m.isPassable(10,10,4).should.equal false
    it '10,10 から右(6)へ移動不可能(false)', ->
      m.isPassable(10,10,6).should.equal false
    it '10,10 から上(8)へ移動不可能(false)', ->
      m.isPassable(10,10,8).should.equal false

  describe 'isPassable サンプルマップの 5, 10' +
  '、キャラクターがいるので通行不可能', ->
    m = debug new rpg.Map()
    it '5,10 から下(2)へ移動不可能(false)', ->
      m.isPassable(5,10,2).should.equal false
    it '5,10 から左(4)へ移動不可能(false)', ->
      m.isPassable(5,10,4).should.equal false
    it '5,10 から右(6)へ移動不可能(false)', ->
      m.isPassable(5,10,6).should.equal false
    it '5,10 から上(8)へ移動不可能(false)', ->
      m.isPassable(5,10,8).should.equal false

  describe 'isPassable サンプルマップの 5, 5' +
  'にプレイヤーがいる', ->
    m = debug new rpg.Map()
    it 'プレイヤー位置設定', ->
      rpg.game.player.character.mapX = 5
      rpg.game.player.character.mapY = 5
    it '5,5 から下(2)へ移動不可能(false)', ->
      m.isPassable(5,5,2).should.equal false
    it '5,5 から左(4)へ移動不可能(false)', ->
      m.isPassable(5,5,4).should.equal false
    it '5,5 から右(6)へ移動不可能(false)', ->
      m.isPassable(5,5,6).should.equal false
    it '5,5 から上(8)へ移動不可能(false)', ->
      m.isPassable(5,5,8).should.equal false

  describe 'マップイベント', ->
    describe 'イベントページ切替', ->
      m = debug new rpg.Map()
      it 'イベント確認1 page1', ->
        event = m.events.Event006
        page = event.currentPage
        page.name.should.equal 'page1'
      it 'フラグ操作 A=on', ->
        rpg.game.flag.on 'A'
        m.refreshEvent()
      it 'イベント確認2 page2', ->
        event = m.events.Event006
        page = event.currentPage
        page.name.should.equal 'page2'
      it 'フラグ操作 A=off', ->
        rpg.game.flag.off 'A'
        m.refreshEvent()
      it 'イベント確認3 page1', ->
        event = m.events.Event006
        page = event.currentPage
        page.name.should.equal 'page1'

  describe 'エンカウント情報', ->
    it 'エンカウント取得', ->
      m = debug new rpg.Map()
      e = m.getEncount(mapX:0,mapY:0)
      e.step.should.equal 30
      e = m.getEncount(mapX:10,mapY:10)
      e.step.should.equal 30
    it 'エンカウントなし', ->
      m = debug new rpg.Map()
      e = m.getEncount(mapX:0,mapY:11)
      (e is null).should.equal true
