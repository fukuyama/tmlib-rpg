
# ------------

mainDir = './src/main/'
testDir = './src/test/'
demoDir = './src/demo/'
distDir = './target/'

mainScripts = [
  'common/utils'
  'common/constants'
  'common/Character'
  'common/Battler'
  'common/Actor'
  'common/Party'
  'common/Map'
  'common/Flag'
  'common/Event'
  'common/EventPage'
  'common/ItemContainer'
  'common/Item'
  'common/UsableItem'
  'common/Skill'
  'common/EquipItem'
  'common/Weapon'
  'common/Armor'
  'common/State'
  'common/Effect'
  'common/MarkupText'

  'sample'
  'tmlib/CustomizeTexture'
  'tmlib/TransitionShape'
  'core/DataBase'
  'core/System'
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
  'core/GamePlayer'
  'core/Interpreter'
  'event_command/Function'
  'event_command/Script'
  'event_command/Return'
  'event_command/Delete'
  'event_command/Character'
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
  'scene/SceneMy'
  'scene/SceneMenuTest1'
  'scene/SceneMenuTest2'
  'main'
]
dataNames= [
]
aiScripts= [
  'nz/ai/SampleAI'
]

# ------------
config =
  main:
    files: (mainDir + 'public/' + s + '.coffee' for s in mainScripts)
    outputFile: 'tmlib-rpg.min.js'
    distDir: distDir + 'public/client/'

  ai:
    files: (mainDir + 'public/' + s + '.coffee' for s in aiScripts)
    srcOption:
      base: mainDir + 'public/'
    distDir: distDir + 'public/'

  express:
    files: mainDir + 'express/**'
    distDir: distDir

  data:
    dataNames: dataNames
    srcDir: mainDir + 'data/'
    distDir: distDir + 'public/data/'

  coffeelint:
    files: mainDir + '**/*.coffee'

  test:
    files: testDir + 'common/**/*.coffee'

  test_sites: [
    {
      files: testDir + 'public/**'
      distDir: distDir + 'public/'
    }
    {
      files: demoDir + '001/img/**'
      distDir: distDir + 'public/client/img/'
    }
  ]

  server:
    rootDir: distDir

  cleanDir: distDir

module.exports = config
