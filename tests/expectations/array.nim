
type Foo_Tag* = int

type A_Body* = object
  x0: array[20, float32]

type Foo* = object
  tag*: Foo_Tag
  a*: A_Body

proc root*(a: Foo) {.importc: "root".}
