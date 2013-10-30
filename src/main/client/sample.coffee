# constant
root = window ? global ? @

root.SAMPLE_SYSTEM_LOAD_ASSETS = root.SAMPLE_SYSTEM_LOAD_ASSETS ? []

root.SYSTEM_ASSETS =
  system:
    _type: 'json'
    main:
      scene: 'SceneTitle'
      param: 'scene.title'
      assets: root.SAMPLE_SYSTEM_LOAD_ASSETS
    loadingSceneDefault:
      gauge:
        color: 'rgb(96,96,96)'
        width: 40 * 10
        y: 32 * 10 - 10
    windowDefault:
      windowskin: 'windowskin.config'
    'screen':
      width: 40 * 10
      height: 32 * 10
      background: 'rgb(255,255,255)'

root.SAMPLE_SYSTEM_LOAD_ASSETS.push
  'system.se.menu_decision': 'audio/se/fin.mp3'
  'system.se.menu_cursor_move': 'audio/se/fon.mp3'
  'i1': 'img/hiyoco_nomal_full.png'
  'i2': 'img/test_character.png'
  'windowskin.image': 'img/test_windowskin.png'
  'scene.title.background.image': 'img/test_001.png'

root.SAMPLE_SYSTEM_LOAD_ASSETS.push
  'windowskin.config':
    _type: 'json'
    image: 'windowskin.image'
    borderWidth: 16
    borderHeight: 16
    backgroundPadding: 2
    backgroundColor: 'rgba(0,0,0,0)'
    spec:
      backgrounds: [
        [16,16,32,32]
      ]
      topLeft: [0,0,16,16]
      topRight: [64-16,0,16,16]
      bottomLeft: [0,64-16,16,16]
      bottomRight: [64-16,64-16,16,16]
      borderTop: [16,0,32,16]
      borderBottom: [16,64-16,32,16]
      borderLeft: [0,16,16,32]
      borderRight: [64-16,16,16,32]
  'scene.title':
    _type: 'json'
    background:
      image: 'scene.title.background.image'
    menus: [{
        name:'New'
        next:
          scene:'SceneMap'
      },{
        name:'Load'
        next:
          scene:''
      },{
        name:'Exit'
        next:
          scene:''
      },{
        name:'Test'
        next:
          scene:'SceneMain'
      }
    ]
  'test':
    _type: 'texture_'
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
