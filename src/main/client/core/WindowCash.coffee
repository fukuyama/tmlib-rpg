###*
* @file WindowCash.coffee
* 所持金ウィンドウ
###

tm.define 'rpg.WindowCash',
  superClass: rpg.Window

  ###* コンストラクタ
  * @classdesc 所持金ウィンドウ
  * @constructor rpg.WindowCash
  * @param {Object} args
  ###
  init: (args={}) ->
    sc = rpg.system.screen
    w = 24 * 5 + 16 * 2
    {
      x
      y
      width
      height
    } = {
      x: sc.width - 16 - w
      y: 16
      width: w
      height: rpg.system.lineHeight + 16 * 2
    }.$extend args
    @superInit(x,y,width,height,args)

