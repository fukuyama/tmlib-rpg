_g = window ? global ? @

# メッセージ表示したつもり関数
_g.message_clear = ->
  rpg.system.temp.message = null
  if rpg.system.temp.messageEndProc?
    rpg.system.temp.messageEndProc()
  rpg.system.temp.messageEndProc = null

# キー操作エミュレーション
_g.emulate_key = (key,callback) ->
  if arguments.length == 1
    {
      key
      callback
    } = arguments[0]
  setTimeout(->
    rpg.system.app.keyboard.setKey(key,true)
  150)
  setTimeout(->
    rpg.system.app.keyboard.setKey(key,false)
  300)
  setTimeout(->
    callback()
  400)

_g.emulateKey = _g.emulate_key

loadFlg = false
# テスト用マップロード
_g.loadTestMap = (done) ->
  if loadFlg
    done()
    return
  loadFlg = true
  rpg.system.newGame()
  checkWait done, -> rpg.system.scene.name == 'SceneMap'

_g.reloadTestMap = (done) ->
  rpg.system.newGame()
  checkWait done, -> rpg.system.scene.name == 'SceneMap'

_g.checkWait = (done,fn) ->
  check = ->
    if fn.call()
      done()
      check = null
    else
      setTimeout(check,100)
  check()

_g.checkMapMove =  (mapid,x,y,dir,done) ->
  checkWait done, ->
    map = rpg.system.scene.map
    pc = rpg.game.player.character
    url = "http://localhost:3000/client/sample/map/#{mapid}.json"
    return map?.url == url and
      pc.mapX == x and
      pc.mapY == y and
      pc.direction == dir

_g.getMessage = -> rpg.system.scene?.windowMessage?.currentMessage

_g.checkMessage = (callback,msg) ->
  if arguments.length == 1
    {
      callback
      msg
    } = arguments[0]
  checkWait callback, ->
    w = rpg.system.scene?.windowMessage
    return w? and w.currentMessage == msg and w.isPause()

_g.checkMessageClose = (callback) ->
  checkWait callback, ->
    w = rpg.system.scene?.windowMessage
    return w? and w.isClose()

_g.getMenu = () ->
  w = rpg.system.scene.windowMapMenu
  if w?
    w = w.findWindowTree (w) -> w.active
  if w instanceof rpg.WindowMenu
    return w.menus[w.index]
  return ''
