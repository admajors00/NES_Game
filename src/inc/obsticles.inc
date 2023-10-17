.ifndef _OBSTICLE_INC
_OBSTICLE_INC  =1

.enum Obstical_Types_e
    cone = 0
    rail = 1
    ramp = 2
.endenum

.enum Obstical_States_e
    idle = 0
    knocked_over = 1
.endenum

.struct Obstical_t
    pos_x               .byte
    pos_y               .byte
    length              .byte
    height              .byte
    type                .byte
    state               .byte
    animation_header_addr.addr
.endstruct


Cone:
    .byte $B0
    .byte $B0
    .byte $0F
    .byte $0F
    .byte $00
    .byte $00
    .addr Cone_Ani_Header

Pothole:
    .byte $10
    .byte $B0
    .byte $0F
    .byte $0A
    .byte $00
    .byte $00
    .addr Pothole_Ani_Header

Grate:
    .byte $10
    .byte $B0
    .byte $0F
    .byte $0A
    .byte $00
    .byte $00
    .addr Pothole_Ani_Header

.endif