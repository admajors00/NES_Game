.ifndef _LEVELS_INC
_LEVELS_INC  =1

.struct Level_t
    num_screens .byte 
    backgrounds_pt .addr
    pallet_table_pt .addr
    bank_num .byte 
    bg_color .byte
.endstruct

NUM_LEVELS = 2

Level_1_h:
    .byte 7
    .addr Level_1_bg_Array
    .addr palette_level_1
    .byte 1
    .byte $0F
Level_2_h:
    .byte 7
    .addr Level_2_bg_Array
    .addr palette_level_2
    .byte 2
    .byte $11

Levels_table:
    .addr Level_1_h, Level_2_h

.endif