.ifndef _FRAMES_INC
_FRAMES_INC = 1

OAM_FLIP_H = %01000000
OAM_FLIP_V = %10000000

EWL_StreetSkate_Walk_4_data:


	.byte 16,24,$04,2
	.byte  8,24,$05,2
	.byte 16,16,$06,2
	.byte  8,16,$07,2

	.byte 16, 8,$48,2
	.byte  8, 8,$5c,0
	.byte $80


EWL_StreetSkate_Walk_3_data:


	.byte 16,24,$04,2
	.byte  8,24,$05,2
	.byte 16,16,$06,2
	.byte  8,16,$07,2

	.byte 16, 8,$44,0
	.byte  8, 8,$45,0
	.byte $80


EWL_StreetSkate_Walk_2_data:


	.byte 16,24,$04,2
	.byte  8,24,$05,2
	.byte 16,16,$06,2
	.byte  8,16,$07,2

	.byte 16, 8,$40,0
	.byte  8, 8,$41,0
	.byte $80


EWL_StreetSkate_Walk_1_data:


	.byte 16,24,$04,2
	.byte  8,24,$05,2
	.byte 16,16,$06,2
	.byte  8,16,$07,2

	.byte 16, 8,$2e,0
	.byte  8, 8,$2f,0
	.byte $80


EWL_StreetSkate_Push_4_data:


	.byte 16,24,$04,2
	.byte  8,24,$05,2
	.byte 16,16,$06,2
	.byte  8,16,$07,2

	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0
	.byte  8, 4,$dc,0
	.byte 16, 4,$d5,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_Push_3_data:


	.byte 15,23,$08,2
	.byte  7,23,$09,2
	.byte 15,15,$0a,2
	.byte  7,15,$0b,2

	.byte  8, 8,$e1,0
	.byte 16, 9,$e8,0
	.byte 16, 4,$d8,0|OAM_FLIP_H
	.byte  8, 4,$d9,0
	.byte $80


EWL_StreetSkate_Push_2_data:


	.byte 15,23,$08,2
	.byte  7,23,$09,2
	.byte 15,15,$0a,2
	.byte  7,15,$0b,2

	.byte 17,  0,$ea,0
	.byte  8, 8,$e1,0
	.byte 14, 9,$e5,0
	.byte 16, 1,$e7,0

	.byte 16, 4,$d9,0|OAM_FLIP_H
	.byte  8, 4,$d8,0
	.byte $80


EWL_StreetSkate_Push_1_data:


	.byte 15,23,$08,2
	.byte  7,23,$09,2
	.byte 15,15,$0a,2
	.byte  7,15,$0b,2

	.byte 11, 8,$e4,0
	.byte 11,  0,$e6,0
	.byte 16, 4,$dc,0|OAM_FLIP_H
	.byte  8, 4,$d5,0
	.byte $80


EWL_StreetSkate_Jump_4_data:


	.byte 16,28,$04,2
	.byte  8,28,$05,2
	.byte 16,20,$06,2
	.byte  8,20,$07,2

	.byte  8,12,$f1,0
	.byte  8, 9,$d8,0
	.byte 16, 9,$d9,0|OAM_FLIP_H
	.byte  7,12,$ec,0

	.byte 15,13,$ed,0
	.byte $80


EWL_StreetSkate_Jump_3_data:


	.byte 16,32,$04,2
	.byte  8,32,$05,2
	.byte 16,24,$06,2
	.byte  8,24,$07,2

	.byte  8,13,$d8,0
	.byte 16,13,$d9,0|OAM_FLIP_H
	.byte 16,16,$e9,0
	.byte  7,16,$ec,0
	.byte $80


EWL_StreetSkate_Jump_2_data:


	.byte 16,32,$04,2
	.byte  8,32,$05,2
	.byte 16,24,$06,2
	.byte  8,24,$07,2

	.byte  8,17,$ec,0
	.byte 16,16,$e5,0
	.byte 17, 8,$e7,0
	.byte 16, 8,$fe,0

	.byte  8, 8,$ff,0
	.byte  8,16,$fd,0
	.byte $80


