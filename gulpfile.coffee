config = require './buildconfig.coffee'
gulp   = require 'gulp'

require('require-dir') './gulp'

gulp.task 'default', [
  'test'
  'build'
]

gulp.task 'serve', [
  'server:start'
]

gulp.task 'test', [
  'coffeelint'
  'test_console'
]

gulp.task 'build', [
  'build_express'
  'build_test_site'
  'build_main_script'
  'build_main_script:uglify'
  'build_test_script'
  'build_rpg'
]

gulp.task 'watch', [
  'test_console:watch'
  'build_express:watch'
  'build_main_script:watch'
  'build_test_script:watch'
  'build_rpg:watch'
  'server:watch'
]
