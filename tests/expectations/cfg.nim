
when (defined(PLATFORM_WIN) or defined(M_32)):
  type BarType* = uint32


when (defined(PLATFORM_UNIX) and defined(X11)):
  type FooType* = uint32


when (defined(PLATFORM_UNIX) and defined(X11)):
  type FooHandle* = object
    ty: FooType
    x: int32
    y: float32


when (defined(PLATFORM_WIN) or defined(M_32)):
  type BarHandle* = object
    ty: BarType
    x: int32
    y: float32


when (defined(PLATFORM_UNIX) and defined(X11)):
  proc root*(a: FooHandle) {.importc: "root".}


when (defined(PLATFORM_WIN) or defined(M_32)):
  proc root*(a: BarHandle) {.importc: "root".}

