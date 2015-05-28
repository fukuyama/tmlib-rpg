config = require '../buildconfig.coffee'
gulp   = require 'gulp'

gulp.task 'build_test_site', ->
  for o in config.test_sites
    {
      files
      distDir
    } = o
    gulp.src files
      .pipe gulp.dest(distDir)

gulp.task 'build_test_site:watch', ->
  for o in config.test_sites
    {
      files
    } = o
    gulp.watch files, ['build_test_site']
