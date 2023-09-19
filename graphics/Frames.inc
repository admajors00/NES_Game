.ifndef _FRAMES_INC
_FRAMES_INC = 1

OAM_FLIP_H = %01000000
OAM_FLIP_V = %10000000



EWL_StreetSkate_Walk_4_data:


	.byte 16,24,$24,2
	.byte  8,24,$25,2
	.byte 16,16,$26,2
	.byte  8,16,$27,2

	.byte 16, 8,$59,2
	.byte  8, 8,$5c,0
	.byte $80


EWL_StreetSkate_Walk_3_data:


	.byte 16,24,$24,2
	.byte  8,24,$25,2
	.byte 16,16,$26,2
	.byte  8,16,$27,2

	.byte 16, 8,$55,0
	.byte  8, 8,$58,0
	.byte $80


EWL_StreetSkate_Walk_2_data:


	.byte 16,24,$24,2
	.byte  8,24,$25,2
	.byte 16,16,$26,2
	.byte  8,16,$27,2

	.byte 16, 8,$51,0
	.byte  8, 8,$54,0
	.byte $80


EWL_StreetSkate_Walk_1_data:


	.byte 16,24,$24,2
	.byte  8,24,$25,2
	.byte 16,16,$26,2
	.byte  8,16,$27,2

	.byte 16, 8,$4d,0
	.byte  8, 8,$50,0
	.byte $80


EWL_StreetSkate_Push_4_data:


	.byte 16,24,$24,2
	.byte  8,24,$25,2
	.byte 16,16,$26,2
	.byte  8,16,$27,2

	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0
	.byte  8, 4,$dc,0
	.byte 16, 4,$d5,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_Push_3_data:


	.byte 15,23,$28,2
	.byte  7,23,$29,2
	.byte 15,15,$2a,2
	.byte  7,15,$2b,2

	.byte  8, 8,$e1,0
	.byte 16, 9,$e8,0
	.byte 16, 4,$d8,0|OAM_FLIP_H
	.byte  8, 4,$d9,0
	.byte $80


EWL_StreetSkate_Push_2_data:


	.byte 15,23,$28,2
	.byte  7,23,$29,2
	.byte 15,15,$2a,2
	.byte  7,15,$2b,2

	.byte 17,  0,$ea,0
	.byte  8, 8,$e1,0
	.byte 14, 9,$e5,0
	.byte 16, 1,$e7,0

	.byte 16, 4,$d9,0|OAM_FLIP_H
	.byte  8, 4,$d8,0
	.byte $80


EWL_StreetSkate_Push_1_data:


	.byte 15,23,$28,2
	.byte  7,23,$29,2
	.byte 15,15,$2a,2
	.byte  7,15,$2b,2

	.byte 11, 8,$e4,0
	.byte 11,  0,$e6,0
	.byte 16, 4,$dc,0|OAM_FLIP_H
	.byte  8, 4,$d5,0
	.byte $80


EWL_StreetSkate_Jump_4_data:


	.byte 16,28,$24,2
	.byte  8,28,$25,2
	.byte 16,20,$26,2
	.byte  8,20,$27,2

	.byte  8,12,$f1,0
	.byte  8, 9,$d8,0
	.byte 16, 9,$d9,0|OAM_FLIP_H
	.byte  7,12,$ec,0

	.byte 15,13,$ed,0
	.byte $80


EWL_StreetSkate_Jump_3_data:


	.byte 16,32,$24,2
	.byte  8,32,$25,2
	.byte 16,24,$26,2
	.byte  8,24,$27,2

	.byte  8,13,$d8,0
	.byte 16,13,$d9,0|OAM_FLIP_H
	.byte 16,16,$e9,0
	.byte  7,16,$ec,0
	.byte $80


EWL_StreetSkate_Jump_2_data:


	.byte 16,32,$24,2
	.byte  8,32,$25,2
	.byte 16,24,$26,2
	.byte  8,24,$27,2

	.byte  8,17,$ec,0
	.byte 16,16,$e5,0
	.byte 17, 8,$e7,0
	.byte 16, 8,$fe,0

	.byte  8, 8,$ff,0
	.byte  8,16,$fd,0
	.byte $80


