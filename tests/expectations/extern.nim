
type Normal* = object
  x: int32
  y: float32

proc bar*(a: Normal) {.importc: "bar".}

proc foo*(): int32 {.importc: "foo".}
