
type A* = object
  data: ptr int32

proc root*(x_a: A) {.importc: "root".}
