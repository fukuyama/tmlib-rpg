config     = require '../buildconfig.coffee'
gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
sourcemaps = require 'gulp-sourcemaps'
fs         = require 'fs'
mkdirp     = require 'mkdirp'

gulp.task 'build_test_script', ['build_test_site'], (cb) ->
  {
    files
    distDir
  } = config.test.browser
  mkdirp distDir, (err) ->
    if err? and err.code isnt 'EEXIST'
      cb(err)
      return
    gulp.src files
      .pipe sourcemaps.init()
      .pipe coffee()
      .pipe sourcemaps.write('.', {addComment: true})
      .pipe gulp.dest(distDir)
      .on 'end', -> cb()


gulp.task 'build_test_script:watch', ->
  {
    files
  } = config.test.browser
  gulp.watch files, ['build_test_script']
