; This file is for the FamiStudio Sound Engine and was generated by FamiStudio

.if FAMISTUDIO_CFG_C_BINDINGS
.export _music_data_get_fucked=music_data_get_fucked
.endif

music_data_get_fucked:
	.byte 1
	.word @instruments
	.word @samples-4
	.word @song0ch0,@song0ch1,@song0ch2,@song0ch3,@song0ch4 ; 00 : Get_Fucked
	.byte .lobyte(@tempo_env_1_mid), .hibyte(@tempo_env_1_mid), 0, 0

.export music_data_get_fucked
.global FAMISTUDIO_DPCM_PTR

@instruments:
	.word @env1,@env2,@env3,@env0 ; 00 : Instrument 1

@env0:
	.byte $00,$c0,$7f,$00,$02
@env1:
	.byte $00,$cf,$7f,$00,$02
@env2:
	.byte $c0,$7f,$00,$01
@env3:
	.byte $7f,$00,$00

@samples:

@tempo_env_1_mid:
	.byte $03,$05,$80

@song0ch0:
@song0ch0loop:
	.byte $46, .lobyte(@tempo_env_1_mid), .hibyte(@tempo_env_1_mid), $80, $19, $cd, $18, $a5, $15, $a5, $14, $ff, $9d, $47, $00
	.byte $ff, $ff, $bd
@song0ref20:
	.byte $47, $ff, $ff, $bf, $47, $ff, $ff, $bf, $47, $ff, $ff, $bf, $47, $ff, $ff, $bf, $47, $ff, $ff, $bf, $47, $ff, $ff, $bf
	.byte $47, $ff, $ff, $bf
	.byte $41, $15
	.word @song0ref20
	.byte $42
	.word @song0ch0loop
@song0ch1:
@song0ch1loop:
	.byte $80, $0d, $91, $08, $91, $0d, $91, $08, $91, $0d, $91, $0c, $91, $09, $91, $00, $91, $08, $ff, $9d
@song0ref75:
	.byte $00, $ff, $ff, $bd
@song0ref79:
	.byte $ff, $ff, $bf, $ff, $ff, $bf, $ff, $ff, $bf, $ff, $ff, $bf, $ff, $ff, $bf, $ff, $ff, $bf, $ff, $ff, $bf
	.byte $41, $15
	.word @song0ref79
	.byte $42
	.word @song0ch1loop
@song0ch2:
@song0ch2loop:
	.byte $80, $4f, $03, $3d, $39, $a5, $4f, $04, $3b, $37, $a5, $4f, $08, $39, $31, $a5, $4f, $06, $31, $2d, $a5, $4f, $07, $2f
	.byte $2b, $a5, $4f, $10, $2d, $25, $a5, $4f, $0c, $25, $21, $a5, $15, $a5
	.byte $41, $19
	.word @song0ref75
	.byte $41, $15
	.word @song0ref79
	.byte $42
	.word @song0ch2loop
@song0ch3:
@song0ch3loop:
	.byte $80, $40, $51, $83, $00, $b1, $40, $51, $83, $00, $8d, $3d, $81, $00, $b3, $40, $51, $83, $00, $8d, $3d, $81, $00, $8b
	.byte $40, $51, $83, $00, $8d, $40, $51, $83, $00, $ef
	.byte $41, $15
	.word @song0ref79
	.byte $41, $15
	.word @song0ref79
	.byte $ff, $ff, $bf, $42
	.word @song0ch3loop
@song0ch4:
@song0ch4loop:
	.byte $41, $15
	.word @song0ref79
	.byte $41, $15
	.word @song0ref79
	.byte $ff, $ff, $bf, $ff, $ff, $bf, $42
	.word @song0ch4loop