TileIndex       = $0A
LoopIndex       = $0B
LevelNum        = $10
FrameCounter    = $15
SpriteX         = $70
SpriteY         = $84
Invulnerability = $04F0
WriteBossSprite = $9893

.PATCH $F1EB
  .incbin "skeleton.chr"

.PATCH 03:8022
  .word $B1DB ; repoint level 7 graphics

;.PATCH 06:A292 ; 1A2B2
;  .data $17, $28, $39 ; new palette (affects aquamentus as well)

.PATCH 04:9449 ; 11459
  JSR HandleHitPoints

.PATCH 04:984C ; 1185C
  JMP BossDraw ; hijack draw aquamentus
  NOP
  DefaultBoss:

.PATCH 04:B4A0 ; 134B0
  ; Each frame has 6 tiles (representing the top of 6 sprites).
  BossTiles:
    .data $C0, $C2, $C4, $1C, $C6, $C8
    .data $C0, $C2, $C4, $1C, $CA, $CC
  BossSpriteOffsetsY:
    .data $00, $00, $00, $10, $10, $10
  BossSpriteOffsetsX:
    .data $00, $08, $10, $00, $08, $10
  BossDraw:
    LDY LevelNum
    CPY #$07                 ; Check for level 7
    BEQ +
    LDY #$05                 ; Execute the two hijacked lines
    LDA FrameCounter
    JMP DefaultBoss          ; Then return to where it left off
  + LDY #$05                 ; The last tile of frame 0 is at index 5
    LDA FrameCounter
    AND #$20                 ; Every $20 screen frames, switch animation frames
    BNE +
    LDY #$0B                 ; The last tile of frame 1 is at index $B
  + STY TileIndex            ; [0A] holds the current tile index in frame tile list
    LDA #$05                 ; For each sprite, from 5 to 0, indexed by [0B]:
    STA LoopIndex

  @LoopTiles:
    LDY LoopIndex            ; Get current loop index
    LDA SpriteX,X            ; Get the current sprite's X offset
    CLC
    ADC BossSpriteOffsetsX,Y ; And add the current boss's X coordinate
    STA $00                  ; Store it in [00]
    LDA SpriteY,X            ; Get the current sprite's Y offset
    CLC
    ADC BossSpriteOffsetsY,Y ; And add the current boss's Y coordinate
    STA $01                  ; Store it in [01]

    ; If the boss is temporarily invincible, then this makes it flash by cycling all the palette rows
    ; Otherwise invincibility timer = 0. So [03] becomes 3:
    ; the attribute value for a normal sprite with palette row 7 (level).
    LDA Invulnerability,X
    AND #$03
    EOR #$02                 ; Set palette index
    STA $03

    LDA $28,X                ; Load timer
    CMP #$20                 ; Compare to desired interval
    BCC +++                  ; Jump if not above threshold

    LDY LoopIndex            ; Load the index 0-5
    BNE ++                   ; Move to the next check if not the first frame (0)
    LDA #$CE                 ; Otherwise load alternate frame
    BNE @WriteSprite

 ++ CPY #$03                 ; Check if it's the 4th frame
    BNE +++                  ; Otherwise jump
    LDA #$D0                 ; Load alternate frame
    BNE @WriteSprite

+++ LDY TileIndex
    LDA BossTiles,Y          ; Look up the current tile
  @WriteSprite:
    JSR WriteBossSprite
    ; Bottom of the loop.
    ; Decrement tile index and loop index.
    DEC TileIndex
    DEC LoopIndex
    BPL @LoopTiles
  RTS

  HandleHitPoints:
    STA $04B2,X              ; run hijacked code
    LDY LevelNum
    CPY #$07                 ; Check for level 7
    BNE +
      LDA #$FF
      STA $486
    +
  RTS
