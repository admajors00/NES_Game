.ifndef _BACKGROUNDS_INC
_BACKGROUNDS_INC  =1


.struct Background_t
    num_obsticles   .byte
    obsticle_list   .addr
    background_data .addr
    attribute_data  .addr
    
.endstruct



NUM_BACKGROUNDS = 7



Background_1_Objects:
    .addr   Cone, Cone

MarketSign:
    .byte 0
    .addr 0
    .addr Market_Sign_bg
    .addr Market_Sign_at
LakeSign:
    .byte 0
    .addr 0
    .addr Lake_sign_bg
    .addr Lake_sign_at
SkateParkSign:
    .byte 0
    .addr 0
    .addr SkatePark_sign_bg
    .addr SkatePark_sign_at
House:
    .byte 0
    .addr 0
    .addr House_bg 
    .addr House_at  


Lv1_bg_1:
    .byte 1
    .addr Pothole
    .addr Level_1_1_bg
    .addr Level_1_1_at

Lv1_bg_2:
    .byte 0
    .addr 0
    .addr Level_1_2_bg
    .addr Level_1_2_at

Lv1_bg_3:
    .byte 1
    .addr Grate
    .addr Level_1_3_bg
    .addr Level_1_3_at

Lv1_bg_4:
    .byte 1
    .addr Ramp
    .addr Level_1_4_bg
    .addr Level_1_4_at
Lv1_bg_5:
    .byte 1
    .addr Cone
    .addr Level_1_4_bg
    .addr Level_1_4_at

Lv1_bg_6:
    .byte 0
    .addr 0
    .addr Level_1_4_bg
    .addr Level_1_4_at
Lv1_bg_7:
    .byte 1
    .addr Pothole
    .addr Level_1_4_bg
    .addr Level_1_4_at
Lv1_bg_8:
    .byte 1
    .addr Grate
    .addr Level_1_4_bg
    .addr Level_1_4_at

Level_1_bg_Array:
    .addr Lv1_bg_6
    .addr Lv1_bg_5
    .addr Lv1_bg_1
    .addr Lv1_bg_2
    .addr Lv1_bg_3
    .addr Lv1_bg_6
    .addr Lv1_bg_6





Lv2_bg_1:
    .byte 1
    .addr Cone
    .addr Level_2_1_bg
    .addr Level_2_1_at
Lv2_bg_2:
    .byte 0
    .addr 0
    .addr Level_2_2_bg
    .addr Level_2_2_at

Lv2_bg_3:
    .byte 1
    .addr Pothole
    .addr Level_2_2_bg
    .addr Level_2_2_at

Lv2_bg_4:
    .byte 1
    .addr Pothole
    .addr Level_2_2_bg
    .addr Level_2_2_at
Lv2_bg_5:
    .byte 1
    .addr Cone
    .addr Level_2_2_bg
    .addr Level_2_2_at
Lv2_bg_6:
    .byte 0
    .addr 0
    .addr Level_2_2_bg
    .addr Level_2_2_at
Lv2_bg_7:
    .byte 1
    .addr Crack
    .addr Level_2_2_bg
    .addr Level_2_2_at
Lv2_bg_8:
    .byte 1
    .addr Grate
    .addr Level_2_2_bg
    .addr Level_2_2_at

Lv2_bg_9:
    .byte 1
    .addr Ramp
    .addr Level_2_2_bg
    .addr Level_2_2_at

House_to_Market_bg_Array:
    .addr House
    .addr Lv2_bg_5
    .addr Lv2_bg_9
    .addr Lv2_bg_2
    .addr MarketSign

Level_2_2_bg_Array:
    .addr Lv2_bg_6
    .addr Lv2_bg_5
    .addr Lv2_bg_1
    .addr Lv2_bg_7
    .addr Lv2_bg_6
    .addr Lv2_bg_5
    .addr LakeSign

Level_2_3_bg_Array:
    .addr Lv2_bg_6
    .addr Lv2_bg_5
    .addr Lv2_bg_1
    .addr Lv2_bg_2
    .addr Lv2_bg_6
    .addr Lv2_bg_5
    .addr SkateParkSign   
    
Level_Random_bg_Array:
    .addr Lv2_bg_1
    .addr Lv2_bg_2
    .addr Lv2_bg_3
    .addr Lv2_bg_9
    .addr Lv2_bg_5
    .addr Lv2_bg_6
    .addr Lv2_bg_7
    .addr Lv2_bg_8 



Lv3_bg_1:
    .byte 0
    .addr 0
    .addr Level_3_1_bg
    .addr Level_3_1_at
Lv3_bg_2:
    .byte 0
    .addr 0
    .addr Level_3_2_bg
    .addr Level_3_2_at

Lv3_bg_3:
    .byte 1
    .addr CautionSign
    .addr Level_3_1_bg
    .addr Level_3_1_at

Lv3_bg_4:
    .byte 1
    .addr CautionSign
    .addr Level_3_2_bg
    .addr Level_3_2_at

Lv3_bg_5:
    .byte 1
    .addr Crack
    .addr Level_3_1_bg
    .addr Level_3_1_at

Lv3_bg_6:
    .byte 1
    .addr Crack
    .addr Level_3_2_bg
    .addr Level_3_2_at
Lv3_bg_7:
    .byte 1
    .addr Crack
    .addr Level_3_3_bg
    .addr Level_3_3_at
Lv3_bg_8:
    .byte 0
    .addr 0
    .addr Level_3_4_bg
    .addr Level_3_4_at
Lv3_bg_9:
    .byte 0
    .addr 0
    .addr Level_3_5_bg
    .addr Level_3_5_at
; .org $430


 
Level_3_bg_Array:
    .addr Lv3_bg_1
    .addr Lv3_bg_2
    .addr Lv3_bg_7 ;crack
    .addr Lv3_bg_4
    .addr Lv3_bg_9
 




Intro_bg_1:
    .byte 0
    .addr 0
    .addr Intro_1_bg
    .addr Intro_1_at
Intro_bg_2:
    .byte 0
    .addr 0
    .addr Intro_2_bg
    .addr Intro_2_at
Intro_bg_3:
    .byte 0
    .addr 0
    .addr Intro_3_bg
    .addr Intro_3_at
Intro_bg_4:
    .byte 0
    .addr 0
    .addr Intro_4_bg
    .addr Intro_4_at
Intro_bg_Array:
    .addr Intro_bg_1
    .addr Intro_bg_2
    .addr Intro_bg_3
    .addr Intro_bg_4


.org $400
Scroll_Buffer: .res 32
Attribute_Buffer: .res 32
.reloc


.endif