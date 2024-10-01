
BlockIndex           = $0D
CheckSpecialBlocks   = $AABF

; ------------------
; Replacement Tiles
; ------------------
; These are individual tiles that have been freed up for use in block sequences

;.PATCH $CF0B ; Tile CC
;.data $00, $42, $00, $18, $18, $00, $42, $00, $00, $00, $24, $18, $18, $24, $00, $00

;.PATCH $CF6B ; Tile D2
;.data $00, $42, $00, $18, $18, $00, $42, $00, $00, $00, $24, $18, $18, $24, $00, $00

.PATCH $CF9B ; Tile D5
.data $00, $42, $00, $18, $18, $00, $42, $00, $00, $00, $24, $18, $18, $24, $00, $00

; Additional replacement blocks $50-$53
.PATCH 05:AD70 ; 16D80
  .data $D4, $26, $D6, $D7
  .data $DC, $DD, $DE, $26
;  .data $26, $CD, $CE, $CF
;  .data $D0, $D1, $26, $D3

; -----------------------
; Block Replacement Data
; -----------------------
; Reclaim several tiles by remapping blocks that use wasted ground tiles

.PATCH 05:A3D4 ; 163E4, this is where the compressed dungeon passage columns were located so reuse the space
  .dsb $12, $FF ; mark free space

; we take this replacement approach so that Zelda Tech doesn't become a complete mess
; TODO: build process instead?
.PATCH 05:BB24 ; 17B14
  ReplacedBlocks:
    .data $2E, $2F, $30, $31, $23, $21, $1E, $1F, $34, $35;, $32, $33 ; replace these blocks
  ReplacementBlocks:
    .data $48, $49, $4A, $4B, $4C, $4D, $4E, $4F, $50, $51;, $50, $51 ; with these tile sequences

.PATCH 05:AA89 ; 16A99
  JSR CheckReplacements ; was CheckSecretTileReplacement

.PATCH 05:BB60 ; 17B70 map generator checks this location
  CheckReplacements:
    ; exit if block is not between 1E and 35
    LDX BlockIndex
    CPX #$1E
    BCC ++
    CPX #$36
    BCS ++
    ; loop through the blocks above to check for a match
    LDX #(ReplacementBlocks - ReplacedBlocks)
  - LDY ReplacedBlocks,X  ; map generator checks this location as well
    CPY BlockIndex
    BEQ +                    ; jump if the block is found
    DEX
    BPL -
    BMI ++                   ; jump to secret check if nothing was found
    ; replace the block
  + LDY ReplacementBlocks,X  ; load the replacement value
    STY BlockIndex           ; and overwrite the index
    RTS
 ++ JMP CheckSpecialBlocks   ; this will RTS
