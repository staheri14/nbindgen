
type A* = proc () {.cdecl.}

type B* = proc () {.cdecl.}

type C* = proc (a0: int32, a1: int32): bool {.cdecl.}

type D* = proc (a0: int32): (proc (a0: float32): bool {.cdecl.}) {.cdecl.}

type E* = proc (): (ptr array[16, int32]) {.cdecl.}

type F* = ptr int32

type G* = ptr (ptr int32)

type H* = ptr (ptr int32)

type I* = ptr array[16, int32]

type J* = ptr (proc (a0: float32): float64 {.cdecl.})

type K* = array[16, int32]

type L* = array[16, ptr int32]

type M* = array[16, proc (a0: int32, a1: int32): bool {.cdecl.}]

type N* = array[16, proc (a0: int32, a1: int32) {.cdecl.}]

type P* = proc (named1st: int32, a1: bool, named3rd: bool, wild: int32) {.cdecl.}

type Q* = proc (v: pointer) {.cdecl.}

proc O*(): (proc () {.cdecl.}) {.importc: "O".}

proc root*(a: A,
           b: B,
           c: C,
           d: D,
           e: E,
           f: F,
           g: G,
           h: H,
           i: I,
           j: J,
           k: K,
           l: L,
           m: M,
           n: N,
           p: P,
           q: Q) {.importc: "root".}
