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

Background_1:
    .byte 1
    .addr Cone
    .addr Longer_street_1

Background_2:
    .byte 0
    .addr 0
    .addr Longer_street_2

Background_3:
    .byte 1
    .addr Pothole
    .addr Longer_street_3

Background_4:
    .byte 1
    .addr Pothole
    .addr Longer_street_4
Background_5:
    .byte 1
    .addr Cone
    .addr Longer_street_4

Background_6:
    .byte 0
    .addr 0
    .addr Longer_street_4

; .org $430
Backgrounds_Array:
    .addr Background_1
    .addr Background_2
    .addr Background_3
    .addr Background_4
    .addr Background_6
    .addr Background_5
    .addr Background_6
    .addr Background_6

.org $460
Scroll_Buffer: .res 32
Attribute_Buffer: .res 32
.reloc


.endif