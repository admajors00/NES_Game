.ifndef _FRAMES_INC
_FRAMES_INC = 1
;.feature force_range
OAM_FLIP_H = %01000000
OAM_FLIP_V = %10000000




EWL_StreetSkate_Push_4_data:


	.byte <-16,<-24,$01,2
	.byte <- 8,<-24,$01,2|OAM_FLIP_H
	.byte <-16,<-16,$03,2
	.byte <- 8,<-16,$03,2|OAM_FLIP_H

	.byte <-16,<- 8,$e0,0
	.byte <- 8,<- 8,$e1,0
	.byte <- 8,<- 4,$dc,0
	.byte <-16,<- 4,$d5,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_Push_3_data:


	.byte <-15,<-23,$04,2
	.byte <- 7,<-23,$05,2
	.byte <-15,<-15,$06,2
	.byte <- 7,<-15,$07,2

	.byte <- 8,<- 8,$e1,0
	.byte <-16,<- 9,$e8,0
	.byte <-16,<- 4,$d8,0|OAM_FLIP_H
	.byte <- 8,<- 4,$d9,0
	.byte $80


EWL_StreetSkate_Push_2_data:


	.byte <-15,<-23,$04,2
	.byte <- 7,<-23,$05,2
	.byte <-15,<-15,$06,2
	.byte <- 7,<-15,$07,2

	.byte <-17,  0,$ea,0
	.byte <- 8,<- 8,$e1,0
	.byte <-14,<- 9,$e5,0
	.byte <-16,<- 1,$e7,0

	.byte <-16,<- 4,$d9,0|OAM_FLIP_H
	.byte <- 8,<- 4,$d8,0
	.byte $80


EWL_StreetSkate_Push_1_data:


	.byte <-15,<-23,$04,2
	.byte <- 7,<-23,$05,2
	.byte <-15,<-15,$06,2
	.byte <- 7,<-15,$07,2

	.byte <-11,<- 8,$e4,0
	.byte <-11,  0,$e6,0
	.byte <-16,<- 4,$dc,0|OAM_FLIP_H
	.byte <- 8,<- 4,$d5,0
	.byte $80


EWL_StreetSkate_Jump_4_data:


	.byte <-16,<-25,$01,2
	.byte <- 8,<-25,$01,2|OAM_FLIP_H
	.byte <-16,<-17,$03,2
	.byte <- 8,<-17,$03,2|OAM_FLIP_H

	.byte <- 8,<- 6,$d8,0
	.byte <-16,<- 6,$d9,0|OAM_FLIP_H
	.byte <- 7,<- 9,$ec,0
	.byte <-15,<-10,$ed,0
	.byte $80


EWL_StreetSkate_Jump_3_data:


	.byte <- 8,<- 6,$d5,0
	.byte <-16,<-23,$01,2
	.byte <- 8,<-23,$01,2|OAM_FLIP_H
	.byte <-16,<-15,$03,2

	.byte <- 8,<-15,$03,2|OAM_FLIP_H
	.byte <- 7,<- 9,$ec,0
	.byte <-16,<- 6,$dc,0|OAM_FLIP_H
	.byte <-15,<- 9,$ed,0
	.byte $80


EWL_StreetSkate_Jump_2_data:


	.byte <-16,<-28,$01,2
	.byte <- 8,<-28,$01,2|OAM_FLIP_H
	.byte <-16,<-20,$03,2
	.byte <- 8,<-20,$03,2|OAM_FLIP_H

	.byte <-16,<-12,$e9,0
	.byte <- 7,<-12,$ec,0
	.byte <- 8,<- 7,$d8,0
	.byte <-16,<- 7,$d9,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_Jump_1_data:


	.byte <-16,<-30,$01,2
	.byte <- 8,<-30,$01,2|OAM_FLIP_H
	.byte <-16,<-22,$03,2
	.byte <- 8,<-22,$03,2|OAM_FLIP_H

	.byte <- 8,<-15,$ec,0
	.byte <-16,<-14,$e5,0
	.byte <-17,<- 6,$e7,0
	.byte <-16,<- 6,$fa,0

	.byte <- 8,<-12,$f9,0
	.byte $80


