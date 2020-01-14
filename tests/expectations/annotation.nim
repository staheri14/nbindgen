
type C* = uint32

type A* = object
  m0: int32

type B* = object
  x: int32
  y: float32

type F_Tag* = uint8

type Foo_Body* = object
  tag*: F_Tag
  x0: int16

type Bar_Body* = object
  tag*: F_Tag
  x: uint8
  y: int16

type F* = object
  tag*: F_Tag
  foo*: Foo_Body
  bar*: Bar_Body

type H_Tag* = uint8

type Hello_Body* = object
  x0: int16

type There_Body* = object
  x: uint8
  y: int16

type H* = object
  tag*: H_Tag
  hello*: Hello_Body
  there*: There_Body

proc root*(x: A, y: B, z: C, f: F, h: H) {.importc: "root".}
