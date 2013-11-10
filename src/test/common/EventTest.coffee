
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/Character.coffee')
require('../../main/common/Flag.coffee')
require('../../main/common/Event.coffee')
require('../../main/common/EventPage.coffee')

describe 'rpg.Event', () ->
  rpg.system = rpg.system ? {}
  rpg.system.flag = new rpg.Flag()

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
