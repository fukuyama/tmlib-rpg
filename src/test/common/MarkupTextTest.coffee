
require('chai').should()
require('../../main/common/utils.coffee')
require('../../main/common/MarkupText.coffee')

describe 'rpg.MarkupText', ->
  rpg.system = rpg.system ? {}
  rpg.system.lineHeight = 32
  describe '初期化', ->
    it 'パラメータなし', ->
      mt = new rpg.MarkupText()
  describe 'マークアップ追加', ->
    mt = new rpg.MarkupText()
    it '\\aaaa を追加', ->
      mt.add
        mark: '\\'
        name: 'aaaa'
        func: (obj, x, y, msg, i) ->
          [x, y, i + 5]
      mt.markups.length.should.equal 1
    it '\\nを実行すると、i は かわらない', ->
      mt.markups.length.should.equal 1
      [x,y,i] = mt.draw({},0,0,'\\nFunifuni',0)
      i.should.equal 0
    it '\\aaaaを実行すると、i が 5 アップ', ->
      mt.markups.length.should.equal 1
      [x,y,i] = mt.draw({},0,0,'\\aaaaHoehoe',0)
      i.should.equal 5
    it 'hoehoe\\aaaaを実行すると、i=0 は変かなし', ->
      mt.markups.length.should.equal 1
      [x,y,i] = mt.draw({},0,0,'hoehoe\\aaaaHoehoe',0)
      i.should.equal 0
    it 'hoehoe\\aaaaを実行すると、i=6 は 5 アップ', ->
      mt.markups.length.should.equal 1
      [x,y,i] = mt.draw({},0,0,'hoehoe\\aaaaHoehoe',6)
      i.should.equal 11

  describe 'マークアップ追加その２', ->
    mt = new rpg.MarkupText()
    it '\\aaaa を追加', ->
      mt.add '\\aaaa',
        (obj, x, y, msg, i) ->
          [x, y, i + 5]
      mt.markups.length.should.equal 1
    it '\\nを実行すると、i は かわらない', ->
      mt.markups.length.should.equal 1
      [x,y,i] = mt.draw({},0,0,'\\nFunifuni',0)
      i.should.equal 0
    it '\\aaaaを実行すると、i が 5 アップ', ->
      mt.markups.length.should.equal 1
      [x,y,i] = mt.draw({},0,0,'\\aaaaHoehoe',0)
      i.should.equal 5
    it 'hoehoe\\aaaaを実行すると、i=0 は変かなし', ->
      mt.markups.length.should.equal 1
      [x,y,i] = mt.draw({},0,0,'hoehoe\\aaaaHoehoe',0)
      i.should.equal 0
    it 'hoehoe\\aaaaを実行すると、i=6 は 5 アップ', ->
      mt.markups.length.should.equal 1
      [x,y,i] = mt.draw({},0,0,'hoehoe\\aaaaHoehoe',6)
      i.should.equal 11
  describe '改行マークアップのテスト', ->
    [x,y,i]=[-1,-1,-1]
    msg = 'test\\ntest'
    dummy = {}
    mt = new rpg.MarkupText()
    it '改行マークアップを追加', ->
      mt.add rpg.MarkupText.MARKUP_NEW_LINE
      mt.markups.length.should.equal 1
    it msg + 'を実行すると、i=4 は改行する', ->
      mt.markups.length.should.equal 1
      [x,y,i] = mt.draw(dummy,10,0,msg,4)
    it 'x = 0 に', ->
      x.should.equal 0
    it 'y は、rpg.system.lineHeight ぶん進む', ->
      y.should.equal 32
    it 'i=6 に', ->
      i.should.equal 6
      msg[i .. ].should.equal 'test'
  describe 'マークアップが行われたかどうか', ->
    [x,y,i]=[-1,-1,-1]
    msg = 'test\\ntest'
    dummy = {}
    mt = new rpg.MarkupText()
    it '改行マークアップを追加', ->
      mt.add rpg.MarkupText.MARKUP_NEW_LINE
      mt.markups.length.should.equal 1
    it 'フラグのクリア', ->
      mt.clear()
    it 'フラグがクリアされる', ->
      mt.matched.should.equal false

  describe 'カラー', ->
    it 'カラー反映１つ', ->
      [x,y,i]=[0,0,0]
      mt = rpg.MarkupText.default
      msg = 'test\\C[5]test'
      class rpg.Window # dummy
      dummy = new rpg.Window()
      m = ''
      while i < msg.length
        [x,y,i] = mt.draw(dummy,x,y,msg,i)
        m += msg[i++]
      m.should.equal 'testtest'
      dummy.textColor.should.equal 'rgb(  0,160,233)'
    it 'カラー反映２つ', ->
      [x,y,i]=[0,0,0]
      mt = rpg.MarkupText.default
      msg = 'test\\C[1]test\\C[0]test'
      class rpg.Window # dummy
      dummy = new rpg.Window()
      m = ''
      while i < msg.length
        [x,y,i] = mt.draw(dummy,x,y,msg,i)
        m += msg[i++]
      m.should.equal 'testtesttest'
      dummy.textColor.should.equal 'rgb(255,255,255)'
