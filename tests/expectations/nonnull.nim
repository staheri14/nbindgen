
type Opaque* {.incompleteStruct.} = object

type Foo*[T] = object
  a: ptr float32
  b: ptr T
  c: ptr Opaque
  d: ptr (ptr T)
  e: ptr (ptr float32)
  f: ptr (ptr Opaque)
  g: ptr T
  h: ptr int32
  i: ptr (ptr int32)

proc root*(arg: ptr int32, foo: ptr Foo[uint64], d: ptr (ptr Opaque)) {.importc: "root".}
