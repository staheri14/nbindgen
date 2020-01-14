
type Rect* = object
  x: float32
  y: float32
  w: float32
  h: float32

type Color* = object
  r: uint8
  g: uint8
  b: uint8
  a: uint8

type DisplayItem_Tag* = uint8

type Fill_Body* = object
  tag*: DisplayItem_Tag
  x0: Rect
  x1: Color

type Image_Body* = object
  tag*: DisplayItem_Tag
  id: uint32
  bounds: Rect

type DisplayItem* = object
  tag*: DisplayItem_Tag
  fill*: Fill_Body
  image*: Image_Body

proc push_item*(item: DisplayItem): bool {.importc: "push_item".}
