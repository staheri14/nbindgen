
## Constants shared by multiple CSS Box Alignment properties
#
# These constants match Gecko's `NS_STYLE_ALIGN_*` constants.
type AlignFlags* = object
  bits: uint8
const AlignFlags_AUTO* = AlignFlags(bits: 0)
const AlignFlags_NORMAL* = AlignFlags(bits: 1)
const AlignFlags_START* = AlignFlags(bits: (1 shl 1))
const AlignFlags_END* = AlignFlags(bits: (1 shl 2))
const AlignFlags_FLEX_START* = AlignFlags(bits: (1 shl 3))

proc root*(flags: AlignFlags) {.importc: "root".}
