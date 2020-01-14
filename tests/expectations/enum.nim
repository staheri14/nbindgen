
type A* = uint64

type B* = uint32

type C* = uint16

type D* = uint8

type E* = uint

type F* = int

type L* = int

type M* = int8

type N* = int

type O* = int8

type J* {.incompleteStruct.} = object

type K* {.incompleteStruct.} = object

type Opaque* {.incompleteStruct.} = object

type G_Tag* = uint8

type Foo_Body* = object
  tag*: G_Tag
  x0: int16

type Bar_Body* = object
  tag*: G_Tag
  x: uint8
  y: int16

type G* = object
  tag*: G_Tag
  foo*: Foo_Body
  bar*: Bar_Body

type H_Tag* = int

type H_Foo_Body* = object
  x0: int16

type H_Bar_Body* = object
  x: uint8
  y: int16

type H* = object
  tag*: H_Tag
  foo*: H_Foo_Body
  bar*: H_Bar_Body

type I_Tag* = uint8

type I_Foo_Body* = object
  x0: int16

type I_Bar_Body* = object
  x: uint8
  y: int16

type I* = object
  tag*: I_Tag
  foo*: I_Foo_Body
  bar*: I_Bar_Body

proc root*(opaque: ptr Opaque,
           a: A,
           b: B,
           c: C,
           d: D,
           e: E,
           f: F,
           g: G,
           h: H,
           i: I,
           j: J,
           k: K,
           l: L,
           m: M,
           n: N,
           o: O) {.importc: "root".}
