.ifndef _OBSTICLE_INC
_OBSTICLE_INC  =1

.enum Obstical_Types_e
    trip = 0
    rail = 1
    ramp = 2
    rough = 3
.endenum

; .enum Obstical_States_e
;     idle = 0
;     knocked_over = 1
; .endenum

.struct Obstical_t
    pos_x               .byte
    pos_y               .byte
    length              .byte
    height              .byte
    type                .byte
 ;   state               .byte
    animation_header_addr.addr
.endstruct


Crack:
    .byte $80
    .byte $BA
    .byte $0F
    .byte $0F
    .byte Obstical_Types_e::rough
    ;.byte Obstical_States_e::idle
    .addr Crack_Ani_Header

CautionSign:
    .byte $80
    .byte $Ba
    .byte $0F
    .byte $0F
    .byte Obstical_Types_e::trip
    .addr CautionSign_Ani_Header

Cone:
    .byte $80
    .byte $B6
    .byte $0F
    .byte $0F
    .byte Obstical_Types_e::trip
    ;.byte Obstical_States_e::idle
    .addr Cone_Ani_Header

Pothole:
    .byte $80
    .byte $B6
    .byte $0F
    .byte $0A
    .byte Obstical_Types_e::trip
   ; .byte Obstical_States_e::idle
    .addr Pothole_Ani_Header

Grate:
    .byte $80
    .byte $B6
    .byte $18
    .byte $0A
    .byte Obstical_Types_e::rough
  ;  .byte Obstical_States_e::idle
    .addr Grate_Ani_Header
Ramp:
    .byte $80
    .byte $B6
    .byte $0F
    .byte $0F
    .byte Obstical_Types_e::ramp
  ;  .byte Obstical_States_e::idle
    .addr Ramp_Ani_Header

.endif