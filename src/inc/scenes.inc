.ifndef _SCENES_INC
_SCENES_INC = 1


.struct Scene_t
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


Lv1_sc_1:
    .byte 1
    .addr Pothole
    .addr Level_1_1_bg
    .addr Level_1_1_at

Lv1_sc_2:
    .byte 0
    .addr 0
    .addr Level_1_2_bg
    .addr Level_1_2_at

Lv1_sc_3:
    .byte 1
    .addr Grate
    .addr Level_1_3_bg
    .addr Level_1_3_at

Lv1_sc_4:
    .byte 1
    .addr Ramp
    .addr Level_1_4_bg
    .addr Level_1_4_at
Lv1_sc_5:
    .byte 1
    .addr Cone
    .addr Level_1_4_bg
    .addr Level_1_4_at

Lv1_sc_6:
    .byte 0
    .addr 0
    .addr Level_1_4_bg
    .addr Level_1_4_at
Lv1_sc_7:
    .byte 1
    .addr Pothole
    .addr Level_1_4_bg
    .addr Level_1_4_at
Lv1_sc_8:
    .byte 1
    .addr Grate
    .addr Level_1_4_bg
    .addr Level_1_4_at

Level_1_sc_Array:

    .addr Lv1_sc_6
    .addr Lv1_sc_4
    .addr Lv1_sc_8
    .addr Lv1_sc_1
    .addr Lv1_sc_2
    .addr Lv1_sc_3
    .addr Lv1_sc_4
    .addr Lv1_sc_6
    .addr Lv1_sc_7
    .addr Lv1_sc_6
    .addr Lv1_sc_7
    .addr Lv1_sc_6




Lv2_sc_1:
    .byte 1
    .addr Cone
    .addr Level_2_1_bg
    .addr Level_2_1_at
Lv2_sc_2:
    .byte 0
    .addr 0
    .addr Level_2_2_bg
    .addr Level_2_2_at

Lv2_sc_3:
    .byte 1
    .addr Pothole
    .addr Level_2_2_bg
    .addr Level_2_2_at

Lv2_sc_4:
    .byte 1
    .addr Pothole
    .addr Level_2_2_bg
    .addr Level_2_2_at
Lv2_sc_5:
    .byte 1
    .addr Cone
    .addr Level_2_2_bg
    .addr Level_2_2_at
Lv2_sc_6:
    .byte 0
    .addr 0
    .addr Level_2_2_bg
    .addr Level_2_2_at
Lv2_sc_7:
    .byte 1
    .addr Crack
    .addr Level_2_2_bg
    .addr Level_2_2_at
Lv2_sc_8:
    .byte 1
    .addr Grate
    .addr Level_2_2_bg
    .addr Level_2_2_at

Lv2_sc_9:
    .byte 1
    .addr Ramp
    .addr Level_2_2_bg
    .addr Level_2_2_at

House_to_Market_sc_Array:
    .addr House
    .addr Lv2_sc_5
    .addr Lv2_sc_7
    .addr Lv2_sc_9
    .addr Lv2_sc_2
    .addr Lv2_sc_3
    .addr Lv2_sc_7
    .addr Lv2_sc_6
    .addr Lv2_sc_8
    .addr Lv2_sc_6
    .addr Lv2_sc_3
    .addr Lv2_sc_9
    .addr Lv2_sc_8
    .addr Lv2_sc_6
    .addr Lv2_sc_3
    .addr Lv2_sc_6
    .addr Lv2_sc_8
    .addr Lv2_sc_6
    .addr Lv2_sc_9
    .addr Lv2_sc_3
    .addr Lv2_sc_9
    .addr Lv2_sc_3
    .addr Lv2_sc_8
    .addr Lv2_sc_7
    .addr Lv2_sc_6
    .addr Lv2_sc_3
    .addr Lv2_sc_7
    .addr Lv2_sc_6
    .addr Lv2_sc_9
    .addr Lv2_sc_3
    .addr Lv2_sc_8
    .addr Lv2_sc_6
    .addr Lv2_sc_3
    .addr Lv2_sc_9
    .addr Lv2_sc_8
    .addr Lv2_sc_6
    .addr Lv2_sc_3
    .addr Lv2_sc_9
    .addr MarketSign
    .addr Lv2_sc_2
