
type A* {.incompleteStruct.} = object

type B* {.incompleteStruct.} = object

type List*[T] = object
  members: ptr T
  count: uint

proc bar*(b: List[B]) {.importc: "bar".}

proc foo*(a: List[A]) {.importc: "foo".}
