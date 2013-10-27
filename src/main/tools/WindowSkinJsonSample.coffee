# ウィンドウスキン素材の仕様(VXAce 風)
sys = require 'sys'
sys.print JSON.stringify({
  image: 'windowskin.vxace'
  borderWidth: 16
  borderHeight: 16
  backgroundPadding: 2
  spec:
    backgrounds: [
      [0,0,64,64]
      [0,64,64,64]
    ]
    topLeft: [64, 0, 16, 16]
    topRight: [128 - 16, 0, 16, 16]
    bottomLeft: [64, 64 - 16, 16, 16]
    bottomRight: [128 - 16, 64 - 16, 16, 16]
    borderTop: [64 + 16, 0, 16, 16]
    borderBottom: [64 + 16, 64 - 16, 16, 16]
    borderLeft: [64, 16, 16, 16]
    borderRight: [128 - 16, 16, 16, 16]
  },null,4)
