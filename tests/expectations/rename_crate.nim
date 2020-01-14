
when not (defined(DEFINE_FREEBSD)):
  type NoExternTy* = object
    field: uint8


when not (defined(DEFINE_FREEBSD)):
  type ContainsNoExternTy* = object
    field: NoExternTy


when defined(DEFINE_FREEBSD):
  type ContainsNoExternTy* = object
    field: uint64


type RenamedTy* = object
  y: uint64

type Foo* = object
  x: int32

proc no_extern_func*(a: ContainsNoExternTy) {.importc: "no_extern_func".}

proc renamed_func*(a: RenamedTy) {.importc: "renamed_func".}

proc root*(a: Foo) {.importc: "root".}