Level_2_2_sc_Array:
    .addr Lv2_sc_6
    .addr Lv2_sc_5
    .addr Lv2_sc_1
    .addr Lv2_sc_2
    .addr Lv2_sc_3
    .addr Lv2_sc_7
    .addr Lv2_sc_6
    .addr Lv2_sc_5
    .addr LakeSign
Level_2_3_sc_Array:
    .addr Lv2_sc_6
    .addr Lv2_sc_5
    .addr Lv2_sc_1
    .addr Lv2_sc_2
    .addr Lv2_sc_3
    .addr Lv2_sc_7
    .addr Lv2_sc_6
    .addr Lv2_sc_5
    .addr SkateParkSign   
    
Level_Random_sc_Array:
    .addr Lv2_sc_1
    .addr Lv2_sc_2
    .addr Lv2_sc_3
    .addr Lv2_sc_9
    .addr Lv2_sc_5
    .addr Lv2_sc_6
    .addr Lv2_sc_7
    .addr Lv2_sc_8 



Lv3_sc_1:
    .byte 0
    .addr 0
    .addr Level_3_1_bg
    .addr Level_3_1_at
Lv3_sc_2:
    .byte 0
    .addr 0
    .addr Level_3_2_bg
    .addr Level_3_2_at

Lv3_sc_3:
    .byte 1
    .addr CautionSign
    .addr Level_3_1_bg
    .addr Level_3_1_at

Lv3_sc_4:
    .byte 1
    .addr CautionSign
    .addr Level_3_2_bg
    .addr Level_3_2_at

Lv3_sc_5:
    .byte 1
    .addr Crack
    .addr Level_3_1_bg
    .addr Level_3_1_at

Lv3_sc_6:
    .byte 1
    .addr Crack
    .addr Level_3_2_bg
    .addr Level_3_2_at
Lv3_sc_7:
    .byte 1
    .addr Crack
    .addr Level_3_3_bg
    .addr Level_3_3_at
Lv3_sc_8:
    .byte 0
    .addr 0
    .addr Level_3_4_bg
    .addr Level_3_4_at
Lv3_sc_9:
    .byte 0
    .addr 0
    .addr Level_3_5_bg
    .addr Level_3_5_at
; .org $430


 
Level_3_sc_Array:
    .addr Lv3_sc_1
    .addr Lv3_sc_2
    .addr Lv3_sc_6 ;crack
    .addr Lv3_sc_2
    .addr Lv3_sc_7;crack
    .addr Lv3_sc_4 ;caution
    .addr Lv3_sc_5 ;pothole
    .addr Lv3_sc_4 ;caution
    .addr Lv3_sc_5 ;pothole
    .addr Lv3_sc_7 ;crack
    .addr Lv3_sc_4
    .addr Lv3_sc_6 ;crack
     .addr Lv3_sc_7;crack
    .addr Lv3_sc_2
   .addr Lv3_sc_4 ;caution
    .addr Lv3_sc_5 ;pothole
    .addr Lv3_sc_4 ;caution
    .addr Lv3_sc_5 ;pothole
   .addr Lv3_sc_4 ;caution
    .addr Lv3_sc_7;crack
    .addr Lv3_sc_4 ;caution
   
    .addr Lv3_sc_6
    .addr Lv3_sc_6 ;crack
    .addr Lv3_sc_5 ;pothole
    .addr Lv3_sc_7 ;crack
    .addr Lv3_sc_2
    .addr Lv3_sc_5 ;pothole
    .addr Lv3_sc_8
    .addr Lv3_sc_9
 




Intro_sc_1:
    .byte 0
    .addr 0
    .addr Intro_1_bg
    .addr Intro_1_at
Intro_sc_2:
    .byte 0
    .addr 0
    .addr Intro_2_bg
    .addr Intro_2_at
Intro_sc_3:
    .byte 0
    .addr 0
    .addr Intro_3_bg
    .addr Intro_3_at
Intro_sc_4:
    .byte 0
    .addr 0
    .addr Intro_4_bg
    .addr Intro_4_at
Intro_sc_Array:
    .addr Intro_sc_1
    .addr Intro_sc_2
    .addr Intro_sc_3
    .addr Intro_sc_4


.org $400
Scroll_Buffer: .res 32
Attribute_Buffer: .res 32
.reloc


.endif