EWL_StreetSkate_Jump_1_data:


	.byte  8, 4,$d5,0
	.byte 16,21,$04,2
	.byte  8,21,$05,2
	.byte 16,13,$06,2

	.byte  8,13,$07,2
	.byte  7, 7,$ec,0
	.byte 16, 4,$dc,0|OAM_FLIP_H
	.byte 15, 7,$ed,0
	.byte $80


EWL_StreetSkate_Coasting_4_data:


	.byte 16,24,$04,2
	.byte  8,24,$05,2
	.byte 16,16,$06,2
	.byte  8,16,$07,2

	.byte  8, 4,$dc,0
	.byte 16, 4,$d5,0|OAM_FLIP_H
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0

	.byte 16, 4,$cd,0
	.byte $80


EWL_StreetSkate_Coasting_3_data:


	.byte 16,24,$04,2
	.byte  8,24,$05,2
	.byte 16,16,$06,2
	.byte  8,16,$07,2

	.byte  8, 4,$d9,0
	.byte 16, 4,$d8,0|OAM_FLIP_H
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0

	.byte 16, 4,$cd,0
	.byte $80


EWL_StreetSkate_Coasting_2_data:


	.byte 16,24,$04,2
	.byte  8,24,$05,2
	.byte 16,16,$06,2
	.byte  8,16,$07,2

	.byte  8, 4,$d8,0
	.byte 16, 4,$d9,0|OAM_FLIP_H
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0
	.byte $80


EWL_StreetSkate_Coasting_1_data:


	.byte 16,24,$04,2
	.byte  8,24,$05,2
	.byte 16,16,$06,2
	.byte  8,16,$07,2

	.byte 16, 4,$dc,0|OAM_FLIP_H
	.byte  8, 4,$d5,0
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0
	.byte $80


EWL_StreetSkate_KickFlip_9_data:


	.byte 16,23,$04,2
	.byte  8,23,$05,2
	.byte 16,15,$06,2
	.byte  8,15,$07,2

	.byte  8, 7,$f1,0
	.byte  8, 4,$d8,0
	.byte 16, 4,$d9,0|OAM_FLIP_H
	.byte  7, 7,$ec,0

	.byte 15, 8,$ed,0
	.byte $80


EWL_StreetSkate_KickFlip_8_data:


	.byte 16,30,$04,2
	.byte  8,30,$05,2
	.byte 16,22,$06,2
	.byte  8,22,$07,2

	.byte 16,14,$e9,0
	.byte  7,15,$ec,0
	.byte  8, 8,$b5,0|OAM_FLIP_V
	.byte 16, 8,$b5,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_7_data:


	.byte 16,32,$04,2
	.byte  8,32,$05,2
	.byte 16,24,$06,2
	.byte  8,24,$07,2

	.byte 16,16,$e9,0
	.byte  8,16,$ed,0|OAM_FLIP_H
	.byte  8, 8,$9b,0
	.byte 16,10,$9b,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_6_data:


	.byte 16,32,$04,2
	.byte  8,32,$05,2
	.byte 16,24,$06,2
	.byte  8,24,$07,2

	.byte 16,16,$e9,0
	.byte  8,16,$ed,0|OAM_FLIP_H
	.byte  7, 9,$b5,0
	.byte 15, 9,$b5,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_5_data:


	.byte 16,32,$04,2
	.byte  8,32,$05,2
	.byte 16,24,$06,2
	.byte  8,24,$07,2

	.byte 16,16,$e9,0
	.byte  8,16,$ed,0|OAM_FLIP_H
	.byte  8,10,$97,0|OAM_FLIP_V
	.byte 16,10,$97,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_4_data:


	.byte 16,32,$04,2
	.byte  8,32,$05,2
	.byte 16,24,$06,2
	.byte  8,24,$07,2

	.byte 16,16,$e9,0
	.byte  8,16,$ed,0|OAM_FLIP_H
	.byte 15,10,$9a,0
	.byte  7,10,$9a,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_3_data:


	.byte 16,32,$04,2
	.byte  8,32,$05,2
	.byte 16,24,$06,2
	.byte  8,24,$07,2

	.byte 16,16,$e9,0
	.byte  8,16,$ed,0|OAM_FLIP_H
	.byte  7,12,$97,0
	.byte 15,12,$97,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_2_data:


	.byte 16,32,$04,2
	.byte  8,32,$05,2
	.byte 16,24,$06,2
	.byte  8,24,$07,2

	.byte  8,17,$ec,0
	.byte 16,16,$e5,0
	.byte 17, 8,$e7,0
	.byte 16, 8,$fe,0

	.byte  8, 8,$ff,0
	.byte  8,16,$fd,0
	.byte $80