EWL_StreetSkate_Jump_1_data:


	.byte  8, 4,$d5,0
	.byte 16,21,$24,2
	.byte  8,21,$25,2
	.byte 16,13,$26,2

	.byte  8,13,$27,2
	.byte  7, 7,$ec,0
	.byte 16, 4,$dc,0|OAM_FLIP_H
	.byte 15, 7,$ed,0
	.byte $80


EWL_StreetSkate_GuyRunning_1_data:


	.byte 24,24,$81,1
	.byte 16,24,$84,1
	.byte  8,24,$85,1
	.byte 24,16,$83,1

	.byte 16,16,$86,1
	.byte  8,16,$87,1
	.byte 24, 8,$a1,1
	.byte 16, 8,$a4,1

	.byte  8, 8,$a5,1
	.byte $80


EWL_StreetSkate_GuyRunning_2_data:


	.byte 16,24,$8c,1
	.byte  8,24,$8d,1
	.byte 24,16,$8b,1
	.byte 16,16,$8e,1

	.byte  8,16,$8f,1
	.byte 24, 8,$a9,1
	.byte 16, 8,$ac,1
	.byte  8, 8,$ad,1

	.byte 16,  0,$ae,1
	.byte $80


EWL_StreetSkate_Coasting_4_data:


	.byte 16,24,$24,2
	.byte  8,24,$25,2
	.byte 16,16,$26,2
	.byte  8,16,$27,2

	.byte  8, 4,$dc,0
	.byte 16, 4,$d5,0|OAM_FLIP_H
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0

	.byte 16, 4,$cd,0
	.byte $80


EWL_StreetSkate_Coasting_3_data:


	.byte 16,24,$24,2
	.byte  8,24,$25,2
	.byte 16,16,$26,2
	.byte  8,16,$27,2

	.byte  8, 4,$d9,0
	.byte 16, 4,$d8,0|OAM_FLIP_H
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0

	.byte 16, 4,$cd,0
	.byte $80


EWL_StreetSkate_Coasting_2_data:


	.byte 16,24,$24,2
	.byte  8,24,$25,2
	.byte 16,16,$26,2
	.byte  8,16,$27,2

	.byte  8, 4,$d8,0
	.byte 16, 4,$d9,0|OAM_FLIP_H
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0
	.byte $80


EWL_StreetSkate_Coasting_1_data:


	.byte 16,24,$24,2
	.byte  8,24,$25,2
	.byte 16,16,$26,2
	.byte  8,16,$27,2

	.byte 16, 4,$dc,0|OAM_FLIP_H
	.byte  8, 4,$d5,0
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0
	.byte $80


EWL_StreetSkate_KickFlip_9_data:


	.byte 16,23,$24,2
	.byte  8,23,$25,2
	.byte 16,15,$26,2
	.byte  8,15,$27,2

	.byte  8, 7,$f1,0
	.byte  8, 4,$d8,0
	.byte 16, 4,$d9,0|OAM_FLIP_H
	.byte  7, 7,$ec,0

	.byte 15, 8,$ed,0
	.byte $80


