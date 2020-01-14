
type FillRule* = uint8

## This will have a destructor manually implemented via variant_body, and
# similarly a Drop impl in Rust.
type OwnedSlice*[T] = object
  len: uint
  ptrx: ptr T
  ~OwnedSlice() {}

type Polygon*[LengthPercentage] = object
  fill: FillRule
  coordinates: OwnedSlice[LengthPercentage]

type Foo_Tag* = uint8

type Polygon1_Body* = object
  x0: Polygon[T]

type Slice1_Body* = object
  x0: OwnedSlice[T]

type Slice2_Body* = object
  x0: OwnedSlice[int32]

type Slice3_Body* = object
  fill: FillRule
  coords: OwnedSlice[T]

type Slice4_Body* = object
  fill: FillRule
  coords: OwnedSlice[int32]

type Foo*[T] = object
  tag*: Foo_Tag
  polygon1*: Polygon1_Body
  slice1*: Slice1_Body
  slice2*: Slice2_Body
  slice3*: Slice3_Body
  slice4*: Slice4_Body

type Baz_Tag* = uint8

type Polygon21_Body* = object
  tag*: Baz_Tag
  x0: Polygon[T]

type Slice21_Body* = object
  tag*: Baz_Tag
  x0: OwnedSlice[T]

type Slice22_Body* = object
  tag*: Baz_Tag
  x0: OwnedSlice[int32]

type Slice23_Body* = object
  tag*: Baz_Tag
  fill: FillRule
  coords: OwnedSlice[T]

type Slice24_Body* = object
  tag*: Baz_Tag
  fill: FillRule
  coords: OwnedSlice[int32]

type Baz*[T] = object
  tag*: Baz_Tag
  polygon21*: Polygon21_Body
  slice21*: Slice21_Body
  slice22*: Slice22_Body
  slice23*: Slice23_Body
  slice24*: Slice24_Body

type Taz_Tag* = uint8

type Taz1_Body* = object
  tag*: Taz_Tag
  x0: int32

type Taz3_Body* = object
  tag*: Taz_Tag
  x0: OwnedSlice[int32]

type Taz* = object
  tag*: Taz_Tag
  taz1*: Taz1_Body
  taz3*: Taz3_Body

type Tazz_Tag* = uint8

type Taz2_Body* = object
  tag*: Tazz_Tag
  x0: int32

type Tazz* = object
  tag*: Tazz_Tag
  taz2*: Taz2_Body

proc root*(a: ptr Foo[uint32], b: ptr Baz[int32], c: ptr Taz, d: Tazz) {.importc: "root".}
