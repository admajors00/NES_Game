.ifndef _FRAMES_INC
_FRAMES_INC = 1

EWL_StreetSkate_Walk_1_data:


	.byte 16,24,$24,0
	.byte  8,24,$25,0
	.byte 16,16,$26,0
	.byte  8,16,$27,0

	.byte 16, 8,$4d,0
	.byte  8, 8,$50,0
	.byte $80


EWL_StreetSkate_Walk_2_data:


	.byte 16,24,$24,0
	.byte  8,24,$25,0
	.byte 16,16,$26,0
	.byte  8,16,$27,0

	.byte 16, 8,$51,0
	.byte  8, 8,$54,0
	.byte $80


EWL_StreetSkate_Walk_3_data:


	.byte 16,24,$24,0
	.byte  8,24,$25,0
	.byte 16,16,$26,0
	.byte  8,16,$27,0

	.byte 16, 8,$55,0
	.byte  8, 8,$58,0
	.byte $80


EWL_StreetSkate_Walk_4_data:


	.byte 16,24,$24,0
	.byte  8,24,$25,0
	.byte 16,16,$26,0
	.byte  8,16,$27,0

	.byte 16, 8,$59,0
	.byte  8, 8,$5c,0
	.byte $80


EWL_StreetSkate_Push_1_data:


	.byte 16, 4,$d1,0
	.byte  8, 4,$d4,0
	.byte 16,24,$24,0
	.byte  8,24,$25,0

	.byte 16,16,$26,0
	.byte  8,16,$27,0
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0
	.byte $80


EWL_StreetSkate_Push_2_data:


	.byte  8, 4,$d8,0
	.byte 16, 4,$d5,0
	.byte 15,23,$28,0
	.byte  7,23,$29,0

	.byte 15,15,$2a,0
	.byte  7,15,$2b,0
	.byte 17, 8,$e4,0
	.byte  9, 8,$e5,0

	.byte  9,  0,$e7,0
	.byte $80


EWL_StreetSkate_Push_3_data:


	.byte 16, 4,$d9,0
	.byte  8, 4,$dc,0
	.byte 15,23,$28,0
	.byte  7,23,$29,0

	.byte 15,15,$2a,0
	.byte  7,15,$2b,0
	.byte  9, 8,$e9,0
	.byte 17, 8,$e8,0

	.byte 17,  0,$ea,0
	.byte $80


EWL_StreetSkate_Push_4_data:


	.byte 16, 4,$d1,0
	.byte  8, 4,$d4,0
	.byte 15,23,$28,0
	.byte  7,23,$29,0

	.byte 15,15,$2a,0
	.byte  7,15,$2b,0
	.byte  9, 8,$ed,0
	.byte 17, 8,$ec,0
	.byte $80


EWL_StreetSkate_Jump_1_data:


	.byte 16, 4,$d1,0
	.byte  8, 4,$d4,0
	.byte 16,21,$24,0
	.byte  8,21,$25,0

	.byte 16,13,$26,0
	.byte  8,13,$27,0
	.byte  8, 7,$f1,0
	.byte 15, 7,$f4,0
	.byte $80


EWL_StreetSkate_Jump_2_data:


	.byte 16, 8,$fe,0
	.byte  8, 8,$ff,0
	.byte  8,16,$fd,0
	.byte 16,32,$24,0

	.byte  8,32,$25,0
	.byte 16,24,$26,0
	.byte  8,24,$27,0
	.byte 16,16,$e8,0

	.byte 16, 8,$ea,0
	.byte  8,16,$e9,0
	.byte $80


EWL_StreetSkate_Jump_3_data:


	.byte 16,16,$d1,0
	.byte  8,16,$d4,0
	.byte 16,32,$24,0
	.byte  8,32,$25,0

	.byte 16,24,$26,0
	.byte  8,24,$27,0
	.byte  8,16,$f1,0
	.byte 15,16,$f4,0
	.byte $80


EWL_StreetSkate_Jump_4_data:


	.byte 16, 4,$d1,0
	.byte  8, 4,$d4,0
	.byte 16,24,$24,0
	.byte  8,24,$25,0

	.byte 16,16,$26,0
	.byte  8,16,$27,0
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0
	.byte $80


EWL_StreetSkate_pointers_walk:

	.word EWL_StreetSkate_Walk_1_data
	.word EWL_StreetSkate_Walk_2_data
	.word EWL_StreetSkate_Walk_3_data
	.word EWL_StreetSkate_Walk_4_data

	

EWL_StreetSkate_pointers_push:
	.word EWL_StreetSkate_Push_2_data
	.word EWL_StreetSkate_Push_3_data
	.word EWL_StreetSkate_Push_4_data
    .word EWL_StreetSkate_Push_1_data
	

EWL_StreetSkate_pointers_jump:
    .word EWL_StreetSkate_Jump_1_data
	.word EWL_StreetSkate_Jump_2_data
	.word EWL_StreetSkate_Jump_3_data
	.word EWL_StreetSkate_Jump_4_data


EWL_StreetSkate_pointers_IDLE:
	.word EWL_StreetSkate_Push_1_data

.endif