EWL_StreetSkate_Coasting_4_data:


	.byte <-16,<-24,$01,2
	.byte <- 8,<-24,$01,2|OAM_FLIP_H
	.byte <-16,<-16,$03,2
	.byte <- 8,<-16,$03,2|OAM_FLIP_H

	.byte <- 8,<- 4,$dc,0
	.byte <-16,<- 4,$d5,0|OAM_FLIP_H
	.byte <-16,<- 8,$e0,0
	.byte <- 8,<- 8,$e1,0
	.byte $80


EWL_StreetSkate_Coasting_3_data:


	.byte <-16,<-24,$01,2
	.byte <- 8,<-24,$01,2|OAM_FLIP_H
	.byte <-16,<-16,$03,2
	.byte <- 8,<-16,$03,2|OAM_FLIP_H

	.byte <- 8,<- 4,$d9,0
	.byte <-16,<- 4,$d8,0|OAM_FLIP_H
	.byte <-16,<- 8,$e0,0
	.byte <- 8,<- 8,$e1,0
	.byte $80


EWL_StreetSkate_Coasting_2_data:


	.byte <-16,<-24,$01,2
	.byte <- 8,<-24,$01,2|OAM_FLIP_H
	.byte <-16,<-16,$03,2
	.byte <- 8,<-16,$03,2|OAM_FLIP_H

	.byte <- 8,<- 4,$d8,0
	.byte <-16,<- 4,$d9,0|OAM_FLIP_H
	.byte <-16,<- 8,$e0,0
	.byte <- 8,<- 8,$e1,0
	.byte $80


EWL_StreetSkate_Coasting_1_data:


	.byte <-16,<-24,$01,2
	.byte <- 8,<-24,$01,2|OAM_FLIP_H
	.byte <-16,<-16,$03,2
	.byte <- 8,<-16,$03,2|OAM_FLIP_H

	.byte <-16,<- 4,$dc,0|OAM_FLIP_H
	.byte <- 8,<- 4,$d5,0
	.byte <-16,<- 8,$e0,0
	.byte <- 8,<- 8,$e1,0
	.byte $80


EWL_StreetSkate_KickFlip_9_data:


	.byte <-16,<-23,$01,2
	.byte <- 8,<-23,$01,2|OAM_FLIP_H
	.byte <-16,<-15,$03,2
	.byte <- 8,<-15,$03,2|OAM_FLIP_H

	.byte <- 8,<- 4,$d8,0
	.byte <-16,<- 4,$d9,0|OAM_FLIP_H
	.byte <- 7,<- 7,$ec,0
	.byte <-15,<- 8,$ed,0
	.byte $80


EWL_StreetSkate_KickFlip_8_data:


	.byte <-16,<-21,$01,2
	.byte <- 8,<-21,$01,2|OAM_FLIP_H
	.byte <-16,<-13,$03,2
	.byte <- 8,<-13,$03,2|OAM_FLIP_H

	.byte <- 8,<- 4,$d5,0
	.byte <- 7,<- 7,$ec,0
	.byte <-16,<- 4,$dc,0|OAM_FLIP_H
	.byte <-15,<- 7,$ed,0
	.byte $80


