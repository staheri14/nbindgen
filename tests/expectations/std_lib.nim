
type Option*[T] {.incompleteStruct.} = object

type Result*[T, E] {.incompleteStruct.} = object

type String* {.incompleteStruct.} = object

type Vec*[T] {.incompleteStruct.} = object

proc root*(a: ptr Vec[String],
           b: ptr Option[int32],
           c: ptr Result[int32, String]) {.importc: "root".}
