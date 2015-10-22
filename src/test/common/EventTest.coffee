
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/Character.coffee')
require('../../main/common/Flag.coffee')
require('../../main/common/EventPage.coffee')
require('../../main/common/Event.coffee')

require('../../test/common/System.coffee')

describe 'rpg.Event', () ->
  rpg.game = {}
  rpg.game.flag = new rpg.Flag()

  describe '引数なしで初期化', ->
    event = new rpg.Event()
    it 'name は 空', ->
      event.name.should.equal ''
  describe 'page １つで初期化', ->
    event = new rpg.Event(
      name: 'event1'
      pages: [
        {
          name: 'page1'
          condition: []
          trigger: ['talk']
          commands: [
            {
              type:'message'
              params:[
                'TEST'
              ]
            }
          ]
        }
      ]
    )
    it 'name は event1', ->
      event.name.should.equal 'event1'
    it '最初のページを選択', ->
      event.currentPage.name.should.equal 'page1'
  describe 'page ２つで初期化', ->
    event = new rpg.Event(
      name: 'event1'
      pages: [
        {
          name: 'page1'
          condition: []
          trigger: ['talk']
          commands: [
            {
              type:'message'
              params:[
                'TEST2'
              ]
            }
          ]
        },
        {
          name: 'page2'
          condition: [
            {type: 'flag.on?', params: ['flg1']}
          ]
          trigger: ['check']
          commands: [
            {
              type:'message'
              params:[
                'TEST1'
              ]
            }
          ]
        }
      ]
    )
    it 'フラグがなければ page1', ->
      event.currentPage.name.should.equal 'page1'
    it 'フラグががあると、page2', ->
      rpg.game.flag.on 'flg1'
      event.checkPage()
      event.currentPage.name.should.equal 'page2'
    it 'フラグが off だと話す', ->
      rpg.game.flag.off 'flg1'
      event.checkPage()
      event.triggerTalk().should.equal true
      event.triggerCheck().should.equal false
    it 'comamnds の message が　TEST2', ->
      event.commands[0].type.should.equal 'message'
      event.commands[0].params.should.deep.equal ['TEST2']
    it 'フラグが on だとしらべる', ->
      rpg.game.flag.on 'flg1'
      event.checkPage()
      event.triggerTalk().should.equal false
      event.triggerCheck().should.equal true
    it 'comamnds の message が　TEST1', ->
      event.commands[0].type.should.equal 'message'
      event.commands[0].params.should.deep.equal ['TEST1']
      


  describe 'trigger: talk で初期化', ->
    event = new rpg.Event(
      name: 'event1'
      pages: [
        {
          name: 'page1'
          condition: []
          trigger: ['talk']
          commands: [
            {
              type:'message'
              params:[
                'TEST'
              ]
            }
          ]
        }
      ]
    )
    it 'triggerTalk を実行すると true', ->
      event.triggerTalk().should.equal true
    it 'その他は false', ->
      event.triggerCheck().should.equal false
      event.triggerTouch().should.equal false
      event.triggerTouched().should.equal false
      event.triggerAuto().should.equal false
      event.triggerParallel().should.equal false
    it 'データ変更', ->
      event.pages[0].trigger[0] = 'check'
    it 'triggerCheck を実行すると true', ->
      event.triggerCheck().should.equal true
    it 'その他は false', ->
      event.triggerTalk().should.equal false
      event.triggerTouch().should.equal false
      event.triggerTouched().should.equal false
      event.triggerAuto().should.equal false
      event.triggerParallel().should.equal false
    it 'データ変更', ->
      event.pages[0].trigger[0] = 'touch'
    it 'triggerTouch を実行すると true', ->
      event.triggerTouch().should.equal true
    it 'その他は false', ->
      event.triggerTalk().should.equal false
      event.triggerCheck().should.equal false
      event.triggerTouched().should.equal false
      event.triggerAuto().should.equal false
      event.triggerParallel().should.equal false
