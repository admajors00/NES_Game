.ifndef _PALETTES_INC
_PALETTES_INC = 1



palette_level_2_night:
	.byte $0c,$0f,$03,$14
	.byte $0c,$03,$38,$04
	.byte $0c,$03,$38,$04
	.byte $0c,$03,$09,$1c

	.byte $00,$0f,$24,$26
	.byte $00,$0f,$27,$14
	.byte $00,$0f,$04,$24
	.byte $00,$06,$15,$26


palette_level_3:
	.byte $30,$2c,$0c,$26
	.byte $30,$2c,$0c,$12
	.byte $30,$2c,$0c,$37
	.byte $30,$0f,$2d,$16

	.byte $0f,$0f,$30,$27 ;sprite pallet
	.byte $0f,$0f,$37,$31
	.byte $0f,$0f,$10,$20
	.byte $0f,$17,$16,$27



palette_level_2:
	.byte $11,$0f,$10,$20
	.byte $11,$01,$21,$31
	.byte $11,$31,$22,$21
	.byte $11,$10,$19,$29

	.byte $0f,$0f,$30,$27 ;sprite pallet
	.byte $0f,$0f,$37,$31
	.byte $0f,$0f,$10,$20
	.byte $0f,$17,$16,$27



palette_level_1:
	.byte $0f,$10,$12,$00 ; level 1 pallet
	.byte $0f,$12,$22,$32
	.byte $0f,$16,$26,$36
	.byte $0f,$14,$24,$38

	.byte $0f,$0f,$30,$27 ;sprite pallet
	.byte $0f,$0f,$37,$31
	.byte $0f,$0f,$10,$20
	.byte $0f,$17,$16,$27



palette_TitleScreen:
	.byte $0f,$30,$12,$27
	.byte $0f,$0f,$0f,$0f
	.byte $0f,$20,$0f,$0f
	.byte $0f,$0f,$0f,$0f

	.byte $0f,$0f,$30,$27 ;sprite pallet
	.byte $0f,$0f,$37,$31
	.byte $0f,$0f,$10,$20
	.byte $0f,$17,$16,$27



palette_Instructions:
	.byte $0f,$0f,$30,$27
	.byte $0f,$0f,$0f,$30
	.byte $0f,$2d,$10,$20
	.byte $0f,$18,$28,$38



palette_Intro:
	.byte $30,$0f,$36,$11
	.byte $30,$0f,$0f,$30
	.byte $30,$0f,$10,$27
	.byte $30,$0f,$36,$16



palette_house:
	.byte $11,$0f,$10,$20
	.byte $11,$01,$11,$31
	.byte $11,$37,$17,$26
	.byte $11,$10,$19,$29

	.byte $0f,$0f,$30,$27 ;sprite pallet
	.byte $0f,$0f,$37,$31
	.byte $0f,$0f,$10,$20
	.byte $0f,$17,$16,$27



.endif
