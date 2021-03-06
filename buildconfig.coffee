argv = require('yargs').argv

# ------------

mainDir = './src/main/'
testDir = './src/test/'
dataDir = './src/data/'
distDir = './target/'

clientScripts = [
  'tmlib/CustomizeTexture'
  'tmlib/TransitionShape'
  'core/DataBase'
  'core/System'
  'core/ShapeMessageLine'
  'core/SpriteCharacter'
  'core/SpriteCursor'
  'core/SpriteMap'
  'core/SpritesetPicture'
  'core/SpritesetAnimation'
  'core/EventHandler'
  'core/WindowSkin'
  'core/Window'
  'core/WindowMenu'
  'core/WindowInputNum'
  'core/WindowMessage'
  'core/WindowMapMenu'
  'core/WindowOperation'
  'core/WindowMemberBase'
  'core/WindowStatusActorList'
  'core/WindowStatusEquip'
  'core/WindowStatusInfo'
  'core/WindowStatusDetail'
  'core/WindowMapStatus'
  'core/WindowItemActorList'
  'core/WindowItemListBase'
  'core/WindowItemList'
  'core/WindowItemMenu'
  'core/WindowItemTradeActorList'
  'core/WindowItemTradeList'
  'core/WindowItemTargetActorList'
  'core/WindowItemShop'
  'core/WindowCash'
  'core/WindowBattleMenu'
  'core/WindowBattleTarget'
  'core/GamePlayer'
  'core/Interpreter'
  'event_command/Function'
  'event_command/Script'
  'event_command/Return'
  'event_command/Delete'
  'event_command/CharacterProprties'
  'event_command/Transition'
  'event_command/Wait'
  'event_command/Move'
  'event_command/Message'
  'event_command/Option'
  'event_command/Select'
  'event_command/InputNum'
  'event_command/Flag'
  'event_command/Block'
  'event_command/IfElse'
  'event_command/Loop'
  'event_command/End'
  'event_command/Item'
  'event_command/Shop'
  'event_command/Cash'
  'event_command/Picture'
  'event_command/Animation'
  'core/EventGenerator'
  'scene/SceneBase'
  'scene/SceneLoading3'
  'scene/SceneMain'
  'scene/SceneTitle'
  'scene/SceneMap'
  'scene/SceneBattle'

  #'scene/SceneMy'
  #'scene/SceneMenuTest1'
  #'scene/SceneMenuTest2'

  'main'
]
commonScripts = [
  'common/utils'
  'common/constants'
  'common/Character'
  'common/Battler'
  'common/Actor'
  'common/Party'
  'common/Enemy'
  'common/Troop'
  'common/Map'
  'common/Flag'
  'common/Event'
  'common/EventPage'
  'common/ItemContainer'
  'common/Item'
  'common/UsableCounter'
  'common/Skill'
  'common/EquipItem'
  'common/Weapon'
  'common/Armor'
  'common/State'
  'common/Effect'
  'common/MarkupText'
  'common/ai/RandomAI'
]
mainScripts = commonScripts.concat('client/' + s for s in clientScripts)

testFiles = testDir + 'common/**/*.coffee'
if argv.testFile?
  testFiles = testDir + "common/**/#{argv.testFile}.coffee"

# ------------
config =
  common:
    files: (mainDir + path + '.coffee' for path in commonScripts)

  main:
    files: (mainDir + path + '.coffee' for path in mainScripts)
    outputFile: 'tmlib-rpg'
    distDir: distDir + 'public/client/'

  rpg:
    test:
      inputDir: dataDir + 'test/'
      outputDir: distDir + 'public/client/rpg/test/'
    demo001:
      inputDir: dataDir + '001/'
      outputDir: distDir + 'public/client/rpg/001/'

  express:
    files: mainDir + 'express/**'
    distDir: distDir

  coffeelint:
    files: mainDir + '**/*.coffee'

  test:
    console:
      files: testFiles
    browser:
      files: testDir + 'client/*.coffee'
      distDir: distDir + 'public/client/test/'

  test_sites: [
    {
      files: testDir + 'public/**'
      distDir: distDir + 'public/'
    }
    {
      files: dataDir + '001/img/**'
      distDir: distDir + 'public/client/img/'
    }
  ]

  server:
    rootDir: distDir

  cleanDir: distDir

module.exports = config
