
type Foo* = object
  a: bool
  b: int32

type Bar_Tag* = uint8

type Bazz_Body* = object
  tag*: Bar_Tag
  named: Foo

type FooNamed_Body* = object
  tag*: Bar_Tag
  different: int32
  fields: uint32

type FooParen_Body* = object
  tag*: Bar_Tag
  x0: int32
  x1: Foo

type Bar* = object
  tag*: Bar_Tag
  bazz*: Bazz_Body
  foo_named*: FooNamed_Body
  foo_paren*: FooParen_Body

proc root*(aBar: Bar): Foo {.importc: "root".}
