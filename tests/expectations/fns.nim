
type Fns* = object
  noArgs: proc () {.cdecl.}
  anonymousArg: proc (a0: int32) {.cdecl.}
  returnsNumber: proc (): int32 {.cdecl.}
  namedArgs: proc (first: int32, snd: int16): int8 {.cdecl.}
  namedArgsWildcards: proc (wild: int32, named: int16, wild1: int64): int8 {.cdecl.}

proc root*(x_fns: Fns) {.importc: "root".}
