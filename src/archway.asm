;==================================
; Archway tiles, block, and column
;==================================

; tiles $54 and $55
.PATCH $EE2B
  .incbin "archway.chr"

; block $5F
.PATCH 05:ADAC ; 16DBC
  .data $D8, $54, $DA, $55

; doorway columns $D2 + $D3
.PATCH $17A76
  .data $9B, $1B, $1B, $5F, $0C, $0E, $0E, $0E, $0E, $1A, $1B
  .data $DF, $0C, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $1A, $1B
