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


.endif