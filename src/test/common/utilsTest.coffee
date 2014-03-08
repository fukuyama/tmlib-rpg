
#  foo.should.be.a('string');
#  foo.should.equal('bar');
#  foo.should.have.length(3);
#  tea.should.have.property('flavors').with.length(3);

require('chai').should()

require('../../main/common/utils.coffee')

describe 'utils', () ->
  describe 'string format', () ->
    it '文字列でマージする感じ', ->
      1.formatString('0000').should.equal '0001'
      10.formatString('0000').should.equal '0010'
      55.formatString('0000').should.equal '0055'
      105.formatString('0000').should.equal '0105'
      9999.formatString('0000').should.equal '9999'
      2.formatString('1000').should.equal '1002'
      10000.formatString('99').should.equal '10000'

  describe '$extendAll', () ->
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
