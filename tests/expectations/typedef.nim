
type Foo*[T, U] = object
  x: T
  y: U

type IntFoo*[T] = Foo[int32, T]

proc root*(a: IntFoo[int32]) {.importc: "root".}
