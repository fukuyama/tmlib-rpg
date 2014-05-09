
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

  describe '汎用増減効果計算', ->
    it '固定値での増減', ->
      r = rpg.utils.effectVal 10, {type:'fix',val:20}
      r.should.equal 20
      r = rpg.utils.effectVal 10, {type:'fix',val:-4}
      r.should.equal -4
    it '率での増減', ->
      r = rpg.utils.effectVal 50, {type:'rate',val:20}
      r.should.equal 10
      r = rpg.utils.effectVal 10, {type:'rate',val:-10}
      r.should.equal -1
    it '半減', ->
      r = rpg.utils.effectVal 88, {type:'rate',val:-50}
      r.should.equal -44

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
