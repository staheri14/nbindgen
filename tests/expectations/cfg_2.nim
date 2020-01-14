when defined(NOT_DEFINED):
  const DEFAULT_X* = 8


when defined(DEFINED):
  const DEFAULT_X* = 42



when (defined(NOT_DEFINED) or defined(DEFINED)):
  type Foo* = object
    x: int32


when defined(NOT_DEFINED):
  type Bar* = object
    y: Foo


when defined(DEFINED):
  type Bar* = object
    z: Foo


type Root* = object
  w: Bar

proc root*(a: Root) {.importc: "root".}
