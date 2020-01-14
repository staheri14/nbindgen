
type StylePoint*[T] = object
  x: T
  y: T

type StyleFoo_Tag* = uint8

type Foo_Body* = object
  tag*: StyleFoo_Tag
  x: int32
  y: StylePoint[T]
  z: StylePoint[float32]

type Bar_Body* = object
  tag*: StyleFoo_Tag
  x0: T

type Baz_Body* = object
  tag*: StyleFoo_Tag
  x0: StylePoint[T]

type StyleFoo*[T] = object
  tag*: StyleFoo_Tag
  foo*: Foo_Body
  bar*: Bar_Body
  baz*: Baz_Body

type StyleBar_Tag* = int

type StyleBar1_Body* = object
  x: int32
  y: StylePoint[T]
  z: StylePoint[float32]
  u: proc (a0: int32): int32 {.cdecl.}

type StyleBar2_Body* = object
  x0: T

type StyleBar3_Body* = object
  x0: StylePoint[T]

type StyleBar*[T] = object
  tag*: StyleBar_Tag
  bar1*: StyleBar1_Body
  bar2*: StyleBar2_Body
  bar3*: StyleBar3_Body

type StyleBaz_Tag* = uint8

type Baz1_Body* = object
  tag*: StyleBaz_Tag
  x0: StyleBar[uint32]

type Baz2_Body* = object
  tag*: StyleBaz_Tag
  x0: StylePoint[int32]

type StyleBaz* = object
  tag*: StyleBaz_Tag
  baz1*: Baz1_Body
  baz2*: Baz2_Body

type StyleTaz_Tag* = uint8

type StyleTaz1_Body* = object
  x0: StyleBar[uint32]

type StyleTaz2_Body* = object
  x0: StyleBaz

type StyleTaz* = object
  tag*: StyleTaz_Tag
  taz1*: StyleTaz1_Body
  taz2*: StyleTaz2_Body

proc foo*(foo: ptr StyleFoo[int32],
          bar: ptr StyleBar[int32],
          baz: ptr StyleBaz,
          taz: ptr StyleTaz) {.importc: "foo".}
