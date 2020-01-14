
type ABC* = object
  a: float32
  b: uint32
  c: uint32
const ABC_abc* = ABC(a: 1.0, b: 2, c: 3)
const ABC_bac* = ABC(a: 1.0, b: 2, c: 3)
const ABC_cba* = ABC(a: 1.0, b: 2, c: 3)

type BAC* = object
  b: uint32
  a: float32
  c: int32
const BAC_abc* = BAC(b: 1, a: 2.0, c: 3)
const BAC_bac* = BAC(b: 1, a: 2.0, c: 3)
const BAC_cba* = BAC(b: 1, a: 2.0, c: 3)

proc root*(a1: ABC, a2: BAC) {.importc: "root".}
