.ifndef _ANIMATIONS_INC


_ANIMATIONS_INC = 1

ALT_FRAME_TIMER_F = 1<<7
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

.enum objects_e
    obstical_0 = $00
    player = $01
    guy_chasing = $02
    obstical_1 = $03
    indicator = $04
.endenum

.enum Sprite_Positions_e
    obst_0_x = 0
    obst_0_y = 1
    player_x = 2
    player_y = 3
    chaser_x = 4
    chaser_y = 5
    obst_1_x = 6
    obst_1_y = 7
    ind_x    = 8
    ind_y    = 9
.endenum





push_frame_timers:
    .byte 1,8,8,8
Push_Ani_Header:
      .byte 4
      .byte 3
      .addr EWL_StreetSkate_pointers_push
      .addr EWL_StreetSkate_Push_1_data
      .addr push_frame_timers
      .byte 8
      .byte %00010000 | objects_e::player



jump_frame_timers:
    .byte 4,8,10,10,8

Jump_Ani_Header:
      .byte 5
      .byte 5
      .addr EWL_StreetSkate_pointers_jump
      .addr EWL_StreetSkate_Jump_1_data
      .addr jump_frame_timers
      .byte 2
      .byte %00010000 | objects_e::player



coast_frame_timers:
    .byte 4,8,8,8

Coast_Ani_Header:
      .byte 4
      .byte 4
      .addr EWL_StreetSkate_pointers_coasting
      .addr EWL_StreetSkate_Coasting_1_data
      .addr coast_frame_timers
      .byte 8
      .byte %11010000 | objects_e::player
loadUp_frame_timers:
    .byte 4,8,8,8
LoadUp_Ani_Header:
    .byte 4
    .byte 4
    .addr EWL_StreetSkate_pointers_loadUp
    .addr EWL_StreetSkate_LoadUp_1_data
    .addr loadUp_frame_timers
    .byte 8
    .byte %11010000 | objects_e::player


crash_frame_timers:
    .byte $FF, 4,4,4

Crash_Ani_Header:
      .byte 4
      .byte 4
      .addr EWL_StreetSkate_pointers_Crash
      .addr EWL_StreetSkate_Crash_1_data
      .addr crash_frame_timers
      .byte 4
      .byte %00010000 | objects_e::player

idle_frame_timers:
    .byte 2

Idle_Ani_Header:
      .byte 1
      .byte 1
      .addr EWL_StreetSkate_pointers_idle
      .addr EWL_StreetSkate_Coasting_1_data
      .addr idle_frame_timers
      .byte 2
      .byte %01010000 | objects_e::player

kickFlip_frame_timers:
    .byte 4,4,4,4,4,4,4,8,4

KickFlip_Ani_Header:
      .byte 9
      .byte 9
      .addr EWL_StreetSkate_pointers_kickflip
      .addr EWL_StreetSkate_KickFlip_1_data
      .addr kickFlip_frame_timers
      .byte 2
      .byte %00010000 | objects_e::player

shuvIt_frame_timers:
    .byte 4,4,4,4,4,4,8,4

ShuvIt_Ani_Header:
      .byte 8
      .byte 8
      .addr EWL_StreetSkate_pointers_shuvIt
      .addr EWL_StreetSkate_ShuvIt_0_data
      .addr shuvIt_frame_timers
      .byte 2
      .byte %00010000 | objects_e::player

chaser_frame_timers:
    .byte 8,8,8,8

chaser_Ani_Header:
      .byte 4
      .byte 4
      .addr EWL_StreetSkate_pointers_chaser
      .addr EWL_StreetSkate_GuyRunning_1_data
      .addr chaser_frame_timers
      .byte 8
      .byte %11010000 | objects_e::guy_chasing


cone_frame_timers:
    .byte $FF

Cone_Ani_Header:
      .byte 2
      .byte 2
      .addr EWL_StreetSkate_pointers_cone
      .addr EWL_StreetSkate_Cone_1_data
      .addr cone_frame_timers
      .byte $FF
      .byte %01110000 | objects_e::obstical_1

 CautionSign_Ani_Header:
      .byte 2
      .byte 2
      .addr EWL_StreetSkate_pointers_cautionSign

      .addr EWL_StreetSkate_CautionSign_data
      .addr cone_frame_timers
      .byte $FF
      .byte %01110000 | objects_e::obstical_1
 Crack_Ani_Header:
      .byte 2
      .byte 2
      .addr EWL_StreetSkate_pointers_crack

      .addr EWL_StreetSkate_Crack_data
      .addr cone_frame_timers
      .byte $FF
      .byte %01110000 | objects_e::obstical_0      

Ramp_Ani_Header:
      .byte 2
      .byte 2
      .addr EWL_StreetSkate_pointers_ramp
      .addr EWL_StreetSkate_Ramp_data
      .addr cone_frame_timers
      .byte $FF
      .byte %01110000 | objects_e::obstical_0


pothole_frame_timers:
    .byte $FF

Pothole_Ani_Header:
    .byte 2
    .byte 2
    .addr EWL_StreetSkate_pointers_pothole
    .addr EWL_StreetSkate_Pothole_1_data
    .addr pothole_frame_timers
    .byte $FF
    .byte %01110000 | objects_e::obstical_0

grate_frame_timers:
    .byte $FF

Grate_Ani_Header:
    .byte 2
    .byte 2
    .addr EWL_StreetSkate_pointers_grate
    .addr EWL_StreetSkate_Grate_data
    .addr grate_frame_timers
    .byte $FF
    .byte %01110000 | objects_e::obstical_0

Indicator_Ani_Header:
      .byte 2
      .byte 2
      .addr EWL_StreetSkate_pointers_indicator
      .addr EWL_StreetSkate_Indicator_data
      .addr cone_frame_timers
      .byte $FF
      .byte %01100000 | objects_e::indicator ; initially not active




      Obs_0_Empty_Ani_Header: 
    .byte 0
    .byte 0
    .addr 0
    .addr 0
    .addr 0
    .byte 0
    .byte %00000000 | objects_e::obstical_0


    Obs_1_Empty_Ani_Header: 
    .byte 0
    .byte 0
    .addr 0
    .addr 0
    .addr 0
    .byte 0
    .byte %00000000 | objects_e::obstical_1
.endif



