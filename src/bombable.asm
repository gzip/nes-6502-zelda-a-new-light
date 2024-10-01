;========================================================
; Bombable tiles, block, and replacement logic
;========================================================

; tiles $62 and $63
.PATCH $8DAF
  .incbin "bombed.chr"

; block $04 (was unused)
.PATCH 05:A9C4 ; $17B6D
  .data $62, $24, $63, $24

; point to block which replaces wall
.PATCH 05:AA84 ; 16A94
  .byte #$04

; a piece of logic is needed to render the correct tiles when bombed
.PATCH 07:D301 ; 1D311
CheckReplacementTiles:
  STA $030B,X                ; run hijacked code
  CMP #$24                   ; test for expected tile
  BEQ +
  JMP ReturnFromCheck
+ LDA #$62                   ; replace the top two tiles
  STA $0305,X
  LDA #$63
  STA $030A,X
  JMP $E8AC                  ; skip over the rest to SetCountBytes

; tile replacement check
.PATCH 07:E892 ; 1E899
  JMP CheckReplacementTiles  ; in ChangeTileObjTiles
  ReturnFromCheck:
  