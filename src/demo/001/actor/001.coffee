path = require 'path'
base = path.dirname module.filename
require path.relative(base,'./src/main/common/utils')
require path.relative(base,'./src/main/common/constants')

module.exports = {
  name: 'ひよこ'
  base:
    str: 10 # ちから
    vit: 10 # たいりょく
    dex: 10 # きようさ
    agi: 10 # すばやさ
    int: 10 # かしこさ
    sen: 10 # かんせい
    luc: 10 # うんのよさ
    cha: 10 # みりょく
    basehp: 10 # HP
    basemp: 10 # MP
}
