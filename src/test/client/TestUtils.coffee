_g = window ? global ? @

# メッセージ表示したつもり関数
_g.message_clear = ->
  rpg.system.temp.message = null
  if rpg.system.temp.messageEndProc?
    rpg.system.temp.messageEndProc()
  rpg.system.temp.messageEndProc = null

# キー操作エミュレーション
_g.emulate_key = (key,callback) ->
  setTimeout(->
    rpg.system.app.keyboard.setKey(key,true)
  150)
  setTimeout(->
    rpg.system.app.keyboard.setKey(key,false)
  300)
  setTimeout(->
    callback()
  400)
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
    pc = rpg.system.player.character
    url = "http://localhost:3000/client/data/map/#{mapid}.json"
    return map?.url == url and
      pc.mapX == x and
      pc.mapY == y and
      pc.direction == dir
