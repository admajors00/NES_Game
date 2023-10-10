.ifndef _FRAMES_INC
_FRAMES_INC = 1

OAM_FLIP_H = %01000000
OAM_FLIP_V = %10000000

EWL_StreetSkate_Walk_4_data:


	.byte   0,24,$04,2
	.byte   8,24,$05,2
	.byte   0,16,$06,2
	.byte   8,16,$07,2

	.byte   0, 8,$48,2
	.byte   8, 8,$5c,0
	.byte $80


EWL_StreetSkate_Walk_3_data:


	.byte   0,24,$04,2
	.byte   8,24,$05,2
	.byte   0,16,$06,2
	.byte   8,16,$07,2

	.byte   0, 8,$44,0
	.byte   8, 8,$45,0
	.byte $80


EWL_StreetSkate_Walk_2_data:


	.byte   0,24,$04,2
	.byte   8,24,$05,2
	.byte   0,16,$06,2
	.byte   8,16,$07,2

	.byte   0, 8,$40,0
	.byte   8, 8,$41,0
	.byte $80


EWL_StreetSkate_Walk_1_data:


	.byte   0,24,$04,2
	.byte   8,24,$05,2
	.byte   0,16,$06,2
	.byte   8,16,$07,2

	.byte   0, 8,$2e,0
	.byte   8, 8,$2f,0
	.byte $80


EWL_StreetSkate_Push_4_data:


	.byte   0,24,$04,2
	.byte   8,24,$04,2|OAM_FLIP_H
	.byte   0,16,$06,2
	.byte   8,16,$06,2|OAM_FLIP_H

	.byte   0, 8,$e0,0
	.byte   8, 8,$e1,0
	.byte   8, 4,$dc,0
	.byte   0, 4,$d5,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_Push_3_data:


	.byte   1,23,$08,2
	.byte   9,23,$09,2
	.byte   1,15,$0a,2
	.byte   9,15,$0b,2

	.byte   8, 8,$e1,0
	.byte   0, 9,$e8,0
	.byte   0, 4,$d8,0|OAM_FLIP_H
	.byte   8, 4,$d9,0
	.byte $80


EWL_StreetSkate_Push_2_data:


	.byte   1,23,$08,2
	.byte   9,23,$09,2
	.byte   1,15,$0a,2
	.byte   9,15,$0b,2

	.byte  1,  0,$ea,0
	.byte   8, 8,$e1,0
	.byte   2, 9,$e5,0
	.byte   0, 1,$e7,0

	.byte   0, 4,$d9,0|OAM_FLIP_H
	.byte   8, 4,$d8,0
	.byte $80


EWL_StreetSkate_Push_1_data:


	.byte   1,23,$08,2
	.byte   9,23,$09,2
	.byte   1,15,$0a,2
	.byte   9,15,$0b,2

	.byte   5, 8,$e4,0
	.byte   5,  0,$e6,0
	.byte   0, 4,$dc,0|OAM_FLIP_H
	.byte   8, 4,$d5,0
	.byte $80


EWL_StreetSkate_Jump_4_data:


	.byte   0,28,$04,2
	.byte   8,28,$04,2|OAM_FLIP_H
	.byte   0,20,$06,2
	.byte   8,20,$06,2|OAM_FLIP_H

	.byte   8,12,$f1,0
	.byte   8, 9,$d8,0
	.byte   0, 9,$d9,0|OAM_FLIP_H
	.byte   9,12,$ec,0

	.byte   1,13,$ed,0
	.byte $80


EWL_StreetSkate_Jump_3_data:


	.byte   0,32,$04,2
	.byte   8,32,$04,2|OAM_FLIP_H
	.byte   0,24,$06,2
	.byte   8,24,$06,2|OAM_FLIP_H

	.byte   8,13,$d8,0
	.byte   0,13,$d9,0|OAM_FLIP_H
	.byte   0,16,$e9,0
	.byte   9,16,$ec,0
	.byte $80


EWL_StreetSkate_Jump_2_data:


	.byte   0,32,$04,2
	.byte   8,32,$04,2|OAM_FLIP_H
	.byte   0,24,$06,2
	.byte   8,24,$06,2|OAM_FLIP_H

	.byte   8,17,$ec,0
	.byte   0,16,$e5,0
	.byte  1, 8,$e7,0
	.byte   0, 8,$fe,0

	.byte   8, 8,$ff,0
	.byte   8,16,$fd,0
	.byte $80


EWL_StreetSkate_Jump_1_data:


	.byte   8, 4,$d5,0
	.byte   0,21,$04,2
	.byte   8,21,$04,2|OAM_FLIP_H
	.byte   0,13,$06,2

	.byte   8,13,$06,2|OAM_FLIP_H
	.byte   9, 7,$ec,0
	.byte   0, 4,$dc,0|OAM_FLIP_H
	.byte   1, 7,$ed,0
	.byte $80


