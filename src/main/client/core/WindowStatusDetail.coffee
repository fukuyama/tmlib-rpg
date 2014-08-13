###*
* @file WindowStatusDetail.coffee
* アクターステータス情報
###

WORDS = [
  {key: 'str', disp: 'ちから'}
  {key: 'vit', disp: 'たいりょく'}
  {key: 'dex', disp: 'きようさ'}
  {key: 'agi', disp: 'すばやさ'}
  {key: 'int', disp: 'かしこさ'}
  {key: 'sen', disp: 'かんせい'}
  {key: 'luc', disp: 'うんのよさ'}
  {key: 'cha', disp: 'みりょく'}
  {key: 'hp',  disp: 'HP'}
  {key: 'mp',  disp: 'MP'}
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
    w = 24 * 9 + 16 * 2
    h = rs.lineHeight * 10 + 16 * 2
    @superInit(x,y,w,h,args)

  ###* 指定アクターを描画
  * @memberof rpg.WindowStatusDetail#
  * @param {prg.Actor} actor アクター
  ###
  changeActor: (actor) ->
    x = 0
    y = 0
    wc = @content.width
    @content.clear()
    if actor?
      for wd in WORDS
        @drawText(wd.disp,x,y)
        @drawText(actor[wd.key],wc,y,{align:'right'})
        y += rpg.system.lineHeight
    @refresh()
