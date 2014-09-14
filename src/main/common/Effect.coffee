
# エフェクトクラス

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# ゲーム内の効果をまとめたクラス
class rpg.Effect

  # コンストラクタ
  constructor: (args={}) ->
    {
      @name
    } = args

  run: (type, op, user, target, log) ->
    @['effect_'+type].call(@, op, user, target, log)

  # 効果
  # 基本的に、effect 以外では、user と target の状態は変化させない。
  # （使ったアイテムを減らす等は、Actor側の処理で）
  # 参照はあり
  # user: rpg.Actor
  # target: rpg.Actor or Array<rpg.Actor>
  # return: 効果あり true
  effect_default: (op, user, target, log) -> false

  # ダメージ（回復）関連エフェクト
  effect_damage: (op, user, target, log) ->
    r = false
    attr = op.attr
    val = target[attr] # 変化前の値
    target[attr] += rpg.utils.effectVal(target[attr],op)
    val = target[attr] - val # 変化した量を計算
    r = val != 0 or r
    if r # 効果があったら結果を保存
      o = {}
      o.name = target.name
      o[attr] = val
      log.targets.push o # 結果に保存
    r

  # HP効果
  effect_hp: (op, user, target, log) ->
    op.attr = 'hp'
    @effect_damage(op, user, target, log)

  # MP効果
  effect_mp: (op, user, target, log) ->
    op.attr = 'mp'
    @effect_damage(op, user, target, log)

  # ステート効果
  effect_state: (op, user, target, log) ->
    # TODO: 確率(rate)をつける？
    if op.type == 'add'
      state = rpg.system.db.state(op.name)
      target.addState(state)
      log.targets.push state: {
        name: target.name
        type: 'add'
        state: state.name
      }
      return true
    if op.type == 'remove'
      target.removeState(name:op.name)
      log.targets.push state: {
        name: target.name
        type: 'remove'
        state: op.name
      }
      return true
    false

rpg.effect = new rpg.Effect()
