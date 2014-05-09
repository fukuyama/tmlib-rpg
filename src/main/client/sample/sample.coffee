sample_files = [
  'map/001'
  'item/001'
  'state/001'
]

target = 'target'
main = '../../'

jc = require "#{main}tools/JsonCompiler"

path = require 'path'
fs   = require 'fs'

jc.base = path.dirname fs.realpathSync(__filename)

outputDir = path.join(target, 'public/client/data')
for i in ['map','item','state']
  dirnm = path.join(outputDir,i)
  fs.mkdirSync(dirnm) unless fs.existsSync(dirnm)

for name in sample_files
  file = path.join(outputDir, name + '.json')
  jc.compileFile file, name

# itemlist
jc.compileJsonArray(
  path.join(outputDir,'item')
  require path.join(jc.base,'itemlist')
  'item'
)

# statelist
jc.compileJsonArray(
  path.join(outputDir,'state')
  require path.join(jc.base,'statelist')
  'state'
)
