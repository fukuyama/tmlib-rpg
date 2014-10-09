###*
* @file Shop.coffee
* お店イベント
###

tm.define 'rpg.event_command.ShopItemMenu',

  ###* イベントコマンドの反映。
  * Interpreter インスタンスのメソッドとして実行される。
  * イベントコマンド自体のインスタンスは、@event_command で取得する。
  * @memberof rpg.event_command.ShopItemMenu#
  * @return {boolean} メニュー表示中は、true
  ###
  apply_command: (param) ->
    unless @_shop_window?
      @waitFlag = true
      self = @
      rpg.system.db.preloadItems param, (items) ->
        self._shop_window = rpg.WindowItemShop(items:items,param).addChildTo(rpg.system.scene)
        self.waitFlag = false
      return true
    if @_shop_window.isOpen()
      return true
    @_shop_window = null
    return false

# イベントの削除
rpg.event_command.shop_item_menu = rpg.event_command.ShopItemMenu()
