; Original source:
; minucce
; Ported to snarfblasm:
; gzip
; 
; License:
;  Code should be used only for educational, documentation and modding purposes.
;  Please keep derivative work open source.

.PATCH 05:854E ; 1455E

  ; reset y-scroll value with more precision
  LDY #$60

  ; manual timing
- NOP
  DEY
  BPL -

  NOP
  NOP
  NOP
  NOP
  NOP
  NOP

  LDA $2002 ; Reset latch

  LDA $58 ; Render-Y2
  LDY $E2 ; Render-Y1

  ; Credit to Quietust (nesdev) for explaining PPU Addr register scrolling

  STA $2006
  LDA #$00

  STY $2006 ; Render location  (must be h-blank)
  STA $2005 ; Fine X-pos
  RTS