EWL_StreetSkate_KickFlip_8_data:


	.byte 16,30,$24,2
	.byte  8,30,$25,2
	.byte 16,22,$26,2
	.byte  8,22,$27,2

	.byte 16,14,$e9,0
	.byte  7,15,$ec,0
	.byte  8, 8,$b5,0|OAM_FLIP_V
	.byte 16, 8,$b5,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_7_data:


	.byte 16,32,$24,2
	.byte  8,32,$25,2
	.byte 16,24,$26,2
	.byte  8,24,$27,2

	.byte 16,16,$e9,0
	.byte  8,16,$ed,0|OAM_FLIP_H
	.byte  8, 8,$9b,0
	.byte 16,10,$9b,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_6_data:


	.byte 16,32,$24,2
	.byte  8,32,$25,2
	.byte 16,24,$26,2
	.byte  8,24,$27,2

	.byte 16,16,$e9,0
	.byte  8,16,$ed,0|OAM_FLIP_H
	.byte  7, 9,$b5,0
	.byte 15, 9,$b5,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_5_data:


	.byte 16,32,$24,2
	.byte  8,32,$25,2
	.byte 16,24,$26,2
	.byte  8,24,$27,2

	.byte 16,16,$e9,0
	.byte  8,16,$ed,0|OAM_FLIP_H
	.byte  8,10,$97,0|OAM_FLIP_V
	.byte 16,10,$97,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_4_data:


	.byte 16,32,$24,2
	.byte  8,32,$25,2
	.byte 16,24,$26,2
	.byte  8,24,$27,2

	.byte 16,16,$e9,0
	.byte  8,16,$ed,0|OAM_FLIP_H
	.byte 15,10,$9a,0
	.byte  7,10,$9a,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_3_data:


	.byte 16,32,$24,2
	.byte  8,32,$25,2
	.byte 16,24,$26,2
	.byte  8,24,$27,2

	.byte 16,16,$e9,0
	.byte  8,16,$ed,0|OAM_FLIP_H
	.byte  7,12,$97,0
	.byte 15,12,$97,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_2_data:


	.byte 16,32,$24,2
	.byte  8,32,$25,2
	.byte 16,24,$26,2
	.byte  8,24,$27,2

	.byte  8,17,$ec,0
	.byte 16,16,$e5,0
	.byte 17, 8,$e7,0
	.byte 16, 8,$fe,0

	.byte  8, 8,$ff,0
	.byte  8,16,$fd,0
	.byte $80


EWL_StreetSkate_KickFlip_1_data:


	.byte 16,21,$24,2
	.byte  8,21,$25,2
	.byte 16,13,$26,2
	.byte  8,13,$27,2

	.byte  8, 4,$d5,0
	.byte  7, 7,$ec,0
	.byte 16, 4,$dc,0|OAM_FLIP_H
	.byte 15, 7,$ed,0
	.byte $80

















EWL_StreetSkate_pointers_chaser:
	.word EWL_StreetSkate_GuyRunning_2_data
	.word EWL_StreetSkate_GuyRunning_1_data




EWL_StreetSkate_pointers_kickflip:	
	.word EWL_StreetSkate_KickFlip_9_data
	.word EWL_StreetSkate_KickFlip_8_data
	.word EWL_StreetSkate_KickFlip_7_data
	.word EWL_StreetSkate_KickFlip_6_data
	.word EWL_StreetSkate_KickFlip_5_data
	.word EWL_StreetSkate_KickFlip_4_data
	.word EWL_StreetSkate_KickFlip_3_data
	.word EWL_StreetSkate_KickFlip_2_data
	.word EWL_StreetSkate_KickFlip_1_data





EWL_StreetSkate_pointers_walk:

	.word EWL_StreetSkate_Walk_1_data
	.word EWL_StreetSkate_Walk_2_data
	.word EWL_StreetSkate_Walk_3_data
	.word EWL_StreetSkate_Walk_4_data

	

EWL_StreetSkate_pointers_push:
	.word EWL_StreetSkate_Push_4_data
	.word EWL_StreetSkate_Push_3_data
	.word EWL_StreetSkate_Push_2_data
	.word EWL_StreetSkate_Push_1_data
	
	
	
    
	

EWL_StreetSkate_pointers_jump:
	.word EWL_StreetSkate_Jump_4_data
	.word EWL_StreetSkate_Jump_3_data
	.word EWL_StreetSkate_Jump_2_data
    .word EWL_StreetSkate_Jump_1_data
	
	
	



EWL_StreetSkate_pointers_coasting:
	.word EWL_StreetSkate_Coasting_4_data
	.word EWL_StreetSkate_Coasting_3_data
	.word EWL_StreetSkate_Coasting_2_data
	.word EWL_StreetSkate_Coasting_1_data
	

EWL_StreetSkate_pointers_idle:
	.word EWL_StreetSkate_Coasting_4_data
.endif