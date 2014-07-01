require('../../common/utils')
require('../../common/constants')

module.exports = {
  'screen':
    width: 32 * 25
    height: 32 * 15
    background: 'rgb(255,255,255)'
  main:
    scene: 'SceneTitle'
    key: 'scene.title'
    src: {
      background:
        image: 'scene.title.background.image'
      menus: [
        {
          name:'NewGame'
          action: 'NewGame'
        }
        {
          name:'Test'
          next:
            scene:'SceneMy'
        }
      ]
    }
    assets : [
      'scene.title.background.image': 'img/test_001.png'
      'system.se.menu_decision': 'audio/se/fin.mp3'
      'system.se.menu_cursor_move': 'audio/se/fon.mp3'
      'windowskin.image': 'img/test_windowskin2.png'
      'sample.spritesheet': {src: 'data/spritesheet/hiyoko.json',type:'tmss'}
    ]
  assets: {
    'i1': 'img/hiyoco_nomal_full.png'
    'i2': 'img/test_character.png'
  }
  loadingSceneDefault:
    gauge:
      color: 'rgb(96,96,96)'
      width: 32 * 25
      y: 32 * 15 - 10
  windowDefault: {}
}