EWL_StreetSkate_KickFlip_7_data:


	.byte <-16,<-26,$01,2
	.byte <- 8,<-26,$01,2|OAM_FLIP_H
	.byte <-16,<-18,$03,2
	.byte <- 8,<-18,$03,2|OAM_FLIP_H

	.byte <-16,<-10,$e9,0
	.byte <- 7,<-11,$ec,0
	.byte <- 8,<- 6,$b5,0|OAM_FLIP_V
	.byte <-16,<- 6,$b5,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_6_data:


	.byte <-16,<-29,$01,2
	.byte <- 8,<-29,$01,2|OAM_FLIP_H
	.byte <-16,<-21,$03,2
	.byte <- 8,<-21,$03,2|OAM_FLIP_H

	.byte <-16,<-13,$e9,0
	.byte <- 8,<-13,$ed,0|OAM_FLIP_H
	.byte <- 8,<- 7,$9b,0
	.byte <-16,<- 9,$9b,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_5_data:


	.byte <-16,<-30,$01,2
	.byte <- 8,<-30,$01,2|OAM_FLIP_H
	.byte <-16,<-22,$03,2
	.byte <- 8,<-22,$03,2|OAM_FLIP_H

	.byte <-16,<-14,$e9,0
	.byte <- 8,<-14,$ed,0|OAM_FLIP_H
	.byte <- 8,<- 8,$b5,0
	.byte <-16,<- 8,$b5,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_4_data:


	.byte <-16,<-31,$01,2
	.byte <- 8,<-31,$01,2|OAM_FLIP_H
	.byte <-16,<-23,$03,2
	.byte <- 8,<-23,$03,2|OAM_FLIP_H

	.byte <-16,<-15,$e9,0
	.byte <- 8,<-15,$ed,0|OAM_FLIP_H
	.byte <- 8,<- 9,$97,0|OAM_FLIP_V
	.byte <-16,<- 9,$97,0|OAM_FLIP_H|OAM_FLIP_V
	.byte $80


EWL_StreetSkate_KickFlip_3_data:


	.byte <-16,<-32,$01,2
	.byte <- 8,<-32,$01,2|OAM_FLIP_H
	.byte <-16,<-24,$03,2
	.byte <- 8,<-24,$03,2|OAM_FLIP_H

	.byte <-16,<-16,$e9,0
	.byte <- 8,<-16,$ed,0|OAM_FLIP_H
	.byte <-16,<- 9,$9a,0
	.byte <- 8,<- 9,$9a,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_2_data:


	.byte <-16,<-33,$01,2
	.byte <- 8,<-33,$01,2|OAM_FLIP_H
	.byte <-16,<-25,$03,2
	.byte <- 8,<-25,$03,2|OAM_FLIP_H

	.byte <-16,<-17,$e9,0
	.byte <- 8,<-17,$ed,0|OAM_FLIP_H
	.byte <- 8,<-10,$97,0
	.byte <-16,<-10,$97,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_KickFlip_1_data:


	.byte <-16,<-29,$01,2
	.byte <- 8,<-29,$01,2|OAM_FLIP_H
	.byte <-16,<-21,$03,2
	.byte <- 8,<-21,$03,2|OAM_FLIP_H

	.byte <- 8,<-14,$ec,0
	.byte <-16,<-13,$e5,0
	.byte <-17,<- 5,$e7,0
	.byte <-14,<- 4,$fe,0

	.byte <- 8,<-12,$fd,0
	.byte $80


EWL_StreetSkate_GuyRunning_3_data:


	.byte <- 8,<-30,$84,1
	.byte <-16,<-22,$92,1
	.byte <-16,<-30,$90,1
	.byte <- 8,<-22,$93,1

	.byte <-16,<-14,$b0,1
	.byte <-24,<-14,$ad,1
	.byte <- 8,<-13,$b1,1
	.byte <-10,<- 5,$b3,1
	.byte $80


EWL_StreetSkate_GuyRunning_2_data:


	.byte <- 8,<-22,$8e,1
	.byte <-16,<-22,$8b,1
	.byte <-16,<-30,$89,1
	.byte <-16,<-14,$a9,1

	.byte <-24,<-14,$a8,1
	.byte <-19,<- 6,$ab,1
	.byte <- 8,<-30,$84,1
	.byte $80


EWL_StreetSkate_GuyRunning_1_data:


	.byte <- 8,<-30,$84,1
	.byte <-16,<-30,$81,1
	.byte <- 8,<-22,$86,1
	.byte <-16,<-22,$83,1

	.byte <-24,<-22,$82,1
	.byte <-24,<-14,$a0,1
	.byte <-16,<-14,$a1,1
	.byte <- 8,<-14,$a4,1

	.byte <- 8,<- 6,$a6,1
	.byte $80


EWL_StreetSkate_Cone_1_data:


	.byte <-11,<-16,$60,0
	.byte <-16,<- 8,$62,0
	.byte <- 8,<- 8,$63,0
	.byte $80


