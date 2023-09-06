;adress space is $20-$2F

.scope animation

    ani_pointer_table_addr_HIGH = $20
    ani_pointer_table_addr_LOW = $21
    animation_timer = $22
    animation_frames = $23
    oam_size = $23

    Load_Animation:
        ;pointer addr for animation will be loaded into a before calling
        ;store address into ani_pointer_table_addr_
        ;put initial frame into buffer
        ;return


    rts

    update_animation:
        ;decrement timer
        ;if timer is 0 
        ;   load next frame
        ;else
        ;   return
    rts

    store_frame:
        ;load frame pointer
        ;if 0 
        ;   return
        ;else
        ;   add tile offset to player position
        ;   store position and everything into oam dma
        ;   increase oam size
    rts
.endscope




EWL_StreetSkate_Walk_1_data:


	.byte  8, 24,$24,0
	.byte   0, 24,$25,0
	.byte  8, 16,$26,0
	.byte   0, 16,$27,0

	.byte  8, 8,$4d,0
	.byte   0, 8,$50,0
	.byte $80


EWL_StreetSkate_Walk_2_data:


	.byte   8, 24,$24,0
	.byte   0, 24,$25,0
	.byte   8, 16,$26,0
	.byte   0, 16,$27,0

	.byte   8,  8,$51,0
	.byte   0,  8,$54,0
	.byte $80


EWL_StreetSkate_Walk_3_data:


	.byte   8, 24,$24,0
	.byte   0, 24,$25,0
	.byte   8, 16,$26,0
	.byte   0, 16,$27,0

	.byte   8,  8,$55,0
	.byte   0,  8,$58,0
	.byte $80


EWL_StreetSkate_Walk_4_data:


	.byte 8, 24,$24,0
	.byte   0, 24,$25,0
	.byte 8,16,$26,0
	.byte   0,16,$27,0

	.byte 8,8,$59,0
	.byte   0,8,$5c,0
	.byte $80




Walk_Ani_pointers:

	.word EWL_StreetSkate_Walk_1_data
	.word EWL_StreetSkate_Walk_2_data
	.word EWL_StreetSkate_Walk_3_data
	.word EWL_StreetSkate_Walk_4_data



