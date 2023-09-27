.ifndef _OBJECTS_INC
_OBJECTS_INC  =1

.enum Obstical_Types_e
    cone = 0
    rail = 1
    ramp = 2
.endenum

.enum Obstical_States_e
    idle = 0
    knocked_over = 1
.endenum

.struct Object_t
    pos_x           .byte
    pos_y           .byte
    length          .byte
    height          .byte
    type            .byte
    state           .byte
    animation_header.byte
.endstruct


.endif