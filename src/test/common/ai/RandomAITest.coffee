require('chai').should()

require('../../../main/common/utils.coffee')
require('../../../main/common/constants.coffee')

require('../../../main/common/ai/RandomAI.coffee')

require('../System.coffee')

# 価値は何か，誰にとっての価値か，実際の機能は何か
describe 'rpg.ai.RandomAI', () ->
  ai = null
  describe '初期化', ->
    ai = new rpg.ai.RandomAI()

