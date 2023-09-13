.ifndef _ANIMATIONS_INC

_ANIMATIONS_INC = 1

INTERUPTABLE = 1<<7
LOOP   = 1 << 6
PAUSE   = 1 << 5
ACTIVE  = 1 << 4

ANI_OBJECTS_MASK = %00001111
ANI_FLAGS_MASK = %11110000

.struct Animation_Header_t  
    num_frames          .byte
    frame_index         .byte
    frames_pt           .addr
    frame               .addr
    frame_timers_pt     .addr
    frame_timer         .byte
    flags               .byte ;lower 4 bits determine what object its associated with, upper 4 are flags
.endstruct

.enum objects
    player = $00
    guy_chasing = $01
    obstical_1 = $02
    obstical_2 = $03
.endenum

.struct Linked_List
    data_pt     .addr
    prev        .addr
    next        .addr
.endstruct
.endif
