
type LayoutUnit* {.incompleteStruct.} = object

type UnknownUnit* {.incompleteStruct.} = object

type TypedLength*[T, Unit] = object
  x0: T

type Length*[T] = TypedLength[T, UnknownUnit]

type LayoutLength* = TypedLength[float32, LayoutUnit]

type TypedSideOffsets2D*[T, U] = object
  top: T
  right: T
  bottom: T
  left: T

type SideOffsets2D*[T] = TypedSideOffsets2D[T, UnknownUnit]

type LayoutSideOffsets2D* = TypedSideOffsets2D[float32, LayoutUnit]

type TypedSize2D*[T, U] = object
  width: T
  height: T

type Size2D*[T] = TypedSize2D[T, UnknownUnit]

type LayoutSize2D* = TypedSize2D[float32, LayoutUnit]

type TypedPoint2D*[T, U] = object
  x: T
  y: T

type Point2D*[T] = TypedPoint2D[T, UnknownUnit]

type LayoutPoint2D* = TypedPoint2D[float32, LayoutUnit]

type TypedRect*[T, U] = object
  origin: TypedPoint2D[T, U]
  sizex: TypedSize2D[T, U]

type Rect*[T] = TypedRect[T, UnknownUnit]

type LayoutRect* = TypedRect[float32, LayoutUnit]

type TypedTransform2D*[T, Src, Dst] = object
  m11: T
  m12: T
  m21: T
  m22: T
  m31: T
  m32: T

proc root*(length_a: TypedLength[float32, UnknownUnit],
           length_b: TypedLength[float32, LayoutUnit],
           length_c: Length[float32],
           length_d: LayoutLength,
           side_offsets_a: TypedSideOffsets2D[float32, UnknownUnit],
           side_offsets_b: TypedSideOffsets2D[float32, LayoutUnit],
           side_offsets_c: SideOffsets2D[float32],
           side_offsets_d: LayoutSideOffsets2D,
           size_a: TypedSize2D[float32, UnknownUnit],
           size_b: TypedSize2D[float32, LayoutUnit],
           size_c: Size2D[float32],
           size_d: LayoutSize2D,
           point_a: TypedPoint2D[float32, UnknownUnit],
           point_b: TypedPoint2D[float32, LayoutUnit],
           point_c: Point2D[float32],
           point_d: LayoutPoint2D,
           rect_a: TypedRect[float32, UnknownUnit],
           rect_b: TypedRect[float32, LayoutUnit],
           rect_c: Rect[float32],
           rect_d: LayoutRect,
           transform_a: TypedTransform2D[float32, UnknownUnit, LayoutUnit],
           transform_b: TypedTransform2D[float32, LayoutUnit, UnknownUnit]) {.importc: "root".}
