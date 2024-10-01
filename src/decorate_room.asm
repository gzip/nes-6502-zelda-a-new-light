LevelNum           := $10
CurrentScreen      := $EB
GetUniqueRoomId    := $E85A

.PATCH 05:BFE2 ; 17FF2
  ItemRoomCorners:
    .byte $66, $6A, $54 ; 666A tl
    .byte $66, $6F, $55 ; 666F bl
    .byte $67, $88, $56 ; 6788 tr
    .byte $67, $8d, $57 ; 678d br
  PassageRoomCorners:
    .byte $65, $96, $54 ; 6596 tl
    .byte $65, $99, $55 ; 6599 bl
    .byte $67, $90, $56 ; 6790 tr
    .byte $67, $93, $57 ; 6793 br

.PATCH 05:AAF0 ;
  JMP DecorateRoom

.PATCH 05:AF80 ; 16F6C
  DecorateRoom:
    ; bail if overworld
    LDY LevelNum
    BEQ +++

    ; otherwise get the room template id
    JSR GetUniqueRoomId

    ; passageway
    CMP #$3E
    BNE +
    LDX #<PassageRoomCorners
    LDY #>PassageRoomCorners
    LDA #12
    BNE ++

    ; item room
  + CMP #$3F
    BNE +++
    LDX #<ItemRoomCorners
    LDY #>ItemRoomCorners
    LDA #24

    ; store the vars required for the loop
 ++ STX $01
    STY $02
    STA $00

    ; run the write loop
    LDY #$00
    write_byte:
      LDA ($01),Y
      STA $04
      INY
      LDA ($01),Y
      STA $03
      INY
      TYA ; transfer Y to X to free it up
      TAX
      LDA ($01),Y
      LDY #0
      STA ($03),Y
      TXA ; transfer X back to Y
      TAY
      INY
      CPY $00
      BNE write_byte
  +++ RTS

; cd src && snarfblasm light_decorate_room.asm && cd .. && flips src/light_decorate_room.ips zelda.nes