EWL_StreetSkate_LoadUp_4_data:


	.byte <- 8,<- 4,$dc,0
	.byte <-16,<- 4,$d5,0|OAM_FLIP_H
	.byte <-16,<-21,$01,2
	.byte <- 8,<-21,$01,2|OAM_FLIP_H

	.byte <-16,<-13,$03,2
	.byte <- 8,<-13,$03,2|OAM_FLIP_H
	.byte <- 7,<- 7,$ec,0
	.byte <-15,<- 7,$ed,0
	.byte $80


EWL_StreetSkate_LoadUp_3_data:


	.byte <- 8,<- 4,$d9,0
	.byte <-16,<- 4,$d8,0|OAM_FLIP_H
	.byte <-16,<-21,$01,2
	.byte <- 8,<-21,$01,2|OAM_FLIP_H

	.byte <-16,<-13,$03,2
	.byte <- 8,<-13,$03,2|OAM_FLIP_H
	.byte <- 7,<- 7,$ec,0
	.byte <-15,<- 7,$ed,0
	.byte $80


EWL_StreetSkate_LoadUp_2_data:


	.byte <- 8,<- 4,$d8,0
	.byte <-16,<- 4,$d9,0|OAM_FLIP_H
	.byte <-16,<-21,$01,2
	.byte <- 8,<-21,$01,2|OAM_FLIP_H

	.byte <-16,<-13,$03,2
	.byte <- 8,<-13,$03,2|OAM_FLIP_H
	.byte <- 7,<- 7,$ec,0
	.byte <-15,<- 7,$ed,0
	.byte $80


EWL_StreetSkate_LoadUp_1_data:


	.byte <- 8,<- 4,$d5,0
	.byte <-16,<- 4,$dc,0|OAM_FLIP_H
	.byte <-16,<-21,$01,2
	.byte <- 8,<-21,$01,2|OAM_FLIP_H

	.byte <-16,<-13,$03,2
	.byte <- 8,<-13,$03,2|OAM_FLIP_H
	.byte <- 7,<- 7,$ec,0
	.byte <-15,<- 7,$ed,0
	.byte $80


EWL_StreetSkate_Crash_4_data:


	.byte <- 8,<- 8,$d4,0
	.byte <-16,<- 8,$d4,0|OAM_FLIP_H
	.byte  17,  0,$4b,0
	.byte  25,  0,$4e,0

	.byte  33,  0,$4f,0
	.byte  41,  0,$52,0
	.byte  25,<- 8,$4c,2
	.byte  33,<- 8,$4d,2
	.byte $80


EWL_StreetSkate_Crash_3_data:


	.byte  25,<-17,$08,2
	.byte  33,<-17,$09,2
	.byte  25,<- 9,$0a,2
	.byte  33,<- 9,$0b,2

	.byte  18,<- 7,$e8,0
	.byte  18,<-13,$ed,0
	.byte <- 8,<- 7,$d4,0
	.byte <-16,<- 7,$d4,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_Crash_2_data:


	.byte  16,<-23,$08,2
	.byte  24,<-23,$09,2
	.byte  16,<-15,$0a,2
	.byte  24,<-15,$0b,2

	.byte   9,<-13,$e8,0
	.byte   9,<-19,$ed,0
	.byte <- 8,<- 6,$d4,0
	.byte <-16,<- 6,$d4,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_Crash_1_data:


	.byte <- 1,<-24,$04,2
	.byte   7,<-24,$05,2
	.byte <- 1,<-16,$06,2
	.byte   7,<-16,$07,2

	.byte <- 4,<-10,$e5,0
	.byte <- 8,<-14,$e8,0
	.byte <- 4,<- 2,$e7,0
	.byte <-16,<- 8,$f9,0|OAM_FLIP_H

	.byte <- 9,<- 2,$fa,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_Pothole_1_data:


	.byte <-16,<-13,$71,2
	.byte <- 8,<-13,$74,2
	.byte <-16,<- 5,$73,2
	.byte <- 8,<- 5,$76,2
	.byte $80