EWL_StreetSkate_KickFlip_1_data:


	.byte 16,21,$04,2
	.byte  8,21,$05,2
	.byte 16,13,$06,2
	.byte  8,13,$07,2

	.byte  8, 4,$d5,0
	.byte  7, 7,$ec,0
	.byte 16, 4,$dc,0|OAM_FLIP_H
	.byte 15, 7,$ed,0
	.byte $80


EWL_StreetSkate_GuyRunning_3_data:


	.byte 10,30,$1c,1
	.byte 26,22,$1a,1
	.byte 18,22,$1b,1
	.byte 10,22,$1e,1

	.byte  2,22,$1f,1
	.byte 26,14,$38,1
	.byte 18,14,$39,1
	.byte 10,14,$3c,1

	.byte 26, 6,$3a,1
	.byte 18, 6,$3b,1
	.byte 10, 6,$3e,1
	.byte 18,30,$19,1
	.byte $80


EWL_StreetSkate_GuyRunning_2_data:


	.byte 17,30,$8c,1
	.byte  9,30,$8d,1
	.byte 25,22,$8b,1
	.byte 17,22,$8e,1

	.byte  9,22,$8f,1
	.byte 25,14,$a9,1
	.byte 17,14,$ac,1
	.byte  9,14,$ad,1

	.byte 17, 6,$ae,1
	.byte 25, 6,$ab,1
	.byte $80


EWL_StreetSkate_GuyRunning_1_data:


	.byte 24,30,$81,1
	.byte 16,30,$84,1
	.byte  8,30,$85,1
	.byte 24,22,$83,1

	.byte 16,22,$86,1
	.byte  8,22,$87,1
	.byte 24,14,$a1,1
	.byte 16,14,$a4,1

	.byte  8,14,$a5,1
	.byte   0,22,$8a,1
	.byte 16, 6,$a6,1
	.byte  8, 6,$a7,1
	.byte $80


EWL_StreetSkate_pointers:

	.word EWL_StreetSkate_Walk_4_data
	.word EWL_StreetSkate_Walk_3_data
	.word EWL_StreetSkate_Walk_2_data
	.word EWL_StreetSkate_Walk_1_data
	.word EWL_StreetSkate_Push_4_data
	.word EWL_StreetSkate_Push_3_data
	.word EWL_StreetSkate_Push_2_data
	.word EWL_StreetSkate_Push_1_data
	.word EWL_StreetSkate_Jump_4_data
	.word EWL_StreetSkate_Jump_3_data
	.word EWL_StreetSkate_Jump_2_data
	.word EWL_StreetSkate_Jump_1_data
	.word EWL_StreetSkate_Coasting_4_data
	.word EWL_StreetSkate_Coasting_3_data
	.word EWL_StreetSkate_Coasting_2_data
	.word EWL_StreetSkate_Coasting_1_data
	.word EWL_StreetSkate_KickFlip_9_data
	.word EWL_StreetSkate_KickFlip_8_data
	.word EWL_StreetSkate_KickFlip_7_data
	.word EWL_StreetSkate_KickFlip_6_data
	.word EWL_StreetSkate_KickFlip_5_data
	.word EWL_StreetSkate_KickFlip_4_data
	.word EWL_StreetSkate_KickFlip_3_data
	.word EWL_StreetSkate_KickFlip_2_data
	.word EWL_StreetSkate_KickFlip_1_data
	.word EWL_StreetSkate_GuyRunning_3_data
	.word EWL_StreetSkate_GuyRunning_2_data
	.word EWL_StreetSkate_GuyRunning_1_data




















EWL_StreetSkate_pointers_chaser:
	.word EWL_StreetSkate_GuyRunning_2_data
	.word EWL_StreetSkate_GuyRunning_3_data
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
	.word EWL_StreetSkate_Coasting_1_data
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