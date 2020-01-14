#define MY_ASSERT(...) do { } while (0)




type I* {.incompleteStruct.} = object

type H_Tag* = uint8

type H_Foo_Body* = object
  x0: int16

type H_Bar_Body* = object
  x: uint8
  y: int16

type H* = object
  tag*: H_Tag
  foo*: H_Foo_Body
  bar*: H_Bar_Body

type J_Tag* = uint8

type J_Foo_Body* = object
  x0: int16

type J_Bar_Body* = object
  x: uint8
  y: int16

type J* = object
  tag*: J_Tag
  foo*: J_Foo_Body
  bar*: J_Bar_Body

type K_Tag* = uint8

type K_Foo_Body* = object
  tag*: K_Tag
  x0: int16

type K_Bar_Body* = object
  tag*: K_Tag
  x: uint8
  y: int16

type K* = object
  tag*: K_Tag
  foo*: K_Foo_Body
  bar*: K_Bar_Body

proc foo*(h: H, i: I, j: J, k: K) {.importc: "foo".}
