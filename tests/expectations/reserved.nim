
type A* = object
  namespacex: int32
  floatx: float32

type B* = object
  namespacex: int32
  floatx: float32

type C_Tag* = uint8

type D_Body* = object
  namespacex: int32
  floatx: float32

type C* = object
  tag*: C_Tag
  d*: D_Body

proc root*(a: A, b: B, c: C, namespacex: int32, floatx: float32) {.importc: "root".}