EWL_StreetSkate_Coasting_4_data:


	.byte   0,24,$04,2
	.byte   8,24,$04,2|OAM_FLIP_H
	.byte   0,16,$06,2
	.byte   8,16,$06,2|OAM_FLIP_H

	.byte   8, 4,$dc,0
	.byte   0, 4,$d5,0|OAM_FLIP_H
	.byte   0, 8,$e0,0
	.byte   8, 8,$e1,0

	.byte   0, 4,$cd,0
	.byte $80


EWL_StreetSkate_Coasting_3_data:


	.byte   0,24,$04,2
	.byte   8,24,$04,2|OAM_FLIP_H
	.byte   0,16,$06,2
	.byte   8,16,$06,2|OAM_FLIP_H

	.byte   8, 4,$d9,0
	.byte   0, 4,$d8,0|OAM_FLIP_H
	.byte   0, 8,$e0,0
	.byte   8, 8,$e1,0

	.byte   0, 4,$cd,0
	.byte $80


EWL_StreetSkate_Coasting_2_data:


	.byte   0,24,$04,2
	.byte   8,24,$04,2|OAM_FLIP_H
	.byte   0,16,$06,2
	.byte   8,16,$06,2|OAM_FLIP_H

	.byte   8, 4,$d8,0
	.byte   0, 4,$d9,0|OAM_FLIP_H
	.byte   0, 8,$e0,0
	.byte   8, 8,$e1,0
	.byte $80


EWL_StreetSkate_Coasting_1_data:


	.byte   0,24,$04,2
	.byte   8,24,$04,2|OAM_FLIP_H
	.byte   0,16,$06,2
	.byte   8,16,$06,2|OAM_FLIP_H

	.byte   0, 4,$dc,0|OAM_FLIP_H
	.byte   8, 4,$d5,0
	.byte   0, 8,$e0,0
	.byte   8, 8,$e1,0
	.byte $80


EWL_StreetSkate_KickFlip_9_data:


	.byte   0,23,$04,2
	.byte   8,23,$05,2
	.byte   0,15,$06,2
	.byte   8,15,$07,2

	.byte   8, 7,$f1,0
	.byte   8, 4,$d8,0
	.byte   0, 4,$d9,0|OAM_FLIP_H
	.byte   9, 7,$ec,0

	.byte   1, 8,$ed,0
	.byte $80


EWL_StreetSkate_KickFlip_8_data:


	.byte   0,30,$04,2
	.byte   8,30,$05,2
	.byte   0,22,$06,2
	.byte   8,22,$07,2

	.byte   0,14,$e9,0
	.byte   9,15,$ec,0
	.byte   8, 8,$b5,0|OAM_FLIP_V
	.byte   0, 8,$b5,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_7_data:


	.byte   0,32,$04,2
	.byte   8,32,$05,2
	.byte   0,24,$06,2
	.byte   8,24,$07,2

	.byte   0,16,$e9,0
	.byte   8,16,$ed,0|OAM_FLIP_H
	.byte   8, 8,$9b,0
	.byte   0,10,$9b,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_6_data:


	.byte   0,32,$04,2
	.byte   8,32,$05,2
	.byte   0,24,$06,2
	.byte   8,24,$07,2

	.byte   0,16,$e9,0
	.byte   8,16,$ed,0|OAM_FLIP_H
	.byte   9, 9,$b5,0
	.byte   1, 9,$b5,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_5_data:


	.byte   0,32,$04,2
	.byte   8,32,$05,2
	.byte   0,24,$06,2
	.byte   8,24,$07,2

	.byte   0,16,$e9,0
	.byte   8,16,$ed,0|OAM_FLIP_H
	.byte   8,10,$97,0|OAM_FLIP_V
	.byte   0,10,$97,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_4_data:


	.byte   0,32,$04,2
	.byte   8,32,$05,2
	.byte   0,24,$06,2
	.byte   8,24,$07,2

	.byte   0,16,$e9,0
	.byte   8,16,$ed,0|OAM_FLIP_H
	.byte   1,10,$9a,0
	.byte   9,10,$9a,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_3_data:


	.byte   0,32,$04,2
	.byte   8,32,$05,2
	.byte   0,24,$06,2
	.byte   8,24,$07,2

	.byte   0,16,$e9,0
	.byte   8,16,$ed,0|OAM_FLIP_H
	.byte   9,12,$97,0
	.byte   1,12,$97,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_2_data:


	.byte   0,32,$04,2
	.byte   8,32,$05,2
	.byte   0,24,$06,2
	.byte   8,24,$07,2

	.byte   8,17,$ec,0
	.byte   0,16,$e5,0
	.byte  1, 8,$e7,0
	.byte   0, 8,$fe,0

	.byte   8, 8,$ff,0
	.byte   8,16,$fd,0
	.byte $80


