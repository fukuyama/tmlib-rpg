# json ファイル作成

path = require 'path'
fs   = require 'fs'

class JsonCompiler
  constructor: (@base='') ->

  compile: (obj) ->
    JSON.stringify(obj)

  compileFile: (output, input) ->
    @compileJson(output, require path.join(@base,input))

  compileJson: (output, obj) ->
    fs.writeFile output, @compile(obj), (err) -> throw err if err?

  compileJsonArray: (outputDir, array, key) ->
    for i in array
      fs.writeFile path.join(outputDir,i[key] + '.json'), @compile(i),
        (err) -> throw err if err?

module.exports = new JsonCompiler()
