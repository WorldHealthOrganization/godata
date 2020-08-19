
const R = require('ramda')

const util = require('../../util/index')

test('util.getIDFromDisplayName', () => {
  const arr = [
    { id: '1', displayName: 'foo' },
    { id: '2', displayName: 'bar' }
  ]

  expect(util.getIDFromDisplayName(arr, 'foo')).toBe('1')
  expect(util.getIDFromDisplayName(arr, 'bar')).toBe('2')
  expect(util.getIDFromDisplayName(arr, 'other')).toStrictEqual(undefined)
})

test('util.completeSchema with simple schema', () => {
  const schema = {
    string: '3',
    number: 42,
    obj: {
      str: 'asd',
      arr: [ 1, 2, 3 ]
    },
    date: new Date()
  }

  expect(util.completeSchema(schema)({})).toStrictEqual(schema)
})

test('util.completeSchema with complex schema', () => {
  const schema = {
    bar: '3',
    fn: R.pipe(R.prop('foo'), R.toUpper),
    arr: [ 1, R.pipe(R.prop('other'), Number, R.add(1)), 3],
    obj: {
      subbar: 42,
      subfn: R.pipe(R.path(['obj', 'subfoo']), String)
    }
  }

  const obj = {
    foo: 'asd',
    other: '13',
    obj: {
      subfoo: 11
    }
  }

  expect(util.completeSchema(schema)(obj)).toStrictEqual({
    bar: '3',
    fn: 'ASD',
    arr: [ 1, 14, 3 ],
    obj: {
      subbar: 42,
      subfn: '11'
    }
  })
})

