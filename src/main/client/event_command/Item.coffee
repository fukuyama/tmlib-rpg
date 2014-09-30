
# アイテム操作関連

# アイテム増やす処理
_addItemCallback = (num, items, actor, backpack) ->
  # 誰かのアイテム
  target = rpg.game.party
  if actor?
    # アクターのアイテム
    actor = rpg.game.party.getAt(actor)
    target = actor.backpack if actor?
  else if backpack?
    # バックパックのアイテム
    target = rpg.game.party.backpack
  # 対象のアイテムを増やす
  for n in [0 ... num]
    target.addItem(i) for i in items
  @waitFlag = false

# アイテムを削除する処理
_removeItemCallback = (num, items, actor, backpack) ->
  # 誰かのアイテム
  target = rpg.game.party
  if actor?
    # アクターのアイテム
    actor = rpg.game.party.getAt(actor)
    target = actor.backpack if actor?
  else if backpack?
    # バックパックのアイテム
    target = rpg.game.party.backpack
  # 対象のアイテムを増やす
  for n in [0 ... num]
    for i in items
      i = target.getItem(i.name)
      target.removeItem(i) if i?
  @waitFlag = false

# TODO:プリロードイベント
tm.define 'rpg.event_command.PreLoadItem',
  # コマンド
  apply_command: (args) ->
    {
      items
      weapons
      armors
    } = {
      items: []
      weapons: []
      armors: []
    }.$extend args
    # TODO: それぞれのアイテムの preload を呼んで最後に、イベント継続したい


# アイテムを増やす
tm.define 'rpg.event_command.GainItem',

  # コマンド
  apply_command: (item, num = 1, actor = null) ->
    {item,num,actor,backpack} = {num: 1}.$extend item if item.item?
    @waitFlag = true
    self = @
    rpg.system.db.preloadItem [item], (items) ->
      _addItemCallback.call self, num, items, actor, backpack
    false

# アイテムを減らす
tm.define 'rpg.event_command.LostItem',

  # コマンド
  apply_command: (item, num = 1, actor = null) ->
    {item,num,actor,backpack} = {num: 1}.$extend item if item.item?
    @waitFlag = true
    self = @
    rpg.system.db.preloadItem [item], (items) ->
      _removeItemCallback.call self, num, items, actor, backpack
    false

# アイテムをすべて捨てる
tm.define 'rpg.event_command.ClearItem',

  # コマンド
  apply_command: () ->
    rpg.game.party.clearItem()
    false

rpg.event_command.gain_item = rpg.event_command.GainItem()
rpg.event_command.lost_item = rpg.event_command.LostItem()
rpg.event_command.clear_item = rpg.event_command.ClearItem()

# 武器を増やす
tm.define 'rpg.event_command.GainWeapon',

  # コマンド
  apply_command: (weapon, num = 1, actor = null) ->
    {weapon,num,actor,backpack} = {num: 1}.$extend weapon if weapon.weapon?
    @waitFlag = true
    self = @
    rpg.system.db.preloadWeapon [weapon], (items) ->
      _addItemCallback.call self, num, items, actor, backpack
    false

# 武器を減らす
tm.define 'rpg.event_command.LostWeapon',

  # コマンド
  apply_command: (weapon, num = 1, actor = null) ->
    {weapon,num,actor,backpack} = {num: 1}.$extend weapon if weapon.weapon?
    @waitFlag = true
    self = @
    rpg.system.db.preloadWeapon [weapon], (items) ->
      _removeItemCallback.call self, num, items, actor, backpack
    false

rpg.event_command.gain_weapon = rpg.event_command.GainWeapon()
rpg.event_command.lost_weapon = rpg.event_command.LostWeapon()

# 防具を増やす
tm.define 'rpg.event_command.GainArmor',

  # コマンド
  apply_command: (armor, num = 1, actor = null) ->
    {armor,num,actor,backpack} = {num: 1}.$extend armor if armor.armor?
    @waitFlag = true
    self = @
    rpg.system.db.preloadArmor [armor], (items) ->
      _addItemCallback.call self, num, items, actor, backpack
    false

# 防具を減らす
tm.define 'rpg.event_command.LostArmor',

  # コマンド
  apply_command: (armor, num = 1, actor = null) ->
    {armor,num,actor,backpack} = {num: 1}.$extend armor if armor.armor?
    @waitFlag = true
    self = @
    rpg.system.db.preloadArmor [armor], (items) ->
      _removeItemCallback.call self, num, items, actor, backpack
    false

rpg.event_command.gain_armor = rpg.event_command.GainArmor()
rpg.event_command.lost_armor = rpg.event_command.LostArmor()
