
type MyCLikeEnum* = int

type MyFancyStruct* = object
  i: int32
  foo: proc()

type MyFancyEnum_Tag* = int

type Bar_Body* = object
  x0: int32

type Baz_Body* = object
  x0: int32

type MyFancyEnum* = object
  tag*: MyFancyEnum_Tag
  bar*: Bar_Body
  baz*: Baz_Body

type MyUnion* {.union.} = object
  f: float32
  u: uint32
  extra_member: int32 # yolo

proc root*(s: MyFancyStruct, e: MyFancyEnum, c: MyCLikeEnum, u: MyUnion) {.importc: "root".}
