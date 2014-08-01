
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/Character.coffee')
require('../../main/common/Flag.coffee')
require('../../main/common/EventPage.coffee')

describe 'rpg.EventPage', () ->
  rpg.system = rpg.system ? {}
  rpg.game = {}
  rpg.game.flag = new rpg.Flag()

  describe '引数なしで初期化', ->
    page = new rpg.EventPage()
    it 'name は 空', ->
      page.name.should.equal ''
  describe '条件なしで初期化', ->
    page = new rpg.EventPage
      name: 'page1'
      condition: []
    it 'checkCondition で true', ->
      page.checkCondition().should.equal true
  describe '名前(page1)と条件つき初期化 flag=flg1', ->
    page = new rpg.EventPage
      name: 'page1'
      condition: [
        {type: 'flag.on?', params: ['flg1']}
      ]
    it '名前に page1 が設定されている', ->
      page.name.should.equal 'page1'
    it '条件が設定されている', ->
      page.condition.should.have.length 1
      page.condition[0].type.should.equal 'flag.on?'
      page.condition[0].params.should.deep.equal ['flg1']
    it 'flg1 が on の場合 checkCondition で true (Flag渡し)', ->
      flag = new rpg.Flag()
      flag.on 'flg1'
      rpg.game.flag.off 'flg1'
      page.checkCondition(flag).should.equal true
    it 'flg1 が off の場合 checkCondition で false (Flag渡し)', ->
      flag = new rpg.Flag()
      flag.off 'flg1'
      rpg.game.flag.on 'flg1'
      page.checkCondition(flag).should.equal false
    it 'flg1 が on の場合 checkCondition で true (system Flag)', ->
      rpg.game.flag.on 'flg1'
      page.checkCondition().should.equal true
    it 'flg1 が off の場合 checkCondition で false (system Flag)', ->
      rpg.game.flag.off 'flg1'
      page.checkCondition().should.equal false
  describe '名前(page1)と条件つき初期化 flag=flg1 url=http://test.test/', ->
    page = new rpg.EventPage
      name: 'page1'
      condition: [
        {type: 'flag.on?', params: ['flg1','http://test.test/']}
      ]
    it '名前に page1 が設定されている', ->
      page.name.should.equal 'page1'
    it '条件が設定されている', ->
      page.condition.should.have.length 1
      page.condition[0].type.should.equal 'flag.on?'
      page.condition[0].params.should.deep.equal ['flg1','http://test.test/']
    it 'flg1 が on の場合 checkCondition で false (url 違い)', ->
      flag = new rpg.Flag()
      flag.on 'flg1'
      page.checkCondition(flag).should.equal false
    it 'flg1 が on の場合 checkCondition で true (url 一致)', ->
      flag = new rpg.Flag(url:'http://test.test/')
      flag.on 'flg1'
      page.checkCondition(flag).should.equal true
  describe 'off? 条件動作確認', ->
    page = new rpg.EventPage
      name: 'page1'
      condition: [
        {type: 'flag.off?', params: ['flg1']}
      ]
    it 'flg1 が on の場合 checkCondition で false', ->
      flag = new rpg.Flag()
      flag.on 'flg1'
      page.checkCondition(flag).should.equal false
    it 'flg1 が off の場合 checkCondition で true', ->
      flag = new rpg.Flag()
      flag.off 'flg1'
      page.checkCondition(flag).should.equal true
  describe '論理条件の動作、複数の condition flg1 and flg2', ->
    page = new rpg.EventPage
      name: 'page2'
      condition: [
        {type: 'flag.on?', params: ['flg1']}
        {type: 'flag.on?', params: ['flg2']}
      ]
    it 'flg1=on flg2=on の場合は、true', ->
      rpg.game.flag.on 'flg1'
      rpg.game.flag.on 'flg2'
      page.checkCondition().should.equal true
    it 'flg1=on flg2=off の場合は、false', ->
      rpg.game.flag.on 'flg1'
      rpg.game.flag.off 'flg2'
      page.checkCondition().should.equal false
    it 'flg1=off flg2=on の場合は、false', ->
      rpg.game.flag.off 'flg1'
      rpg.game.flag.on 'flg2'
      page.checkCondition().should.equal false
    it 'flg1=off flg2=off の場合は、false', ->
      rpg.game.flag.off 'flg1'
      rpg.game.flag.off 'flg2'
      page.checkCondition().should.equal false
  describe '論理条件の動作、複数の condition flg1 or flg2', ->
    page = new rpg.EventPage
      name: 'page2'
      condition: [
        {type: 'flag.on?', params: ['flg1']}
        {type: 'flag.on?', params: ['flg2']}
      ]
      conditionLogic: 'or'
    it 'flg1=on flg2=on の場合は、true', ->
      rpg.game.flag.on 'flg1'
      rpg.game.flag.on 'flg2'
      page.checkCondition().should.equal true
    it 'flg1=on flg2=off の場合は、false', ->
      rpg.game.flag.on 'flg1'
      rpg.game.flag.off 'flg2'
      page.checkCondition().should.equal true
    it 'flg1=off flg2=on の場合は、false', ->
      rpg.game.flag.off 'flg1'
      rpg.game.flag.on 'flg2'
      page.checkCondition().should.equal true
    it 'flg1=off flg2=off の場合は、false', ->
      rpg.game.flag.off 'flg1'
      rpg.game.flag.off 'flg2'
      page.checkCondition().should.equal false
      ''
  describe '数値条件 flg1 が 10 より大きいかどうか', ->
    page = new rpg.EventPage
      name: 'page2'
      condition: [
        {type: 'flag.>', params: ['flg1',10]}
      ]
    it 'flg1 が 9 だと checkCondition() は、 false', ->
      rpg.game.flag.set 'flg1', 9
      page.checkCondition().should.equal false
    it 'flg1 が 10 だと checkCondition() は、 false', ->
      rpg.game.flag.set 'flg1', 10
      page.checkCondition().should.equal false
    it 'flg1 が 11 だと checkCondition() は、 true', ->
      rpg.game.flag.set 'flg1', 11
      page.checkCondition().should.equal true
    it 'flg1 が off だと checkCondition() は、 false', ->
      rpg.game.flag.off 'flg1'
      page.checkCondition().should.equal false
    it 'flg1 が on だと 1 なので false', ->
      rpg.game.flag.on 'flg1'
      page.checkCondition().should.equal false
  describe '数値条件 flg1 が 10 より小さいかどうか', ->
    page = new rpg.EventPage
      name: 'page2'
      condition: [
        {type: 'flag.<', params: ['flg1',10]}
      ]
    it 'flg1 が 9 だと checkCondition() は、 true', ->
      rpg.game.flag.set 'flg1', 9
      page.checkCondition().should.equal true
    it 'flg1 が 10 だと checkCondition() は、 false', ->
      rpg.game.flag.set 'flg1', 10
      page.checkCondition().should.equal false
    it 'flg1 が 11 だと checkCondition() は、 false', ->
      rpg.game.flag.set 'flg1', 11
      page.checkCondition().should.equal false
    it 'flg1 が off だと checkCondition() は、 true', ->
      rpg.game.flag.off 'flg1'
      page.checkCondition().should.equal true
    it 'flg1 が on だと 1 なので true', ->
      rpg.game.flag.on 'flg1'
      page.checkCondition().should.equal true
  describe '数値条件 flg1 が 10 と等しいかどうか', ->
    page = new rpg.EventPage
      name: 'page2'
      condition: [
        {type: 'flag.==', params: ['flg1',10]}
      ]
    it 'flg1 が 9 だと checkCondition() は、 false', ->
      rpg.game.flag.set 'flg1', 9
      page.checkCondition().should.equal false
    it 'flg1 が 10 だと checkCondition() は、 true', ->
      rpg.game.flag.set 'flg1', 10
      page.checkCondition().should.equal true
    it 'flg1 が 11 だと checkCondition() は、 false', ->
      rpg.game.flag.set 'flg1', 11
      page.checkCondition().should.equal false
    it 'flg1 が off だと checkCondition() は、 false', ->
      rpg.game.flag.off 'flg1'
      page.checkCondition().should.equal false
    it 'flg1 が on だと 1 なので false', ->
      rpg.game.flag.on 'flg1'
      page.checkCondition().should.equal false
      ''

  # トリガー仕様
  describe 'トリガー仕様', ->
    describe '話された場合の設定', ->
      page = new rpg.EventPage
        name: 'page2'
        trigger: [
          'talk'
        ]
      it '話された場合 true', ->
        page.triggerTalk().should.equal true
      it 'その他は false', ->
        page.triggerCheck().should.equal false
        page.triggerTouch().should.equal false
        page.triggerTouched().should.equal false
        page.triggerAuto().should.equal false
        page.triggerParallel().should.equal false
    describe 'しらべられた場合の設定', ->
      page = new rpg.EventPage
        name: 'page2'
        trigger: [
          'check'
        ]
      it 'しらべられた場合 true', ->
        page.triggerCheck().should.equal true
      it 'その他は false', ->
        page.triggerTalk().should.equal false
        page.triggerTouch().should.equal false
        page.triggerTouched().should.equal false
        page.triggerAuto().should.equal false
        page.triggerParallel().should.equal false
    describe '接触した場合の設定', ->
      page = new rpg.EventPage
        name: 'page2'
        trigger: [
          'touch'
        ]
      it '接触した場合 true', ->
        page.triggerTouch().should.equal true
      it 'その他は false', ->
        page.triggerTalk().should.equal false
        page.triggerCheck().should.equal false
        page.triggerTouched().should.equal false
        page.triggerAuto().should.equal false
        page.triggerParallel().should.equal false
    describe '接触された場合の設定', ->
      page = new rpg.EventPage
        name: 'page2'
        trigger: [
          'touched'
        ]
      it '接触された場合 true', ->
        page.triggerTouched().should.equal true
      it 'その他は false', ->
        page.triggerTalk().should.equal false
        page.triggerCheck().should.equal false
        page.triggerTouch().should.equal false
        page.triggerAuto().should.equal false
        page.triggerParallel().should.equal false
    describe '自動実行の場合の設定', ->
      page = new rpg.EventPage
        name: 'page2'
        trigger: [
          'auto'
        ]
      it '自動実行の場合 true', ->
        page.triggerAuto().should.equal true
      it 'その他は false', ->
        page.triggerTalk().should.equal false
        page.triggerCheck().should.equal false
        page.triggerTouch().should.equal false
        page.triggerTouched().should.equal false
        page.triggerParallel().should.equal false
    describe '並列実行の場合の設定', ->
      page = new rpg.EventPage
        name: 'page2'
        trigger: [
          'parallel'
        ]
      it '並列実行の場合 true', ->
        page.triggerParallel().should.equal true
      it 'その他は false', ->
        page.triggerTalk().should.equal false
        page.triggerCheck().should.equal false
        page.triggerTouch().should.equal false
        page.triggerTouched().should.equal false
        page.triggerAuto().should.equal false
    describe '話すとしらべる', ->
      page = new rpg.EventPage
        name: 'page2'
        trigger: [
          'talk'
          'check'
        ]
      it '話された場合 true', ->
        page.triggerTalk().should.equal true
      it 'しらべられた場合 true', ->
        page.triggerCheck().should.equal true
      it 'その他は false', ->
        page.triggerTouch().should.equal false
        page.triggerTouched().should.equal false
        page.triggerAuto().should.equal false
        page.triggerParallel().should.equal false
