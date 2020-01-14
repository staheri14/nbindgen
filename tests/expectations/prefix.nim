const PREFIX_LEN* = 42

const PREFIX_X* = (42 shl 42)

const PREFIX_Y* = (PREFIX_X + PREFIX_X)


type PREFIX_NamedLenArray* = array[PREFIX_LEN, int32]

type PREFIX_ValuedLenArray* = array[42, int32]

type PREFIX_AbsoluteFontWeight_Tag* = uint8

type Weight_Body* = object
  tag*: PREFIX_AbsoluteFontWeight_Tag
  x0: float32

type PREFIX_AbsoluteFontWeight* = object
  tag*: PREFIX_AbsoluteFontWeight_Tag
  weight*: Weight_Body

proc root*(x: PREFIX_NamedLenArray,
           y: PREFIX_ValuedLenArray,
           z: PREFIX_AbsoluteFontWeight) {.importc: "root".}
