.ifndef _BACKGROUNDS_INC
_BACKGROUNDS_INC  =1


.struct Background_t
    num_obsticles .byte
    obsticle_list    .addr
    background_data .addr
.endstruct


EWL_StreetSkate_Cone_1_data:


	.byte 11,16,$60,0
	.byte  8, 8,$63,0
	.byte 16, 8,$62,0
	.byte $80





EWL_StreetSkate_pointers_cone:
	.word EWL_StreetSkate_Cone_1_data
	.word EWL_StreetSkate_Cone_1_data

cone_frame_timers:
    .byte 8

Cone_Ani_Header:
      .byte 2
      .byte 2
      .addr EWL_StreetSkate_pointers_cone
      .addr EWL_StreetSkate_Cone_1_data
      .addr cone_frame_timers
      .byte 8
      .byte %11010010


Cone:
    .byte $B0
    .byte $B0
    .byte $0F
    .byte $0F
    .byte $00
    .byte $00
    .addr Cone_Ani_Header


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
    .addr Cone
    .addr 0

Background_4:
 .byte 1
    .addr Cone
    .addr 0
.org $430
Backgrounds_Array:
    .addr Background_1
    .addr Background_2
    .addr Background_3

.reloc
.endif