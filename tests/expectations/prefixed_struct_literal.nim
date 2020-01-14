
type PREFIXFoo* = object
  a: int32
  b: uint32
const PREFIXFoo_FOO* = PREFIXFoo(a: 42, b: 47)

const PREFIXBAR* = PREFIXFoo(a: 42, b: 1337)

proc root*(x: PREFIXFoo) {.importc: "root".}
