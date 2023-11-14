.ifndef _LEVELS_INC
_LEVELS_INC  =1

.struct Level_t
    num_screens .byte 
    backgrounds_pt .addr
    pallet_table_pt .addr
    bank_num .byte 
    bg_color .byte
.endstruct

NUM_LEVELS = 5

Level_1_h:
    .byte 11
    .addr Level_1_bg_Array
    .addr palette_level_1
    .byte 1
    .byte $0F
 Level_2_1_h:
    .byte 9
    .addr Level_2_1_bg_Array
    .addr palette_house
    .byte 2
    .byte $11
 
 Level_2_2_h:
    .byte 9
    .addr Level_2_2_bg_Array
    .addr palette_level_2
    .byte 2
    .byte $11  
 Level_2_3_h:
    .byte 9
    .addr Level_2_3_bg_Array
    .addr palette_level_2_night
    .byte 2
    .byte $0C          
Level_3_h:
    .byte 12
    .addr Level_3_bg_Array
    .addr palette_level_3
    .byte 2
    .byte $30

  
Level_Random_h:
    .byte 9
    .addr Level_Random_bg_Array
    .addr palette_level_2
    .byte 2
    .byte $11
Intro_h:
    .byte 4
    .addr Intro_bg_Array 
    .addr palette_Intro
    .byte 0
    .byte $30

Levels_table:
    .addr Level_2_1_h, Level_3_h,Level_2_2_h, Level_1_h,Level_2_3_h

.endif