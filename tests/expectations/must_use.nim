#define MUST_USE_FUNC __attribute__((warn_unused_result))
#define MUST_USE_STRUCT __attribute__((warn_unused))
#define MUST_USE_ENUM /* nothing */




type MaybeOwnedPtr_Tag* = uint8

type Owned_Body* = object
  x0: ptr T

type MaybeOwnedPtr*[T] = object
  tag*: MaybeOwnedPtr_Tag
  owned*: Owned_Body

 MUST_USE_STRUCTtype OwnedPtr*[T] = object
  ptrx: ptr T

MUST_USE_FUNC
proc maybe_consume*(input: OwnedPtr[int32]): MaybeOwnedPtr[int32] {.importc: "maybe_consume".}
