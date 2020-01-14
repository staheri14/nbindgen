
type TBar* {.incompleteStruct.} = object

type TFoo* = object


var BAR* {.importc: "BAR".}: TBar

var FOO* {.importc: "FOO".}: TFoo

var NUMBER* {.importc: "NUMBER".}: int32

proc root*() {.importc: "root".}
