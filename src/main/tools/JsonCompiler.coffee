# json ファイル作成

path = require 'path'
fs   = require 'fs'

class JsonCompiler
  constructor: (@base='') ->

  compile: (obj) ->
    JSON.stringify(obj)

  _load: (name) ->
    file = path.join(@base,name)
    res = require file
    delete require.cache[file]
    return res

  compileFile: (output, input) ->
    @compileJson output, @_load(input)

  compileFileArray: (outputDir, input, key) ->
    @compileJsonArray outputDir, @_load(input), key

  compileJson: (output, obj) ->
    fs.writeFile output, @compile(obj), (err) -> throw err if err?

  compileJsonArray: (outputDir, array, key) ->
    for i in array
      name = i[key]
      delete i[key]
      fs.writeFile path.join(outputDir,name + '.json'), @compile(i),
        (err) -> throw err if err?

module.exports = new JsonCompiler()
