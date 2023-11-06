.ifndef _LEVELS_INC
_LEVELS_INC  =1

.struct Level_t
    num_screens .byte 
    backgrounds_pt .addr
    pallet_table_pt .addr
    bank_num .byte 
    bg_color .byte
.endstruct

NUM_LEVELS = 4

Level_1_h:
    .byte 11
    .addr Level_1_bg_Array
    .addr palette_level_1
    .byte 1
    .byte $0F
Level_2_h:
    .byte 8
    .addr Level_2_bg_Array
    .addr palette_level_2
    .byte 2
    .byte $11
Level_3_h:
    .byte 11
    .addr Level_3_bg_Array
    .addr palette_level_3
    .byte 2
    .byte $30

Level_4_h:
    .byte 8
    .addr Level_4_bg_Array
    .addr palette_level_2
    .byte 2
    .byte $11    

Levels_table:
    .addr Level_3_h,Level_1_h, Level_2_h,Level_4_h

.endif