EWL_StreetSkate_ShuvIt_0_data:


	.byte <-16,<-30,$01,2
	.byte <- 8,<-30,$01,2|OAM_FLIP_H
	.byte <-16,<-22,$03,2
	.byte <- 8,<-22,$03,2|OAM_FLIP_H

	.byte <- 8,<-15,$ec,0
	.byte <-16,<-14,$e5,0
	.byte <-17,<- 6,$e7,0
	.byte <-14,<- 6,$fe,0

	.byte <- 8,<-14,$fd,0
	.byte $80


EWL_StreetSkate_ShuvIt_1_data:


	.byte <-16,<-29,$01,2
	.byte <-16,<-21,$03,2
	.byte <- 8,<-29,$01,2|OAM_FLIP_H
	.byte <- 8,<-21,$03,2|OAM_FLIP_H

	.byte <-16,<-14,$e1,0|OAM_FLIP_H
	.byte <- 8,<-14,$ec,0
	.byte <- 8,<-10,$d4,0
	.byte <-16,<-10,$d4,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_ShuvIt_2_data:


	.byte <-16,<-31,$01,2
	.byte <-16,<-23,$03,2
	.byte <- 8,<-31,$01,2|OAM_FLIP_H
	.byte <- 8,<-23,$03,2|OAM_FLIP_H

	.byte <-16,<-16,$ed,0
	.byte <- 8,<-16,$e9,0|OAM_FLIP_H
	.byte <-16,<- 9,$9e,0
	.byte <- 8,<- 9,$9f,0
	.byte $80


EWL_StreetSkate_ShuvIt_3_data:


	.byte <-16,<-30,$01,2
	.byte <-16,<-22,$03,2
	.byte <- 8,<-30,$01,2|OAM_FLIP_H
	.byte <- 8,<-22,$03,2|OAM_FLIP_H

	.byte <-16,<-15,$e9,0
	.byte <- 8,<-15,$ec,0
	.byte <-11,<- 8,$bd,0
	.byte $80


EWL_StreetSkate_ShuvIt_4_data:


	.byte <-16,<-29,$01,2
	.byte <-16,<-21,$03,2
	.byte <- 8,<-29,$01,2|OAM_FLIP_H
	.byte <- 8,<-21,$03,2|OAM_FLIP_H

	.byte <-16,<-14,$e9,0
	.byte <- 8,<-14,$ec,0
	.byte <-11,<- 7,$bc,0
	.byte $80


EWL_StreetSkate_ShuvIt_5_data:


	.byte <-16,<-28,$01,2
	.byte <-16,<-20,$03,2
	.byte <- 8,<-28,$01,2|OAM_FLIP_H
	.byte <- 8,<-20,$03,2|OAM_FLIP_H

	.byte <-16,<-12,$e9,0
	.byte <- 8,<-12,$ec,0
	.byte <-12,<- 5,$bd,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_ShuvIt_6_data:


	.byte <-16,<-27,$01,2
	.byte <-16,<-19,$03,2
	.byte <- 8,<-27,$01,2|OAM_FLIP_H
	.byte <- 8,<-19,$03,2|OAM_FLIP_H

	.byte <-16,<-11,$e9,0
	.byte <- 8,<-11,$ec,0
	.byte <-16,<- 5,$9f,0|OAM_FLIP_H
	.byte <- 8,<- 5,$9e,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_ShuvIt_7_data:


	.byte <-16,<-23,$01,2
	.byte <-16,<-15,$03,2
	.byte <- 8,<-23,$01,2|OAM_FLIP_H
	.byte <- 8,<-15,$03,2|OAM_FLIP_H

	.byte <-16,<- 8,$e9,0
	.byte <- 8,<- 8,$ec,0
	.byte <- 8,<- 5,$d4,0
	.byte <-16,<- 5,$d4,0|OAM_FLIP_H
	.byte $80


EWL_StreetSkate_Grate_data:


	.byte <-24,<- 8,$7e,2
	.byte <-16,<- 8,$7f,2
	.byte <- 8,<- 8,$9d,2
	.byte   8,<- 8,$7e,2|OAM_FLIP_H|OAM_FLIP_V

	.byte   0,<- 8,$9d,2
	.byte $80


EWL_StreetSkate_Egg_life_data:


	.byte <- 8,<- 8,$2b,2
	.byte $80


