const EXPORT_ME_TOO* = 42


type ExportMe* = object
  val: uint64

proc export_me*(val: ptr ExportMe) {.importc: "export_me".}
