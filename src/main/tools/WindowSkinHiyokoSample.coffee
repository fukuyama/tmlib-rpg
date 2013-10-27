# ウィンドウスキン素材の仕様(Hiyoko 風)
sys = require 'sys'
sys.print JSON.stringify
  _type: 'json'
  image: 'windowskin.hiyoko'
  borderWidth: 32
  borderHeight: 32
  backgroundPadding: 2
  spec:
    backgrounds: [
      [32,32,64,64]
    ]
    topLeft: [0, 0, 32, 32]
    topRight: [320 - 32, 0, 32, 32]
    bottomLeft: [0, 320 - 32, 32, 32]
    bottomRight: [320 - 32, 320 - 32, 32, 32]
    borderTop: [32, 0, 32, 32]
    borderBottom: [32, 320 - 32, 32, 32]
    borderLeft: [0, 32, 32, 32]
    borderRight: [320 - 32, 32, 32, 32]