EWL_StreetSkate_Number_0_data:


	.byte <- 8,<- 8,$20,0
	.byte $80


EWL_StreetSkate_Number_1_data:


	.byte <- 8,<- 8,$21,0
	.byte $80


EWL_StreetSkate_Number_2_data:


	.byte <- 8,<- 8,$24,0
	.byte $80


EWL_StreetSkate_Number_3_data:


	.byte <- 8,<- 8,$25,0
	.byte $80


EWL_StreetSkate_Number_4_data:


	.byte <- 8,<- 8,$28,0
	.byte $80


EWL_StreetSkate_Number_5_data:


	.byte <- 8,<- 8,$22,0
	.byte $80


EWL_StreetSkate_Number_6_data:


	.byte <- 8,<- 8,$23,0
	.byte $80


EWL_StreetSkate_Number_7_data:


	.byte <- 8,<- 8,$26,0
	.byte $80


EWL_StreetSkate_Number_8_data:


	.byte <- 8,<- 8,$27,0
	.byte $80


EWL_StreetSkate_Number_9_data:


	.byte <- 8,<- 8,$2a,0
	.byte $80


EWL_StreetSkate_Ramp_data:
	.byte <-16,<-16,$6d,3
	.byte <- 8,<-16,$70,3
	.byte <-16,<- 8,$6f,3
	.byte <- 8,<- 8,$72,3
	.byte $80


EWL_StreetSkate_CautionSign_data:
	.byte <-16,<-16,$5c,0
	.byte <- 8,<-16,$5d,0
	.byte <-16,<- 8,$5e,0
	.byte <- 8,<- 8,$5f,0
	.byte $80


EWL_StreetSkate_Crack_data:
	.byte <-16,<-13,$64,0
	.byte <- 8,<-13,$65,0
	.byte <-16,<- 5,$66,0
	.byte <- 8,<- 5,$67,0
	.byte $80


EWL_StreetSkate_Indicator_data:
	.byte <- 8,<-16,$10,0
	.byte <- 8,<- 8,$12,0
	.byte $80





EWL_StreetSkate_pointers_indicator:
	.word EWL_StreetSkate_Indicator_data


EWL_StreetSkate_pointers_crack:
	.word EWL_StreetSkate_Crack_data


EWL_StreetSkate_pointers_cautionSign:
	.word EWL_StreetSkate_CautionSign_data





EWL_StreetSkate_pointers_eggLife:
	.word EWL_StreetSkate_Egg_life_data
EWL_StreetSkate_pointers_grate:
	.word EWL_StreetSkate_Grate_data


EWL_StreetSkate_pointers_score:	
	.word EWL_StreetSkate_Number_0_data
	.word EWL_StreetSkate_Number_1_data
	.word EWL_StreetSkate_Number_2_data
	.word EWL_StreetSkate_Number_3_data
	.word EWL_StreetSkate_Number_4_data
	.word EWL_StreetSkate_Number_5_data
	.word EWL_StreetSkate_Number_6_data
	.word EWL_StreetSkate_Number_7_data
	.word EWL_StreetSkate_Number_8_data
	.word EWL_StreetSkate_Number_9_data


EWL_StreetSkate_pointers_shuvIt:
	.word EWL_StreetSkate_ShuvIt_7_data
	.word EWL_StreetSkate_ShuvIt_6_data
	.word EWL_StreetSkate_ShuvIt_5_data
	.word EWL_StreetSkate_ShuvIt_4_data
	.word EWL_StreetSkate_ShuvIt_3_data
	.word EWL_StreetSkate_ShuvIt_2_data
	.word EWL_StreetSkate_ShuvIt_1_data
	.word EWL_StreetSkate_ShuvIt_0_data

EWL_StreetSkate_pointers_cone:
	.word EWL_StreetSkate_Cone_1_data
	.word EWL_StreetSkate_Cone_1_data


EWL_StreetSkate_pointers_pothole:
	.word EWL_StreetSkate_Pothole_1_data
	.word EWL_StreetSkate_Pothole_1_data
EWL_StreetSkate_pointers_ramp:
.word EWL_StreetSkate_Ramp_data


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