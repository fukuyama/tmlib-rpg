
# アイテム操作関連

# アイテム増やす処理
_gain_callback = (items, args) ->
  {
    num
    actor
    backpack
    price
  } = args
  # 誰かのアイテム
  target = rpg.game.party
  if actor?
    # アクターのアイテム
    actor = rpg.game.party.getAt(actor)
    target = actor.backpack if actor?
  else if backpack? and backpack
    # バックパックのアイテム
    target = rpg.game.party.backpack
  gain = true
  # 値段がある場合
  if price > 0
    if rpg.game.party.cash >= price
      rpg.game.party.cash -= price
    else
      gain = false
  if gain
    # 対象のアイテムを増やす
    for n in [0 ... num]
      for i in items
        target.addItem(i)

# アイテムを削除する処理
_lost_callback = (items, args) ->
  {
    num
    actor
    backpack
  } = args
  # 誰かのアイテム
  target = rpg.game.party
  if actor?
    # アクターのアイテム
    actor = rpg.game.party.getAt(actor)
    target = actor.backpack if actor?
  else if backpack? and backpack
    # バックパックのアイテム
    target = rpg.game.party.backpack
  # 対象のアイテムを増やす
  for n in [0 ... num]
    for i in items
      i = target.getItem(i.name)
      target.removeItem(i) if i?

# アイテム買う処理処理
_buy_callback = (items, args) ->
  # 値段を計算
  if args.price == 0
    for n in [0 ... args.num]
      for i in items
        args.price += i.price
  _gain_callback(items, args)

# アイテム事前読み込み
tm.define 'rpg.event_command.PreloadItem',
  # コマンド
  apply_command: (args) ->
    @waitFlag = true
    rpg.system.db.preloadItems args, (-> @waitFlag = false).bind @
    false

rpg.event_command.preload_item = rpg.event_command.PreloadItem()

# アイテムの増減
tm.define 'rpg.event_command.GainLostItem',
  # 初期化
  init: (item_type,call_type) ->
    @_preload = ->
      if item_type is 'item'
        @_preload = rpg.system.db.preloadItem
      if item_type is 'weapon'
        @_preload = rpg.system.db.preloadWeapon
      if item_type is 'armor'
        @_preload = rpg.system.db.preloadArmor
      @_preload.apply @, arguments
    if call_type is 'gain'
      @_callback = _gain_callback
    if call_type is 'lost'
      @_callback = _lost_callback
    if call_type is 'buy'
      @_callback = _buy_callback

  ###* コマンド
  * @params {Object} args オブジェクトじゃない場合は、以下の引数の順番
  * @params {string} args.id
  * @params {number} args.num
  * @params {number} args.actor アクターのパーティインデックス
  * @params {boolean} args.backpack 袋に入れる場合 true （アクター優先？)
  * @params {price} args.price 値段（合計）
  ###
  apply_command: (id, num=1, actor=null, backpack=false, price=0) ->
    data = null
    if typeof id is 'object'
      data = {
        num: 1
        actor: null
        backpack: false
        price: 0
      }.$extend id
    else
      data = {
        id: id
        num: num
        actor: actor
        backpack: backpack
        price: price
      }
    self = @
    self.waitFlag = true
    ec = @event_command
    ec._preload [data.id], (items) ->
      ec._callback.call self, items, data
      self.waitFlag = false
    false

rpg.event_command.gain_item = rpg.event_command.GainLostItem('item','gain')
rpg.event_command.gain_weapon = rpg.event_command.GainLostItem('weapon','gain')
rpg.event_command.gain_armor = rpg.event_command.GainLostItem('armor','gain')

rpg.event_command.lost_item = rpg.event_command.GainLostItem('item','lost')
rpg.event_command.lost_weapon = rpg.event_command.GainLostItem('weapon','lost')
rpg.event_command.lost_armor = rpg.event_command.GainLostItem('armor','lost')

rpg.event_command.buy_item = rpg.event_command.GainLostItem('item','buy')
rpg.event_command.buy_weapon = rpg.event_command.GainLostItem('weapon','buy')
rpg.event_command.buy_armor = rpg.event_command.GainLostItem('armor','buy')


# アイテムをすべて捨てる
tm.define 'rpg.event_command.ClearItem',
  # コマンド
  apply_command: () ->
    rpg.game.party.clearItem()
    false

rpg.event_command.clear_item = rpg.event_command.ClearItem()

# 装備する
tm.define 'rpg.event_command.EquipItem',

  init: (item_type) ->
    @preload = ->
      if item_type is 'weapon'
        @preload = rpg.system.db.preloadWeapon
      if item_type is 'armor'
        @preload = rpg.system.db.preloadArmor
      @preload.apply @, arguments

  ###* イベントコマンドの反映。
  * Interpreter インスタンスのメソッドとして実行される。
  * イベントコマンド自体のインスタンスは、@event_command で取得する。
  * @memberof rpg.event_command.EquipItem#
  * @param {number} actor 増やす対象アクター（パーティの何番目のアクターかの番号） null の場合、パーティに増やす
  * @param {number} equip_item 装備アイテムID
  * @return {boolean} false
  ###
  apply_command: (actor_id, equip_item) ->
    actor = rpg.game.party.getAt(actor_id)
    self = @
    @waitFlag = true
    @event_command.preload [equip_item], (items) ->
      item = actor.backpack.getItem(items[0].name)
      actor[item.position] = item if item?
      self.waitFlag = false
    false

rpg.event_command.equip_weapon = rpg.event_command.EquipItem('weapon')
rpg.event_command.equip_armor = rpg.event_command.EquipItem('armor')
