###*
* @file WindowStatusDetail.coffee
* アクターステータス情報
###

WORDS = rpg.constants.WORDS
BASE_LIST = [
  'str'
  'vit'
  'dex'
  'agi'
  'int'
  'sen'
  'luc'
  'cha'
  'maxhp'
  'maxmp'
]

BATTLE_LIST = [
  'patk'
  'pdef'
  'matk'
  'mcur'
  'mdef'
  'maxhp'
  'maxmp'
]

tm.define 'rpg.WindowStatusDetail',
  superClass: rpg.Window

  ###* コンストラクタ
  * @classdesc アクターステータス詳細
  * @constructor rpg.WindowStatusDetail
  * @param {Object} args
  ###
  init: (args={}) ->
    rs = rpg.system
    parent = args.parent
    x = parent.right
    y = parent.top
    w = 24 * 8 + 16 * 2
    h = rs.lineHeight * 12 + 16 * 2
    @superInit(x,y,w,h,args)

    @_refreshs = [
      @_refreshBase
      @_refreshBattle
    ]
    @_current = 0

  ###* 基本ステータスに書き換え
  * @memberof rpg.WindowStatusDetail#
  * @param {prg.Actor} actor アクター
  * @_private
  ###
  _refreshBase: (actor) ->
    x = 0
    y = 0
    wc = @content.width
    @content.clear()
    if actor?
      for k in BASE_LIST
        @drawText(WORDS[k],x,y)
        @drawText(actor[k],wc,y,{align:'right'})
        y += rpg.system.lineHeight
    @refresh()

  ###* 戦闘関連ステータスに書き換え
  * @memberof rpg.WindowStatusDetail#
  * @param {prg.Actor} actor アクター
  * @_private
  ###
  _refreshBattle: (actor) ->
    x = 0
    y = 0
    wc = @content.width
    @content.clear()
    if actor?
      for k in BATTLE_LIST
        @drawText(WORDS[k],x,y)
        @drawText(actor[k],wc,y,{align:'right'})
        y += rpg.system.lineHeight
    @refresh()

  ###* 指定アクターを描画
  * @memberof rpg.WindowStatusDetail#
  * @param {prg.Actor} actor アクター
  ###
  selectActor: (actor) ->
    @_current = (@_current + 1) % @_refreshs.length
    @_refreshs[@_current].call(@,actor)

  ###* 指定アクターを描画
  * @memberof rpg.WindowStatusDetail#
  * @param {prg.Actor} actor アクター
  ###
  changeActor: (actor) ->
    @_refreshs[@_current].call(@,actor)
