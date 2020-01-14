#define CBINDGEN_PACKED        __attribute__ ((packed))
#define CBINDGEN_ALIGNED(n)    __attribute__ ((aligned(n)))




type OpaquePackedStruct* {.incompleteStruct.} = object

type OpaquePackedUnion* {.incompleteStruct.} = object

type Align1Union* {.union.} = object
  variant1: uint
  variant2: ptr uint8

type Align4Union* {.union.} = object
  variant1: uint
  variant2: ptr uint8

type Align16Union* {.union.} = object
  variant1: uint
  variant2: ptr uint8

type Align1Struct* = object
  arg1: uint
  arg2: ptr uint8

type Align2Struct* = object
  arg1: uint
  arg2: ptr uint8

type Align4Struct* = object
  arg1: uint
  arg2: ptr uint8

type Align8Struct* = object
  arg1: uint
  arg2: ptr uint8

type Align32Struct* = object
  arg1: uint
  arg2: ptr uint8
