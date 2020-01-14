
## Constants shared by multiple CSS Box Alignment properties
#
# These constants match Gecko's `NS_STYLE_ALIGN_*` constants.
type StyleAlignFlags* = object
  bits: uint8
const StyleAlignFlags_AUTO* = StyleAlignFlags(bits: 0)
const StyleAlignFlags_NORMAL* = StyleAlignFlags(bits: 1)
const StyleAlignFlags_START* = StyleAlignFlags(bits: (1 shl 1))
const StyleAlignFlags_END* = StyleAlignFlags(bits: (1 shl 2))
const StyleAlignFlags_FLEX_START* = StyleAlignFlags(bits: (1 shl 3))

proc root*(flags: StyleAlignFlags) {.importc: "root".}
