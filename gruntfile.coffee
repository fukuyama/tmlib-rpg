
# tmlib-rpg gruntfile
module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'

  # 共通系のスクリプト(tmlib.js 非依存のつもり)
  common_sections = [
      'common/utils'
      'common/Character'
      'common/Map'
      'common/Flag'
      'common/Event'
      'common/EventPage'
  ]
  # クライアントのスクリプト
  client_sections = [
      'sample'
      'tmlib/CustomizeTexture'
      'core/System'
      'core/SpriteCharacter'
      'core/SpriteCursor'
      'core/SpriteMap'
      'core/EventHandler'
      'core/WindowSkin'
      'core/WindowContent'
      'core/Window'
      'core/WindowMenu'
      'core/WindowMessage'
      'core/GamePlayer'
      'core/Interpreter'
      'scene/SceneBase'
      'scene/SceneLoading'
      'scene/SceneMain'
      'scene/SceneTitle'
      'scene/SceneMap'
      'scene/SceneMenuTest1'
      'scene/SceneMenuTest2'
      'main'
  ]

  genPath = 'target/generate/'
  
  coffeeConfig =
    options: {
      bare: false
    }

  watchConfig =
    express:
      files: ['target/**']
      tasks: ['express:dev']
      options:
        spawn: false
    public:
      files: ['src/**/*.html']
      tasks: ['copy']
    test_scripts:
      files: ['src/test/**/*.coffee']
      tasks: [
        'coffeelint', 'simplemocha'
      ]

  for f in common_sections
    js = "#{genPath}#{f}.js"
    coffee = "src/main/#{f}.coffee"
    coffeeConfig[f] = {}
    coffeeConfig[f].files = {}
    coffeeConfig[f].files[js] = coffee
    watchConfig[f] = {
      files: [coffee]
      tasks: ['coffeelint',"coffee:#{f}",'simplemocha','concat','uglify']
    }

  for f in client_sections
    js = "#{genPath}client/#{f}.js"
    coffee = "src/main/client/#{f}.coffee"
    coffeeConfig[f] = {}
    coffeeConfig[f].files = {}
    coffeeConfig[f].files[js] = coffee
    watchConfig[f] = {
      files: [coffee]
      tasks: ['coffeelint',"coffee:#{f}",'simplemocha','concat','uglify']
    }

  grunt.initConfig
    coffeelint:
      all:
        files:
          src: [
            'gruntfile.coffee'
            'src/**/*.coffee'
          ]
    simplemocha:
      options:
        reporter: 'nyan'
        ui: 'bdd'
      all:
        src: ['src/test/**/*.coffee']
    coffee: coffeeConfig
    concat:
      options:
        separator: ';'
      client_scripts:
        src: [
          (genPath + sec + '.js' for sec in common_sections)
          (genPath + 'client/' + sec + '.js' for sec in client_sections)
        ]
        dest: 'target/public/client/main.js'
    uglify:
      client_scripts:
        files:
          'target/public/client/main.min.js': ['target/public/client/main.js']

    copy:
      client:
        expand: true
        flatten: false
        cwd: 'src/main/client/public/'
        src: ['**']
        dest: 'target/public/client/'
      express:
        expand: true
        cwd: 'src/main/express/'
        src: ['**']
        dest: 'target/'

    express:
      options:
        background: true
      dev:
        options:
          script: 'target/app.js'

    clean:
      target: ['target']

    watch: watchConfig

  for o of pkg.devDependencies
    grunt.loadNpmTasks o if /grunt-/.test o
  
  grunt.registerTask 'server', ['express:dev', 'watch']
  grunt.registerTask 'test', ['coffeelint','simplemocha']
  grunt.registerTask 'default', [
    'coffeelint','coffee', 'simplemocha'
    'concat', 'uglify', 'copy'
  ]
