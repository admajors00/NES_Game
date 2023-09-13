.ifndef _ANIMATIONS_INC

_ANIMATIONS_INC = 1

INTERRUUPTABLE = 1<<4
IDLE     = 1 << 3
LOOP   = 1 << 2
PAUSE   = 1 << 1
STARTED  = 1 << 0
.struct Animation_Header_t  
    num_frames          .byte
    frame_index         .byte
    frames_pt           .addr
    frame_timers_pt     .addr
    flags               .byte   
.endstruct


.struct Linked_List
    data_pt     .addr
    prev        .addr
    next        .addr
.endstruct
.endif
