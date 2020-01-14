const DELIMITER* = ':'

const EQUID* = L'\u10083'

const FOO* = 10

const HEART* = L'\u2764'

const LEFTCURLY* = '{'

const NEG_ONE* = -1

const NEWLINE* = '\n'

const POS_ONE* = 1

const QUOTE* = '\''

const SHIFT* = 3

const TAB* = '\t'

const XBOOL* = 1

const XFALSE* = ((0 shl SHIFT) or XBOOL)

const XTRUE* = (1 shl (SHIFT or XBOOL))

const ZOM* = 3.14


type TFoo* = object
  x: array[FOO, int32]

proc root*(x: TFoo) {.importc: "root".}
