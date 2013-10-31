
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/Character.coffee')
MAP = require('../../main/common/Map.coffee')

describe 'rpg.Character', () ->
  map = new rpg.Map()
  map.mapSheet = MAP.ASSETS['sample.mapsheet'].src
  rpg.system = {
    scene:
      map: map
  }
  
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
        c.animationStop.should.equal true
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
        c.animationName.should.equal 'up'
    
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
  describe 'moveLeft 5,5', ->
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
  describe 'moveDown 5,5', ->
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
  # 移動できない位置
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
