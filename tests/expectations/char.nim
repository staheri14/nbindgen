
type Foo* = object
  a: uint32

proc root*(a: Foo) {.importc: "root".}
