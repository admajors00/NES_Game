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

MarketSign:
    .byte 0
    .addr 0
    .addr Level_Screen_Market_sign
LakeSign:
    .byte 0
    .addr 0
    .addr Level_Screen_Lake_sign
SkateParkSign:
    .byte 0
    .addr 0
    .addr Level_Screen_SkatePark_sign
House:
    .byte 0
    .addr 0
    .addr Level_Screen_House   


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
Lv1_bg_8:
    .byte 1
    .addr Grate
    .addr Level_Screen_4

Level_1_bg_Array:
    .addr Lv1_bg_6
    .addr Lv1_bg_8
    .addr Lv1_bg_1
    .addr Lv1_bg_2
    .addr Lv1_bg_3
    .addr Lv1_bg_4
    .addr Lv1_bg_6
    .addr Lv1_bg_7
    .addr Lv1_bg_6
    .addr Lv1_bg_7
    .addr Lv1_bg_6




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
    .addr Level_Screen_2_2

Lv2_bg_4:
    .byte 1
    .addr Pothole
    .addr Level_Screen_2_2
Lv2_bg_5:
    .byte 1
    .addr Cone
    .addr Level_Screen_2_2
Lv2_bg_6:
    .byte 0
    .addr 0
    .addr Level_Screen_2_2
Lv2_bg_7:
    .byte 1
    .addr Crack
    .addr Level_Screen_2_2
Lv2_bg_8:
    .byte 1
    .addr Grate
    .addr Level_Screen_2_2

Level_2_1_bg_Array:
    .addr House
    .addr Lv2_bg_5
    .addr Lv2_bg_7
    .addr Lv2_bg_2
    .addr Lv2_bg_3
    .addr Lv2_bg_7
    .addr Lv2_bg_6
    .addr Lv2_bg_5
    .addr MarketSign
Level_2_2_bg_Array:
    .addr Lv2_bg_6
    .addr Lv2_bg_5
    .addr Lv2_bg_1
    .addr Lv2_bg_2
    .addr Lv2_bg_3
    .addr Lv2_bg_7
    .addr Lv2_bg_6
    .addr Lv2_bg_5
    .addr LakeSign
Level_2_3_bg_Array:
    .addr Lv2_bg_6
    .addr Lv2_bg_5
    .addr Lv2_bg_1
    .addr Lv2_bg_2
    .addr Lv2_bg_3
    .addr Lv2_bg_7
    .addr Lv2_bg_6
    .addr Lv2_bg_5
    .addr SkateParkSign   
    
Level_Random_bg_Array:
    .addr Lv2_bg_1
    .addr Lv2_bg_2
    .addr Lv2_bg_3
    .addr Lv2_bg_4
    .addr Lv2_bg_5
    .addr Lv2_bg_6
    .addr Lv2_bg_7
    .addr Lv2_bg_8 



Lv3_bg_1:
    .byte 0
    .addr 0
    .addr Level_Screen_3_1
Lv3_bg_2:
    .byte 0
    .addr 0
    .addr Level_Screen_3_2

Lv3_bg_3:
    .byte 1
    .addr CautionSign
    .addr Level_Screen_3_1

Lv3_bg_4:
    .byte 1
    .addr CautionSign
    .addr Level_Screen_3_2

Lv3_bg_5:
    .byte 1
    .addr Pothole
    .addr Level_Screen_3_1

Lv3_bg_6:
    .byte 1
    .addr Crack
    .addr Level_Screen_3_2
Lv3_bg_7:
    .byte 1
    .addr Crack
    .addr Level_Screen_3_3
Lv3_bg_8:
    .byte 0
    .addr 0
    .addr Level_Screen_3_4
Lv3_bg_9:
    .byte 0
    .addr 0
    .addr Level_Screen_3_5
; .org $430


 
Level_3_bg_Array:
    .addr Lv3_bg_1
    .addr Lv3_bg_2
    .addr Lv3_bg_6 ;crack
    .addr Lv3_bg_2
    .addr Lv3_bg_7;crack
    .addr Lv3_bg_4 ;caution
    .addr Lv3_bg_5 ;pothole
    .addr Lv3_bg_4 ;caution
    .addr Lv3_bg_5 ;pothole
    .addr Lv3_bg_7 ;crack
    .addr Lv3_bg_8
    .addr Lv3_bg_9
 




Intro_bg_1:
    .byte 0
    .addr 0
    .addr Intro_Screen_1
Intro_bg_2:
    .byte 0
    .addr 0
    .addr Intro_Screen_2
Intro_bg_3:
    .byte 0
    .addr 0
    .addr Intro_Screen_3
Intro_bg_4:
    .byte 0
    .addr 0
    .addr Intro_Screen_4
Intro_bg_Array:
    .addr Intro_bg_1
    .addr Intro_bg_2
    .addr Intro_bg_3
    .addr Intro_bg_4


.org $460
Scroll_Buffer: .res 32
Attribute_Buffer: .res 32
.reloc


.endif