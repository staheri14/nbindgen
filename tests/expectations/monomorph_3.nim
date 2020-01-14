
type Bar*[T] {.incompleteStruct.} = object

type Foo* {.union.}[T] = object
  data: ptr T

type Tuple* {.union.}[T, E] = object
  a: ptr T
  b: ptr E

type Indirection*[T] = Tuple[T, float32]

proc root*(a: Foo[int32],
           b: Foo[float32],
           c: Bar[float32],
           d: Foo[Bar[float32]],
           e: Bar[Foo[float32]],
           f: Bar[Bar[float32]],
           g: Tuple[Foo[float32], float32],
           h: Indirection[float32]) {.importc: "root".}
