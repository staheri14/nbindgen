const C_H* = 10


type C_E* = uint8

type C_A* {.incompleteStruct.} = object

type C_C* {.incompleteStruct.} = object

type C_AwesomeB* = object
  x: int32
  y: float32

type C_D* {.union.} = object
  x: int32
  y: float32

type C_F* = C_A

var G* {.importc: "G".}: int32

proc root*(a: ptr C_A, b: C_AwesomeB, c: C_C, d: C_D, e: C_E, f: C_F) {.importc: "root".}
