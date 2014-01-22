# constant
root = window ? global ? @

root.SAMPLE_SYSTEM_LOAD_ASSETS = root.SAMPLE_SYSTEM_LOAD_ASSETS ? []

root.SYSTEM_ASSETS =
  'system.se.menu_decision': 'audio/se/fin.mp3'
  'system.se.menu_cursor_move': 'audio/se/fon.mp3'
  'windowskin.image': 'img/test_windowskin.png'
  'scene.title.background.image': 'img/test_001.png'
  system:
    type: 'json'
    src:
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
              name:'Test0'
              next:
                scene:'SceneMy'
            },{
              name:'Test1'
              next:
                scene:'SceneMenuTest1'
            },{
              name:'Test2'
              next:
                scene:'SceneMenuTest2'
            },{
              name:'Map'
              action: 'NewGame'
              next:
                scene:'SceneMap'
                param:
                  mapName: '001'
                  mapData: 'data/map/001.json'
            }
          ]
        }
        assets: root.SAMPLE_SYSTEM_LOAD_ASSETS
      assets: {}
      loadingSceneDefault:
        gauge:
          color: 'rgb(96,96,96)'
          width: 32 * 25
          y: 32 * 15 - 10
      windowDefault: {}

root.SAMPLE_SYSTEM_LOAD_ASSETS.push
  'i1': 'img/hiyoco_nomal_full.png'
  'i2': 'img/test_character.png'

root.SAMPLE_SYSTEM_LOAD_ASSETS.push
  'test':
    type: 'texture_'
    src:
      images: [
        'i1'
        'i2'
      ]
      width: 192
      height: 96
    'sample.spritesheet.test':
      _type: 'tmss'
      image: 'test'
      frame:
        width: 32
        height: 32
        count: 18
      animations:
        down: frames: [7,6,7,8], next: 'down', frequency: 4
        up: frames: [10,9,10,11], next: 'up', frequency: 4
        left: frames: [13,12,13,14], next: 'left', frequency: 4
        right: frames: [16,15,16,17], next: 'right', frequency: 4
