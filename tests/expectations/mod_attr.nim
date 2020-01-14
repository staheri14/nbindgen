when defined(BAR):
  const BAR* = 2


when defined(FOO):
  const FOO* = 1



when defined(BAR):
  type Bar* = object



when defined(FOO):
  type Foo* = object



when defined(BAR):
  proc bar*(bar: ptr Bar) {.importc: "bar".}


when defined(FOO):
  proc foo*(foo: ptr Foo) {.importc: "foo".}

