
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

  valueFunc: {
    fix: (b, p) -> p.val
    rate: (b, p) -> b * p.val / 100
    range: (b, p) -> Math.floor(Math.random() * p.max) + p.min
  }

  value: (base,param={type:'fix',val:10}) ->
    @valueFunc[param.type](base,param)


  runUser: (user, targets, effects, log) ->
    targets = if Array.isArray targets then targets else [targets]
    res = {}
    # TODO: effects.target 配列と、targets 配列を１：１で適用するパターンもほしいかも
    for target in targets
      @runArray user, target, effects.target, res
    log.targets = res.targets
    res = {}
    # 使用者が自分で、自分に影響がある場合
    @runArray user, user, effects.user, res
    log.users = res.targets

  runArray: (user, target, effects, log) ->
    r = false
    for e in effects
      for type, op of e
        r = @run type, user, target, op, log or r
    r
  run: (type, user, target, op, log) -> @_effects[type].call @, op, user, target, log
  hp: (user, target, op, log) -> @run 'hp', user, target, op, log
  mp: (user, target, op, log) -> @run 'mp', user, target, op, log

  # 能力変化系(hp/mp)関連エフェクト
  _effect_attr: (attr, op, user, target, log) ->
    r = false
    val = target[attr] # 変化前の値
    target[attr] += rpg.utils.jsonExpression(op,base:target[attr])
    val = target[attr] - val # 変化した量を計算
    r = val != 0 or r
    log.targets = [] unless log.targets?
    if r # 効果があったら結果を保存
      o = {}
      o.name = target.name
      o[attr] = val
      log.targets.push o # 結果に保存
    r

  _effects: {
    # 効果
    # 基本的に、effect 以外では、user と target の状態は変化させない。
    # （使ったアイテムを減らす等は、Actor側の処理で）
    # 参照はあり
    # user: rpg.Actor
    # target: rpg.Actor or Array<rpg.Actor>
    # return: 効果あり true
    default: (op, user, target, log) -> false

    # HP効果
    hp: (op, user, target, log) -> @_effect_attr('hp', op, user, target, log)
    # MP効果
    mp: (op, user, target, log) -> @_effect_attr('mp', op, user, target, log)
    # ステート効果
    state: (op, user, target, log) ->
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
  }

rpg.effect = new rpg.Effect()