EWL_StreetSkate_KickFlip_1_data:


	.byte   0,21,$04,2
	.byte   8,21,$05,2
	.byte   0,13,$06,2
	.byte   8,13,$07,2

	.byte   8, 4,$d5,0
	.byte   9, 7,$ec,0
	.byte   0, 4,$dc,0|OAM_FLIP_H
	.byte   1, 7,$ed,0
	.byte $80


EWL_StreetSkate_GuyRunning_3_data:


	.byte   6,30,$1c,1
	.byte 10,22,$1a,1
	.byte  2,22,$1b,1
	.byte   6,22,$1e,1

	.byte  14,22,$1f,1
	.byte 10,14,$38,1
	.byte  2,14,$39,1
	.byte   6,14,$3c,1

	.byte   4, 6,$3e,1
	.byte  2,30,$19,1
	.byte $80


EWL_StreetSkate_GuyRunning_2_data:


	.byte  1,30,$02,1
	.byte   7,30,$8d,1
	.byte  9,22,$8b,1
	.byte  1,22,$8e,1

	.byte   7,22,$8f,1
	.byte  9,14,$a9,1
	.byte  1,14,$ac,1
	.byte   7,14,$ad,1

	.byte  4, 6,$ae,1
	.byte  9, 6,$ab,1
	.byte $80


EWL_StreetSkate_GuyRunning_1_data:


	.byte  8,30,$81,1
	.byte   0,30,$84,1
	.byte   8,30,$85,1
	.byte  8,22,$83,1

	.byte   0,22,$86,1
	.byte   8,22,$87,1
	.byte  8,14,$a1,1
	.byte   0,14,$a4,1

	.byte   8,14,$a5,1
	.byte  16,22,$8a,1
	.byte   0, 6,$a6,1
	.byte   8, 6,$a7,1
	.byte $80


EWL_StreetSkate_Cone_1_data:


	.byte   5,16,$60,0
	.byte   0, 8,$62,0
	.byte   8, 8,$63,0
	.byte $80


EWL_StreetSkate_LoadUp_4_data:


	.byte   8, 4,$dc,0
	.byte   0, 4,$d5,0|OAM_FLIP_H
	.byte   0,21,$04,2
	.byte   8,21,$05,2

	.byte   0,13,$06,2
	.byte   8,13,$07,2
	.byte   9, 7,$ec,0
	.byte   1, 7,$ed,0
	.byte $80


EWL_StreetSkate_LoadUp_3_data:


	.byte   8, 4,$d9,0
	.byte   0, 4,$d8,0|OAM_FLIP_H
	.byte   0,21,$04,2
	.byte   8,21,$05,2

	.byte   0,13,$06,2
	.byte   8,13,$07,2
	.byte   9, 7,$ec,0
	.byte   1, 7,$ed,0
	.byte $80


EWL_StreetSkate_LoadUp_2_data:


	.byte   8, 4,$d5,0
	.byte   0, 4,$dc,0|OAM_FLIP_H
	.byte   0,21,$04,2
	.byte   8,21,$05,2

	.byte   0,13,$06,2
	.byte   8,13,$07,2
	.byte   9, 7,$ec,0
	.byte   1, 7,$ed,0
	.byte $80


EWL_StreetSkate_LoadUp_1_data:


	.byte   8, 4,$d8,0
	.byte   0, 4,$d9,0|OAM_FLIP_H
	.byte   0,21,$04,2
	.byte   8,21,$05,2

	.byte   0,13,$06,2
	.byte   8,13,$07,2
	.byte   9, 7,$ec,0
	.byte   1, 7,$ed,0
	.byte $80


EWL_StreetSkate_Crash_4_data:





	.byte   8, 4,$d4,0
	.byte   0, 4,$d4,0|OAM_FLIP_H
	.byte  42,  0,$ed,0|OAM_FLIP_H
	.byte  30, 2,$e8,0

	.byte  54,16,$21,2
	.byte  46,16,$20,2
	.byte  54, 8,$23,2
	.byte  46, 8,$22,2

	.byte  62, 8,$2e,0
	.byte  54, 8,$2b,0
	.byte  46, 8,$2a,0
	.byte  38, 8,$27,0

	.byte $80










