
#  foo.should.be.a('string');
#  foo.should.equal('bar');
#  foo.should.have.length(3);
#  tea.should.have.property('flavors').with.length(3);

require('chai').should()

require('../../main/common/utils.coffee')

_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

class rpg.Abc
  constructor: (args={}) ->
    {
      @name
      @abc
    } = {
      name: 'test'
      abc: null
    }.$extendAll(args)
  
  test: -> @name

describe 'utils', ->
  describe 'string format', ->
    it '文字列でマージする感じ', ->
      1.formatString('0000').should.equal '0001'
      10.formatString('0000').should.equal '0010'
      55.formatString('0000').should.equal '0055'
      105.formatString('0000').should.equal '0105'
      9999.formatString('0000').should.equal '9999'
      2.formatString('1000').should.equal '1002'
      10000.formatString('99').should.equal '10000'

  describe '$extendAll', ->
    describe '空のオブジェクトのマージ', ->
      h = {}
      a = {}
      h.$extendAll a
      it '結果は空になる', ->
        c = 0
        c++ for i of h
        c.should.equal 0
    describe 'オブジェクトのマージの同一性', ->
      h = {x:{name:'a'}}
      a = {x:{val:1}}
      h.$extendAll a
      it '同じオブジェクトにならない', ->
        a.x.name = 'TEST'
        h.x.name.should.equal 'a'
      it 'マージはする', ->
        h.x.val.should.equal 1
    describe 'ネスト１のマージ h={} に a={name:"test"} をマージ', ->
      h = {}
      a = {name:'test'}
      h.$extendAll a
      c = 0
      c++ for i of h
      it 'h のサイズは 1', ->
        c.should.equal 1
      it 'h.name は "test" になる', ->
        h.name.should.equal 'test'
    describe '文字列の属性にオブジェクトをマージすると上書きする', ->
      h = {param:'test'}
      a = {param:{name: 'name'}}
      it 'a を h にマージ', ->
        h.$extendAll a
      it '上書きされたか？ h.param がオブジェクトか？', ->
        h.param.should.be.a 'object'
    describe 'etc', ->
      it 'level 2', ->
        h = {src:{i:11,l:20}}
        a = {name:'test',src:{i:10}}
        h.src.i.should.equal 11
        h.src.l.should.equal 20
        h.$extendAll a
        c = 0
        c++ for i of h
        c.should.equal 2
        h.name.should.equal 'test'
        h.src.i.should.equal 10
        h.src.l.should.equal 20
      it 'level 3', ->
        h = {}
        a = {name:'test',src:{i:10}}
        b = {src:{i:11,l:20}}
        b.src.i.should.equal 11
        b.src.l.should.equal 20
        h.$extendAll b
        h.$extendAll a
        b.src.i.should.equal 11
        b.src.l.should.equal 20
        c = 0
        c++ for i of h
        c.should.equal 2
        h.name.should.equal 'test'
        h.src.i.should.equal 10
        h.src.l.should.equal 20
      it 'array 1', ->
        h = {list:[1,2]}
        a = {}.$extendAll h
        h.list.should.deep.equal [1,2]
        a.list.should.be.a 'array'
        a.list.push 3
        a.list.should.deep.equal [1,2,3]
        h.list.should.deep.equal [1,2]
      it 'array 2', ->
        h = {list:[
          {a:1,b:2}
          {a:3,b:4}
        ]}
        a = {}.$extendAll h
        h.list.should.deep.equal [{a:1,b:2},{a:3,b:4}]
        a.list.should.be.a 'array'
        a.list.push {a:5,b:5}
        a.list[0].a = 5
        a.list.should.deep.equal [{a:5,b:2},{a:3,b:4},{a:5,b:5}]
        h.list.should.deep.equal [{a:1,b:2},{a:3,b:4}]
      it 'array 3', ->
        h = {
          list: [
            [1,2,3]
            [4,5,6]
          ]
        }
        a = {}.$extendAll h
        a.should.deep.equal {list:[[1,2,3],[4,5,6]]}
      it 'function 1', ->
        h = {
          list: [1,2,3]
          func: -> console.log 'test'
        }
        a = {}.$extendAll h
        a.should.deep.equal {list:[1,2,3]}
      it 'function 2', ->
        h = {
          list: [1,2,3]
          func: -> console.log 'test'
        }
        a = {
          func1: -> console.log 'test'
        }.$extendAll h
        a.list.should.deep.equal [1,2,3]
        (typeof a.func1).should.equal 'function'

  describe 'JSONデータ関連', ->
    it 'ObjectからJsonへ', ->
      json = rpg.utils.createJsonData {
        name:'hoehoe'
        num:10
      }
      json.should.equal '{"name":"hoehoe","num":10}'
    it 'JsonからObjectへ', ->
      obj = rpg.utils.createRpgObject '{"name":"hoehoe","num":10}'
      obj.name.should.equal 'hoehoe'
      obj.num.should.equal 10
    it 'nullデータ', ->
      json = rpg.utils.createJsonData {
        name:null
        num:10
      }
      json.should.equal '{"num":10}'
    it 'class 1', ->
      a = new rpg['Abc']()
      a.constructor.name.should.equal 'Abc'
    it 'class 2', ->
      a = new rpg.Abc(name:'test')
      a.abc = new rpg.Abc(name:'test1')
      a.abc.constructor.name.should.equal 'Abc'
      a.abc.test().should.equal 'test1'
      json = rpg.utils.createJsonData(a)
      a = rpg.utils.createRpgObject(json)
      a.test().should.equal 'test'
      a.abc.constructor.name.should.equal 'Abc'
      a.abc.test().should.equal 'test1'

  describe 'JSON式', ->
    it '足し算', ->
      n = rpg.utils.jsonExpression l: 1,e: '+',r: 1
      n.should.equal 2
    it '引き算', ->
      n = rpg.utils.jsonExpression l: 1,e: '-',r: 1
      n.should.equal 0
    it '掛け算', ->
      n = rpg.utils.jsonExpression l: 2,e: '*',r: 1
      n.should.equal 2
      n = rpg.utils.jsonExpression l: 1,e: '*',r: 2
      n.should.equal 2
    it '割り算', ->
      n = rpg.utils.jsonExpression l: 2,e: '/',r: 1
      n.should.equal 2
      n = rpg.utils.jsonExpression l: 1,e: '/',r: 2
      n.should.equal 0.5
    it '組み合わせ', ->
      n = rpg.utils.jsonExpression
        l:
          l: 1
          e: '-'
          r: 3
        e: '+'
        r:
          l: 2
          e: '*'
          r: 5
      n.should.equal 8
    it 'より小さい', ->
      n = rpg.utils.jsonExpression l: 2,e: '>',r: 1
      n.should.equal true
      n = rpg.utils.jsonExpression l: 2,e: '>',r: 4
      n.should.equal false
    it 'より大きい', ->
      n = rpg.utils.jsonExpression l: 1,e: '<',r: 2
      n.should.equal true
      n = rpg.utils.jsonExpression l: 4,e: '<',r: 2
      n.should.equal false
    it '以下', ->
      n = rpg.utils.jsonExpression l: 2,e: '>=',r: 2
      n.should.equal true
      n = rpg.utils.jsonExpression l: 2,e: '>=',r: 1
      n.should.equal true
      n = rpg.utils.jsonExpression l: 2,e: '>=',r: 4
      n.should.equal false
    it '以上', ->
      n = rpg.utils.jsonExpression l: 2,e: '<=',r: 2
      n.should.equal true
      n = rpg.utils.jsonExpression l: 1,e: '<=',r: 2
      n.should.equal true
      n = rpg.utils.jsonExpression l: 4,e: '<=',r: 2
      n.should.equal false
    it '等しい', ->
      n = rpg.utils.jsonExpression l: 2,e: '==',r: 2
      n.should.equal true
      n = rpg.utils.jsonExpression l: 3,e: '==',r: 2
      n.should.equal false
    it '等しくない', ->
      n = rpg.utils.jsonExpression l: 2,e: '!=',r: 2
      n.should.equal false
      n = rpg.utils.jsonExpression l: 3,e: '!=',r: 2
      n.should.equal true
    it 'and', ->
      n = rpg.utils.jsonExpression l: true,e: 'and',r: true
      n.should.equal true
      n = rpg.utils.jsonExpression l: true,e: 'and',r: false
      n.should.equal false
      n = rpg.utils.jsonExpression l: false,e: 'and',r: false
      n.should.equal false
    it 'or', ->
      n = rpg.utils.jsonExpression l: true,e: 'or',r: true
      n.should.equal true
      n = rpg.utils.jsonExpression l: true,e: 'or',r: false
      n.should.equal true
      n = rpg.utils.jsonExpression l: false,e: 'or',r: false
      n.should.equal false

    it 'オブジェクト参照', ->
      op = {
        test: 10
        abc:
          x: 11
      }
      n = rpg.utils.jsonExpression {l: 'abc.x',e: '+',r: 'test'},op
      n.should.equal 21

    it 'Array 引数', ->
      n = rpg.utils.jsonExpression [1,'+',1]
      n.should.equal 2

    it 'Array 引数 ネスト', ->
      n = rpg.utils.jsonExpression [1,'+',[3,'*',2]]
      n.should.equal 7

    it 'Array 引数 ネスト オブジェクト', ->
      op = {
        test: 10
        abc:
          x: 11
      }
      n = rpg.utils.jsonExpression [1,'+',['abc.x','*',2]], op
      n.should.equal 23

    it '代入', ->
      op = {
        test: 10
        abc:
          x: 11
      }
      n = rpg.utils.jsonExpression ['test','=',['abc.x','*',2]], op
      n.should.equal 22
      op.test.should.equal 22

    it '属性代入', ->
      op = {
        test:
          n: 0
        abc:
          x: 11
      }
      n = rpg.utils.jsonExpression ['test.n','=',['abc.x','*',2]], op
      n.should.equal 22
      op.test.n.should.equal 22
