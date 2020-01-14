
type Status* = uint32

type Dep* = object
  a: int32
  b: float32

type Foo*[X] = object
  a: X
  b: X
  c: Dep

type IntFoo* = Foo[int32]

type DoubleFoo* = Foo[float64]

type Unit* = int32

type SpecialStatus* = Status

proc root*(x: IntFoo, y: DoubleFoo, z: Unit, w: SpecialStatus) {.importc: "root".}
