
type Opaque* {.incompleteStruct.} = object

type Foo* = object
  x: ptr Opaque
  y: ptr Opaque
  z: proc () {.cdecl.}

type Bar* {.union.} = object
  x: ptr Opaque
  y: ptr Opaque
  z: proc () {.cdecl.}

proc root*(a: ptr Opaque, b: ptr Opaque, c: Foo, d: Bar) {.importc: "root".}
