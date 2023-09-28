.ifndef _BACKGROUNDS_INC
_BACKGROUNDS_INC  =1


.struct Background_t
    num_obsticles .byte
    obsticle_list    .addr
    background_data .addr
.endstruct









Background_1_Objects:
    .addr   Cone, Cone

Background_1:
    .byte 1
    .addr Cone
    .addr 0

Background_2:
    .byte 0
    .addr 0
    .addr 0

Background_3:
    .byte 1
    .addr Pothole
    .addr 0


.org $430
Backgrounds_Array:
    .addr Background_1
    .addr Background_2
    .addr Background_3

.reloc
.endif