.ifndef _BACKGROUNDS_INC
_BACKGROUNDS_INC  =1


.struct Background_t
    num_obsticles .byte
    obsticle_list    .addr
    background_data .addr
.endstruct



NUM_BACKGROUNDS = 7



Background_1_Objects:
    .addr   Cone, Cone

Lv1_bg_1:
    .byte 1
    .addr Pothole
    .addr Level_Screen_1

Lv1_bg_2:
    .byte 0
    .addr 0
    .addr Level_Screen_2

Lv1_bg_3:
    .byte 1
    .addr Grate
    .addr Level_Screen_3

Lv1_bg_4:
    .byte 1
    .addr Ramp
    .addr Level_Screen_4
Lv1_bg_5:
    .byte 1
    .addr Cone
    .addr Level_Screen_4

Lv1_bg_6:
    .byte 0
    .addr 0
    .addr Level_Screen_4
Lv1_bg_7:
    .byte 1
    .addr Pothole
    .addr Level_Screen_4


Lv2_bg_1:
    .byte 1
    .addr Cone
    .addr Level_Screen_2_1
Lv2_bg_2:
    .byte 0
    .addr 0
    .addr Level_Screen_2_2

Lv2_bg_3:
    .byte 1
    .addr Pothole
    .addr Level_Screen_2_3

Lv2_bg_4:
    .byte 1
    .addr Pothole
    .addr Level_Screen_2_2
Lv2_bg_5:
    .byte 1
    .addr Cone
    .addr Level_Screen_2_3

Lv2_bg_6:
    .byte 0
    .addr 0
    .addr Level_Screen_2_3

; .org $430
Level_2_bg_Array:
    .addr Lv2_bg_6
    .addr Lv2_bg_5
    .addr Lv2_bg_1
    .addr Lv2_bg_2
    .addr Lv2_bg_3
    .addr Lv2_bg_4
    .addr Lv2_bg_6
    .addr Lv2_bg_5  
Level_1_bg_Array:
    .addr Lv1_bg_6
    .addr Lv1_bg_5
    .addr Lv1_bg_1
    .addr Lv1_bg_2
    .addr Lv1_bg_3
    .addr Lv1_bg_4
    .addr Lv1_bg_6
    .addr Lv1_bg_7
    .addr Lv1_bg_6
    .addr Lv1_bg_7
    .addr Lv1_bg_6
Level_3_bg_Array:
    .addr Lv1_bg_6
    .addr Lv1_bg_5
    .addr Lv1_bg_1
    .addr Lv1_bg_2
    .addr Lv1_bg_3
    .addr Lv1_bg_4
    .addr Lv1_bg_6
    .addr Lv1_bg_5
    .addr Lv1_bg_5
    .addr Lv1_bg_5
    .addr Lv1_bg_5
 
Level_4_bg_Array:
    .addr Lv2_bg_1
    .addr Lv2_bg_1
    .addr Lv2_bg_1
    .addr Lv2_bg_1
    .addr Lv2_bg_1
    .addr Lv2_bg_1
    .addr Lv2_bg_1
    .addr Lv2_bg_1 
.org $460
Scroll_Buffer: .res 32
Attribute_Buffer: .res 32
.reloc


.endif