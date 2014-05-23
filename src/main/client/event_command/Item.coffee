
# アイテム操作関連

# アイテムを増やす
tm.define 'rpg.event_command.GainItem',

  # コマンド
  apply_command: (item, num = 1, actor = null) ->
    if item.item?
      {item,num,actor,backpack} = {num: 1}.$extend item
    @waitFlag = true
    # 現在のシーンをキャプチャー
    rpg.system.captureScreenBitmap()
    rpg.system.db.item([item],((items) ->
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
      ).bind(@)
    )
    false

# アイテムを減らす
tm.define 'rpg.event_command.LostItem',

  # コマンド
  apply_command: (item, num = 1, actor = null) ->
    if item.item?
      {item,num,actor,backpack} = {num: 1}.$extend item
    @waitFlag = true
    # 現在のシーンをキャプチャー
    rpg.system.captureScreenBitmap()
    rpg.system.db.item([item],((items) ->
      # 誰かのアイテム
      target = rpg.game.party
      if actor?
        # アクターのアイテム
        actor = rpg.game.party.getAt(actor)
        target = actor.backpack if actor?
      else if backpack?
        # バックパックのアイテム
        target = rpg.game.party.backpack
      # 対象のアイテムを捨てる
      for n in [0 ... num]
        for i in items
          i = target.getItem(i.name)
          target.removeItem(i) if i?
      @waitFlag = false
      ).bind(@)
    )
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
