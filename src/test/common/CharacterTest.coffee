
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/constants.coffee')
require('../../main/common/Character.coffee')
require('../../main/common/Map.coffee')

require('../../test/common/System.coffee')

mapSheet = require('./MapTestData.coffee')

describe 'rpg.Character', () ->
  map = new rpg.Map()
  map.mapSheet = mapSheet
  map.events = []
  for l in map.mapSheet.layers when l.type is 'objectgroup'
    for obj in l.objects
      map.events.push JSON.parse(obj.properties.init)[0]
  rpg.system.scene = {
    map: map
  }
  rpg.game = {}
  rpg.game.player = {}
  rpg.game.player.character = new rpg.Character({
    mapX: 0
    mapY: 0
  })

  describe 'init', ->
    it 'default', ->
      c = new rpg.Character()
      c.spriteSheet.should.be.a 'string'
      c.spriteSheet.should.equal 'sample.spritesheet'

    it 'init param', ->
      c = new rpg.Character(spriteSheet: 'test',animation: mode: off)
      c.spriteSheet.should.be.a 'string'
      c.spriteSheet.should.equal 'test'

    it 'moveSpeed test', ->
      c = new rpg.Character()
      c.moveSpeed.should.equal 4
      c.frameDistance.should.equal 0.0625
      c.moveSpeed = 5
      c.moveSpeed.should.equal 5
      c.frameDistance.should.equal 0.125
      c.frameDistance = 1
      c.frameDistance.should.equal 0.125

  describe 'animation', ->
    describe 'mode', ->
      c = new rpg.Character()
      it 'init', ->
        c.isAnimation().should.equal true
      it 'off', ->
        c.animationMode = off
        c.isAnimation().should.equal false
      it 'on', ->
        c.animationMode = on
        c.isAnimation().should.equal true
    describe 'fix', ->
      c = new rpg.Character()
      it 'init', ->
        c.animationFix.should.equal off
      it 'on', ->
        c.animationFix = on
        c.animationFix.should.equal on
      it 'off', ->
        c.animationFix = off
        c.animationFix.should.equal off
    describe 'mode fix', ->
      c = new rpg.Character()
      it 'init', ->
        c.isAnimation().should.equal true
        c.animationFix.should.equal off
      it 'mode=on fix=on/off 0', ->
        c.animationFix = on
        c.animationMode.should.equal on
        c.isAnimation().should.equal false
        c.animationFix.should.equal on
      it 'mode=on fix=on/off 1', ->
        c.animationFix = off
        c.animationMode.should.equal on
        c.isAnimation().should.equal on
        c.animationFix.should.equal off
      it 'mode=on fix=on/off 2', ->
        c.animationFix = on
        c.animationMode.should.equal on
        c.isAnimation().should.equal false
        c.animationFix.should.equal on
      it 'mode=off fix=on/off 0', ->
        c.animationMode = off
        c.animationFix = on
        c.animationMode.should.equal off
        c.isAnimation().should.equal false
        c.animationFix.should.equal on
      it 'mode=off fix=on/off 1', ->
        c.animationFix = off
        c.animationMode.should.equal off
        c.isAnimation().should.equal false
        c.animationFix.should.equal off
      it 'mode=off fix=on/off 2', ->
        c.animationFix = on
        c.animationMode.should.equal off
        c.isAnimation().should.equal false
        c.animationFix.should.equal on
    describe 'name', ->
      c = new rpg.Character()
      it 'init', ->
        c.animationName.should.equal ''
      it 'init mode check', ->
        c.animationMode.should.equal true
      it 'init fix check', ->
        c.animationFix.should.equal false
      it 'init move check', ->
        c.animationMove.should.equal true
      it 'init stop check', ->
        c.animationStop.should.equal false
      it 'up', ->
        c.direction = 'up'
      it 'up move check1', ->
        c.isAnimationMove().should.equal on
      it 'up move', ->
        c.mapY += 1
      it 'up move check2', ->
        c.isAnimationMove().should.equal on
      it 'up name check1', ->
        c.animationName.should.equal ''
      it 'update', ->
        c.update()
      it 'up move check3', ->
        c.isAnimationMove().should.equal on
      it 'up name check2', ->
        c.animationName.should.equal ''
    
  describe 'direction', ->
    describe 'number', ->
      c = new rpg.Character()
      it 'init', ->
        c.directionNum.should.equal 2
      it 'left', ->
        c.directionNum = 4
        c.directionNum.should.equal 4
        c.direction.should.equal 'left'
      it 'right', ->
        c.directionNum = 6
        c.directionNum.should.equal 6
        c.direction.should.equal 'right'
      it 'down', ->
        c.directionNum = 2
        c.directionNum.should.equal 2
        c.direction.should.equal 'down'
      it 'up', ->
        c.directionNum = 8
        c.directionNum.should.equal 8
        c.direction.should.equal 'up'
      it 'error 1', ->
        c.directionNum = 1
        c.directionNum.should.equal 8
        c.direction.should.equal 'up'
      it 'error 2', ->
        c.directionNum = 31
        c.directionNum.should.equal 8
        c.direction.should.equal 'up'
    describe 'string', ->
      c = new rpg.Character()
      it 'init', ->
        c.direction.should.equal 'down'
      it 'left', ->
        c.direction = 'left'
        c.direction.should.equal 'left'
        c.directionNum.should.equal 4
      it 'right', ->
        c.direction = 'right'
        c.direction.should.equal 'right'
        c.directionNum.should.equal 6
      it 'down', ->
        c.direction = 'down'
        c.direction.should.equal 'down'
        c.directionNum.should.equal 2
      it 'up', ->
        c.direction = 'up'
        c.direction.should.equal 'up'
        c.directionNum.should.equal 8
      it 'error 1', ->
        c.direction = 'hoehoe'
        c.direction.should.equal 'up'
        c.directionNum.should.equal 8
      it 'error 2', ->
        c.direction = 'Left'
        c.direction.should.equal 'up'
        c.directionNum.should.equal 8
    describe 'fix', ->
      c = new rpg.Character()
      it 'init', ->
        c.directionFix.should.equal false
      it 'change 1', ->
        c.directionFix = true
        c.directionFix.should.equal true
      it 'change 2', ->
        c.directionFix = false
        c.directionFix.should.equal false
      it 'error 1', ->
        c.directionFix.should.equal false
        c.directionFix = 10
        c.directionFix.should.equal false
        c.directionFix = 'true'
        c.directionFix.should.equal false
      it 'change direction fix off', ->
        c.direction.should.equal 'down'
        c.directionFix = false
        c.direction = 'up'
        c.directionFix.should.equal false
        c.direction.should.equal 'up'
      it 'change direction fix on', ->
        c.directionFix = true
        c.direction = 'left'
        c.directionFix.should.equal true
        c.direction.should.equal 'up'
    describe '特定の座標方向を見る', ->
      c = new rpg.Character()
      it '位置設定', ->
        c.moveTo(5,5)
        c.mapX.should.equal 5
        c.mapY.should.equal 5
      it '0,5 を見ると、左を向く', ->
        c.directionTo(0,5)
        c.direction.should.equal 'left'
      it '10,5 を見ると、右を向く', ->
        c.directionTo(10,5)
        c.direction.should.equal 'right'
      it '5,0 を見ると、上を向く', ->
        c.directionTo(5,0)
        c.direction.should.equal 'up'
      it '5,10 を見ると、下を向く', ->
        c.directionTo(5,10)
        c.direction.should.equal 'down'
      it '4,5 を見ると、左を向く', ->
        c.directionTo(4,5)
        c.direction.should.equal 'left'
      it '6,5 を見ると、右を向く', ->
        c.directionTo(6,5)
        c.direction.should.equal 'right'
      it '5,4 を見ると、上を向く', ->
        c.directionTo(5,4)
        c.direction.should.equal 'up'
      it '5,6 を見ると、下を向く', ->
        c.directionTo(5,6)
        c.direction.should.equal 'down'

      it '4,4 を見ると、左を向く', ->
        c.directionTo(4,4)
        c.direction.should.equal 'left'
      it '6,6 を見ると、右を向く', ->
        c.directionTo(6,6)
        c.direction.should.equal 'right'
      it '6,4 を見ると、右を向く', ->
        c.directionTo(6,4)
        c.direction.should.equal 'right'
      it '4,6 を見ると、左を向く', ->
        c.directionTo(4,6)
        c.direction.should.equal 'left'

    describe 'キャラクターを見る', ->
      c = new rpg.Character()
      ct = new rpg.Character()
      it '位置設定', ->
        c.moveTo(5,5)
        c.mapX.should.equal 5
        c.mapY.should.equal 5
      it '0,5 を見ると、左を向く', ->
        ct.moveTo(0,5)
        c.directionTo(ct)
        c.direction.should.equal 'left'
      it '10,5 を見ると、右を向く', ->
        ct.moveTo(10,5)
        c.directionTo(ct)
        c.direction.should.equal 'right'
      it '5,0 を見ると、上を向く', ->
        ct.moveTo(5,0)
        c.directionTo(ct)
        c.direction.should.equal 'up'
      it '5,10 を見ると、下を向く', ->
        ct.moveTo(5,10)
        c.directionTo(ct)
        c.direction.should.equal 'down'
      
  describe 'move', ->
    c = new rpg.Character()
    it 'default', ->
      c.x.should.equal 0
      c.mapX.should.equal 0
    it 'x = 1', ->
      c.x = 1
      c.x.should.equal 1
      c.mapX.should.equal 0
    it 'mapX = 1', ->
      c.mapX = 1
      c.x.should.equal 1
      c.mapX.should.equal 1
      c.mapX = 0
    it 'isStop', ->
      c.mapX.should.equal 0
      c.mapY.should.equal 0
      c.moveX.should.equal 0
      c.moveY.should.equal 0
      c.isStop().should.equal true

    describe 'updatePosition', ->
      describe 'x', ->
        c = new rpg.Character()
        it 'init', ->
          c.moveX = 0
          c.mapX = 0
        it 'isMove', ->
          c.isMove().should.equal false
          c.mapX = 1
          c.isMove().should.equal true
        it 'frameDistance', ->
          c.frameDistance.should.equal 0.0625
          c.updatePosition()
          c.x.should.equal 2
          c.mapX.should.equal 1
          c.moveX.should.equal 0.0625
        it 'updatePosition', ->
          c.updatePosition()
          c.x.should.equal 4
          c.mapX.should.equal 1
          c.moveX.should.equal 0.0625 * 2
          c.updatePosition() while c.isMove()
          c.moveX.should.equal 1
      describe 'y', ->
        c = new rpg.Character()
        it 'init', ->
          c.moveY = 0
          c.mapY = 0
        it 'isMove', ->
          c.isMove().should.equal false
          c.mapY = 1
          c.isMove().should.equal true
        it 'frameDistance', ->
          c.frameDistance.should.equal 0.0625
          c.updatePosition()
          c.y.should.equal 2
          c.mapY.should.equal 1
          c.moveY.should.equal 0.0625
        it 'updatePosition', ->
          c.updatePosition()
          c.y.should.equal 4
          c.mapY.should.equal 1
          c.moveY.should.equal 0.0625 * 2
          c.updatePosition() while c.isMove()
          c.moveY.should.equal 1
  describe 'moveTo', ->
    describe '5 5', ->
      c = new rpg.Character()
      c.moveTo(5,5)
      it 'check mapXY', ->
        c.mapX.should.equal 5
        c.mapY.should.equal 5
      it 'check moveXY', ->
        c.moveX.should.equal 5
        c.moveY.should.equal 5
      it 'check xy', ->
        c.x.should.equal 160
        c.y.should.equal 160
    describe '0 5', ->
      c = new rpg.Character()
      c.moveTo(0,5)
      it 'check mapXY', ->
        c.mapX.should.equal 0
        c.mapY.should.equal 5
      it 'check moveXY', ->
        c.moveX.should.equal 0
        c.moveY.should.equal 5
      it 'check xy', ->
        c.x.should.equal 0
        c.y.should.equal 160
    describe '0 1', ->
      c = new rpg.Character()
      c.moveTo(0,1)
      it 'check mapXY', ->
        c.mapX.should.equal 0
        c.mapY.should.equal 1
      it 'check moveXY', ->
        c.moveX.should.equal 0
        c.moveY.should.equal 1
      it 'check xy', ->
        c.x.should.equal 0
        c.y.should.equal 32
  describe '移動可能位置', ->
    describe 'moveLeft', ->
      describe '5,5', ->
        c = new rpg.Character()
        c.moveTo(5,5)
        it '1', ->
          c.direction.should.equal 'down'
          c.moveLeft()
        it 'x', ->
          c.mapX.should.equal 5 - 1
        it 'y', ->
          c.mapY.should.equal 5
        it 'direction', ->
          c.direction.should.equal 'left'
      describe '13,10 歩数指定1', ->
        c = new rpg.Character()
        c.moveTo(13,10)
        it '1', ->
          c.direction.should.equal 'down'
          c.moveLeft(1)
        it 'x', ->
          c.mapX.should.equal 13 - 1
        it 'y', ->
          c.mapY.should.equal 10
        it 'direction', ->
          c.direction.should.equal 'left'
      describe '13,10 歩数指定2 途中でぶつかる', ->
        c = new rpg.Character()
        c.moveTo(13,10)
        it '1', ->
          c.direction.should.equal 'down'
          c.moveLeft(2)
        it 'x', ->
          c.mapX.should.equal 13 - 1
        it 'y', ->
          c.mapY.should.equal 10
        it 'direction', ->
          c.direction.should.equal 'left'
      describe '13,10 歩数指定3　途中でぶつかる', ->
        c = new rpg.Character()
        c.moveTo(13,10)
        it '1', ->
          c.direction.should.equal 'down'
          c.moveLeft(3)
        it 'x', ->
          c.mapX.should.equal 13 - 1
        it 'y', ->
          c.mapY.should.equal 10
        it 'direction', ->
          c.direction.should.equal 'left'
      describe '14,10 歩数指定2', ->
        c = new rpg.Character()
        c.moveTo(14,10)
        it '1', ->
          c.direction.should.equal 'down'
          c.moveLeft(2)
        it 'x', ->
          c.mapX.should.equal 14 - 2
        it 'y', ->
          c.mapY.should.equal 10
        it 'direction', ->
          c.direction.should.equal 'left'
    describe 'moveRight 5,5', ->
      c = new rpg.Character()
      c.moveTo(5,5)
      it '1', ->
        c.direction.should.equal 'down'
        c.moveRight()
      it 'x', ->
        c.mapX.should.equal 5 + 1
      it 'y', ->
        c.mapY.should.equal 5
      it 'direction', ->
        c.direction.should.equal 'right'
    describe 'moveUp 5,5', ->
      c = new rpg.Character()
      c.moveTo(5,5)
      it '1', ->
        c.direction.should.equal 'down'
        c.moveUp()
      it 'x', ->
        c.mapX.should.equal 5
      it 'y', ->
        c.mapY.should.equal 5 - 1
      it 'direction', ->
        c.direction.should.equal 'up'
    describe 'moveDown', ->
      describe '5,5', ->
        c = new rpg.Character()
        c.moveTo(5,5)
        c.direction = 'up'
        it '1', ->
          c.direction.should.equal 'up'
          c.moveDown()
        it 'x', ->
          c.mapX.should.equal 5
        it 'y', ->
          c.mapY.should.equal 5 + 1
        it 'direction', ->
          c.direction.should.equal 'down'
      describe '5,9 キャラクターが居て移動できない', ->
        c = new rpg.Character()
        c.moveTo(5,9)
        c.direction = 'up'
        it '1', ->
          c.direction.should.equal 'up'
          c.moveDown()
        it 'x', ->
          c.mapX.should.equal 5
        it 'y', ->
          c.mapY.should.equal 9
        it 'direction', ->
          c.direction.should.equal 'down'
      describe '5,9 キャラクターが居てすり抜けonだと移動可能', ->
        c = new rpg.Character()
        c.moveTo(5,9)
        c.direction = 'up'
        it 'すり抜けon', ->
          map.events[0].transparent = true
        it '1', ->
          c.direction.should.equal 'up'
          c.moveDown()
        it 'x', ->
          c.mapX.should.equal 5
        it 'y', ->
          c.mapY.should.equal 10
        it 'direction', ->
          c.direction.should.equal 'down'
        it 'すり抜けoff', ->
          map.events[0].transparent = false
  describe '移動できない位置', ->
    describe 'moveLeft 10,10', ->
      c = new rpg.Character()
      c.moveTo(10,10)
      it '1', ->
        c.direction.should.equal 'down'
        c.moveLeft()
      it 'x', ->
        c.mapX.should.equal 10
      it 'y', ->
        c.mapY.should.equal 10
      it 'direction', ->
        c.direction.should.equal 'left'
    describe 'moveLeft 10,10 すり抜け', ->
      c = new rpg.Character()
      c.moveTo(10,10)
      c.transparent = true
      it '1', ->
        c.direction.should.equal 'down'
        c.moveLeft()
      it 'x', ->
        c.mapX.should.equal 9
      it 'y', ->
        c.mapY.should.equal 10
      it 'direction', ->
        c.direction.should.equal 'left'
    describe 'moveLeft 11,10', ->
      c = new rpg.Character()
      c.moveTo(11,10)
      it '2', ->
        c.moveLeft()
      it 'x2', ->
        c.mapX.should.equal 11
      it 'y2', ->
        c.mapY.should.equal 10
      it 'direction2', ->
        c.direction.should.equal 'left'
    describe 'moveRight 10,10', ->
      c = new rpg.Character()
      c.moveTo(10,10)
      it '1', ->
        c.direction.should.equal 'down'
        c.moveRight()
      it 'x', ->
        c.mapX.should.equal 10
      it 'y', ->
        c.mapY.should.equal 10
      it 'direction', ->
        c.direction.should.equal 'right'
    describe 'moveRight 9,10', ->
      c = new rpg.Character()
      c.moveTo(9,10)
      it '2', ->
        c.moveRight()
      it 'x2', ->
        c.mapX.should.equal 9
      it 'y2', ->
        c.mapY.should.equal 10
      it 'direction2', ->
        c.direction.should.equal 'right'
    describe 'moveUp 10,10', ->
      c = new rpg.Character()
      c.moveTo(10,10)
      it '1', ->
        c.direction.should.equal 'down'
        c.moveUp()
      it 'x', ->
        c.mapX.should.equal 10
      it 'y', ->
        c.mapY.should.equal 10
      it 'direction', ->
        c.direction.should.equal 'up'
    describe 'moveUp 10,11', ->
      c = new rpg.Character()
      c.moveTo(10,11)
      it '2', ->
        c.moveUp()
      it 'x2', ->
        c.mapX.should.equal 10
      it 'y2', ->
        c.mapY.should.equal 11
      it 'direction2', ->
        c.direction.should.equal 'up'
    describe 'moveDown 10,10', ->
      c = new rpg.Character()
      c.moveTo(10,10)
      c.direction = 'up'
      it '1', ->
        c.direction.should.equal 'up'
        c.moveDown()
      it 'x', ->
        c.mapX.should.equal 10
      it 'y', ->
        c.mapY.should.equal 10
      it 'direction', ->
        c.direction.should.equal 'down'
    describe 'moveDown 10,9', ->
      c = new rpg.Character()
      c.moveTo(10,9)
      it '2', ->
        c.direction = 'up'
        c.directionFix.should.equal false
        c.direction.should.equal 'up'
        c.moveDown()
      it 'x2', ->
        c.mapX.should.equal 10
      it 'y2', ->
        c.mapY.should.equal 9
      it 'direction2', ->
        c.direction.should.equal 'down'

  describe 'frontPosition', ->
    c = new rpg.Character()
    it '5,5,2の場合 5, 6になる', ->
      [x,y]=c.frontPosition(5,5,2)
      x.should.equal 5
      y.should.equal 6
    it '5,5,4の場合 4, 5になる', ->
      [x,y]=c.frontPosition(5,5,4)
      x.should.equal 4
      y.should.equal 5
    it '5,5,6の場合 6, 5になる', ->
      [x,y]=c.frontPosition(5,5,6)
      x.should.equal 6
      y.should.equal 5
    it '5,5,8の場合 5, 4になる', ->
      [x,y]=c.frontPosition(5,5,8)
      x.should.equal 5
      y.should.equal 4

  describe '逆向き計算 reverseDirection', ->
    c = new rpg.Character()
    it '2の場合8', ->
      c.reverseDirection(2).should.equal 8
    it '4の場合6', ->
      c.reverseDirection(4).should.equal 6
    it '6の場合4', ->
      c.reverseDirection(6).should.equal 4
    it '8の場合2', ->
      c.reverseDirection(8).should.equal 2

  # TODO: もっとかこー
  describe '目の前のキャラクターを検索 findFrontCharacter 5, 10 に居る場合', ->
    c = new rpg.Character()
    c.mapX = 5
    c.mapY = 10
    it '場所確認', ->
      event = map.findCharacter(5,10)
      event.mapX.should.equal 5
      event.mapY.should.equal 10
    it '引数なし場所は、5 9 向き下', ->
      pc = rpg.game.player.character
      pc.mapX = 0
      pc.mapY = 0
      c.mapX = 5
      c.mapY = 9
      c.direction = 2
      event = c.findFrontCharacter()
      event.mapX.should.equal 5
      event.mapY.should.equal 10

  describe 'プレイヤーで移動確認', ->
    it '0,0 から右に移動可能(true)', ->
      pc = rpg.game.player.character
      pc.mapX = 0
      pc.mapY = 0
      pc.direction = 'right'
      pc.isPassable().should.equal true
    it '0,0 から右に移動可能(true)', ->
      pc = rpg.game.player.character
      pc.mapX = 1
      pc.mapY = 1
      pc.direction = 'up'
      pc.isPassable(0,0,'right').should.equal true
    it '1,0 から左に移動可能(true)', ->
      pc = rpg.game.player.character
      pc.isPassable(1,0,'left').should.equal true
    it '1,0 から上に移動不可能(false)', ->
      pc = rpg.game.player.character
      pc.isPassable(1,0,'up').should.equal false
    it '0,0 から下に移動可能(true)', ->
      pc = rpg.game.player.character
      pc.isPassable(0,0,'down').should.equal true
    it '1,1 から左に移動不可能(false)', ->
      pc = rpg.game.player.character
      pc.isPassable(1,1,'left').should.equal false

  describe '移動ルート設定', ->
    c = new rpg.Character()
    it '移動ルートを設定', ->
      c.moveTo(5,5)
      c.forceMoveRoute [
        {name: 'moveUp'}
        {name: 'moveLeft'}
        {name: 'moveRight'}
        {name: 'moveDown'}
      ]
      c.moveRouteForce.should.equal true
    it '更新1回目、上に移動', ->
      c.update() for n in [1 .. 16]
      c.isMove().should.equal true
      c.mapX.should.equal 5
      c.mapY.should.equal 4
    it '更新2回目、左に移動', ->
      c.update() for n in [1 .. 16]
      c.isMove().should.equal true
      c.mapX.should.equal 4
      c.mapY.should.equal 4
    it '更新3回目、右に移動', ->
      c.update() for n in [1 .. 16]
      c.isMove().should.equal true
      c.mapX.should.equal 5
      c.mapY.should.equal 4
    it '更新4回目、下に移動', ->
      c.update() for n in [1 .. 16]
      c.isMove().should.equal true
      c.mapX.should.equal 5
      c.mapY.should.equal 5
    it '更新5回目、その場に停止', ->
      c.update() for n in [1 .. 16]
      c.isMove().should.equal false
      c.mapX.should.equal 5
      c.mapY.should.equal 5
