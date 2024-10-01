;======================
; Tree Tiles and Block
;======================

 ; tiles $AA thru $BB
.PATCH $CCEB
  .incbin "tree.chr"

.PATCH $D03B ; Tile $DF
  .incbin "tree_root.chr"

; tree root block
.PATCH 05:AD6C ; 16D7C
  .data $26, $DF, $AE, $AF

; make tree root tile unwalkable
.PATCH 07:EDF3 ; 1EE03
  .data $00