EWL_StreetSkate_Crash_3_data:


	.byte  41,17,$10,2
	.byte  49,17,$11,2
	.byte  41, 9,$12,2
	.byte  49, 9,$13,2

	.byte  34, 7,$e8,0
	.byte  34,13,$ed,0
	.byte   8, 4,$d4,0
	.byte   0, 4,$d4,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_Crash_2_data:


	.byte  32,23,$10,2
	.byte  40,23,$11,2
	.byte  32,15,$12,2
	.byte  40,15,$13,2

	.byte  25,13,$e8,0
	.byte  25,19,$ed,0
	.byte   8, 4,$d4,0
	.byte   0, 4,$d4,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_Crash_1_data:


	.byte  15,24,$08,2
	.byte  23,24,$09,2
	.byte  15,16,$0a,2
	.byte  23,16,$0b,2

	.byte  12,10,$e5,0
	.byte   8,14,$e8,0
	.byte  12, 2,$e7,0
	.byte  1,10,$f9,0|OAM_FLIP_H

	.byte  1, 2,$fb,0|OAM_FLIP_H
	.byte   6,10,$f8,0|OAM_FLIP_H
	.byte   7, 2,$fa,0|OAM_FLIP_H
	.byte $80


; EWL_StreetSkate_pointers:

; 	.word EWL_StreetSkate_Walk_4_data
; 	.word EWL_StreetSkate_Walk_3_data
; 	.word EWL_StreetSkate_Walk_2_data
; 	.word EWL_StreetSkate_Walk_1_data
; 	.word EWL_StreetSkate_Push_4_data
; 	.word EWL_StreetSkate_Push_3_data
; 	.word EWL_StreetSkate_Push_2_data
; 	.word EWL_StreetSkate_Push_1_data
; 	.word EWL_StreetSkate_Jump_4_data
; 	.word EWL_StreetSkate_Jump_3_data
; 	.word EWL_StreetSkate_Jump_2_data
; 	.word EWL_StreetSkate_Jump_1_data
; 	.word EWL_StreetSkate_Coasting_4_data
; 	.word EWL_StreetSkate_Coasting_3_data
; 	.word EWL_StreetSkate_Coasting_2_data
; 	.word EWL_StreetSkate_Coasting_1_data
; 	.word EWL_StreetSkate_KickFlip_9_data
; 	.word EWL_StreetSkate_KickFlip_8_data
; 	.word EWL_StreetSkate_KickFlip_7_data
; 	.word EWL_StreetSkate_KickFlip_6_data
; 	.word EWL_StreetSkate_KickFlip_5_data
; 	.word EWL_StreetSkate_KickFlip_4_data
; 	.word EWL_StreetSkate_KickFlip_3_data
; 	.word EWL_StreetSkate_KickFlip_2_data
; 	.word EWL_StreetSkate_KickFlip_1_data
; 	.word EWL_StreetSkate_GuyRunning_3_data
; 	.word EWL_StreetSkate_GuyRunning_2_data
; 	.word EWL_StreetSkate_GuyRunning_1_data
; 	.word EWL_StreetSkate_Cone_1_data
; 	.word EWL_StreetSkate_LoadUp _4_data
; 	.word EWL_StreetSkate_LoadUp _3_data
; 	.word EWL_StreetSkate_LoadUp _2_data
; 	.word EWL_StreetSkate_LoadUp _1_data
; 	.word EWL_StreetSkate_Crash_4_data
; 	.word EWL_StreetSkate_Crash_3_data
; 	.word EWL_StreetSkate_Crash_2_data
; 	.word EWL_StreetSkate_Crash_1_data




EWL_StreetSkate_pointers_cone:
	.word EWL_StreetSkate_Cone_1_data
	.word EWL_StreetSkate_Cone_1_data

Pothole_1:


	.byte 16,16,$71,2
	.byte  8,16,$74,2
	.byte 16, 8,$73,2
	.byte  8, 8,$76,2

	.byte $80

EWL_StreetSkate_pointers_pothole:
	.word Pothole_1
	.word Pothole_1





EWL_StreetSkate_pointers_chaser:
	.word EWL_StreetSkate_GuyRunning_2_data
	.word EWL_StreetSkate_GuyRunning_3_data
	.word EWL_StreetSkate_GuyRunning_2_data
	.word EWL_StreetSkate_GuyRunning_1_data

EWL_StreetSkate_pointers_loadUp:
	.word EWL_StreetSkate_LoadUp_4_data
	.word EWL_StreetSkate_LoadUp_3_data
	.word EWL_StreetSkate_LoadUp_2_data
	.word EWL_StreetSkate_LoadUp_1_data
	
	
	
EWL_StreetSkate_pointers_Crash:
	.word EWL_StreetSkate_Crash_4_data
	.word EWL_StreetSkate_Crash_3_data
	.word EWL_StreetSkate_Crash_2_data
	.word EWL_StreetSkate_Crash_1_data


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





; EWL_StreetSkate_pointers_walk:

; 	.word EWL_StreetSkate_Walk_1_data
; 	.word EWL_StreetSkate_Walk_2_data
; 	.word EWL_StreetSkate_Walk_3_data
; 	.word EWL_StreetSkate_Walk_4_data

	

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