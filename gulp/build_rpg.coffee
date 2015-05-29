config = require '../buildconfig.coffee'
gulp   = require 'gulp'
glob   = require 'glob'
fs     = require 'fs'
rpgc   = require '../src/main/tools/RPGCompiler'

rpg_compiler_callback = (param) ->
	(cb) ->
    {
      inputDir
      outputDir
    } = param
    if fs.existsSync(op.inputDir) and fs.existsSync(op.outputDir)
      glob inputDir + '*/*.coffee', (err,matches) ->
      op.src = grunt.file.expand({cwd:op.inputDir},'*/*.coffee')
      op.src.push 'system.coffee'
      rpgc.compile(op)
    return

# gulp.task 'build_rpg:sample', rpg_compiler_callback(config.rpg.sample)
