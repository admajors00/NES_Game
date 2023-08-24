; This file is for the FamiStudio Sound Engine and was generated by FamiStudio

.if FAMISTUDIO_CFG_C_BINDINGS
.export _music_data_workingforadventure=music_data_workingforadventure
.endif

music_data_workingforadventure:
	.byte 1
	.word @instruments
	.word @samples-4
	.word @song0ch0,@song0ch1,@song0ch2,@song0ch3,@song0ch4 ; 00 : Song 1
	.byte .lobyte(@tempo_env_1_mid), .hibyte(@tempo_env_1_mid), 0, 0

.export music_data_workingforadventure
.global FAMISTUDIO_DPCM_PTR

@instruments:
	.word @env1,@env2,@env3,@env0 ; 00 : Duty 0

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
	.byte $46, .lobyte(@tempo_env_1_mid), .hibyte(@tempo_env_1_mid), $80
@song0ref6:
	.byte $0d, $a5, $11, $a5
@song0ref10:
	.byte $0d, $a5, $14, $a5
@song0ref14:
	.byte $0d
@song0ref15:
	.byte $a5
@song0ref16:
	.byte $16, $a5, $0d, $a5
@song0ref20:
	.byte $18, $a5
@song0ref22:
	.byte $0d, $a5, $11, $a5, $0d, $a5, $14, $a5, $0d, $9d, $47, $87
	.byte $41, $0f
	.word @song0ref16
	.byte $41, $0a
	.word @song0ref15
	.byte $95, $47, $8f
	.byte $41, $15
	.word @song0ref10
	.byte $a5, $16, $a5, $0d, $8d, $47, $97
	.byte $41, $0b
	.word @song0ref20
	.byte $41, $0e
	.word @song0ref15
	.byte $85, $47, $9f
	.byte $41, $11
	.word @song0ref14
	.byte $a5, $16, $a5, $0d, $a5, $18, $a5, $47
	.byte $41, $1b
	.word @song0ref6
	.byte $41, $0f
	.word @song0ref16
	.byte $41, $0a
	.word @song0ref15
	.byte $95, $47, $8f
	.byte $41, $15
	.word @song0ref10
	.byte $a5, $16, $a5, $0d, $8d, $47, $97
	.byte $41, $0b
	.word @song0ref20
	.byte $41, $0e
	.word @song0ref15
	.byte $85, $47, $9f
	.byte $41, $11
	.word @song0ref14
	.byte $a5, $16, $a5, $0d, $a5, $18, $a5, $47, $00, $ff, $ff, $bd
	.byte $41, $0b
	.word @song0ref22
	.byte $41, $0f
	.word @song0ref16
	.byte $41, $0a
	.word @song0ref15
	.byte $95, $47, $8f
	.byte $41, $15
	.word @song0ref10
	.byte $a5, $16, $a5, $0d, $8d, $47, $97
	.byte $41, $0b
	.word @song0ref20
	.byte $41, $0e
	.word @song0ref15
	.byte $85, $47, $9f
	.byte $41, $11
	.word @song0ref14
	.byte $a5, $16, $a5, $0d, $a5, $18, $a5, $47
	.byte $41, $1b
	.word @song0ref6
	.byte $41, $0f
	.word @song0ref16
	.byte $41, $0a
	.word @song0ref15
	.byte $95, $47, $8f
	.byte $41, $15
	.word @song0ref10
	.byte $a5, $16, $a5, $0d, $8d, $47, $97
	.byte $41, $0b
	.word @song0ref20
	.byte $41, $0e
	.word @song0ref15
@song0ref189:
	.byte $85, $47, $9f, $0d, $a5, $16, $a5, $0d, $a5, $18, $a5, $00, $ff, $ff, $bd, $47
	.byte $41, $1b
	.word @song0ref6
	.byte $41, $0f
	.word @song0ref16
	.byte $41, $0a
	.word @song0ref15
	.byte $95, $47, $8f
	.byte $41, $15
	.word @song0ref10
	.byte $a5, $16, $a5, $0d, $8d, $47, $97
	.byte $41, $0b
	.word @song0ref20
	.byte $41, $0e
	.word @song0ref15
	.byte $41, $0a
	.word @song0ref189
	.byte $41, $10
	.word @song0ref6
	.byte $47
	.byte $41, $1b
	.word @song0ref6
	.byte $41, $0f
	.word @song0ref16
	.byte $41, $0a
	.word @song0ref15
	.byte $95, $47, $8f
	.byte $41, $15
	.word @song0ref10
	.byte $a5, $16, $a5, $0d, $8d, $47, $97, $18, $ff, $ff, $ff, $e5, $42
	.word @song0ch0loop
@song0ch1:
@song0ch1loop:
	.byte $ff, $ff, $ff, $ff, $ff, $7a, $80
@song0ref278:
	.byte $1e, $7c, $83, $7d, $83, $7e, $83, $7f, $ff, $91
@song0ref288:
	.byte $7a, $22, $7c, $83, $7d, $83, $7e, $83, $7f, $ff, $91
@song0ref299:
	.byte $7a, $20, $7c, $83, $7d, $83, $7e, $83, $7f, $b1, $df, $7a, $1d, $7c, $83, $7d, $83, $7e, $83, $7f, $ff, $91, $7a
	.byte $41, $0a
	.word @song0ref278
	.byte $7f, $d1, $bf
@song0ref328:
	.byte $7a, $20, $7c, $83, $7d, $83, $7e, $83, $7f, $ff, $91
@song0ref339:
	.byte $7a, $1d, $7c, $83, $7d, $83, $7e, $83, $7f, $ff, $91
@song0ref350:
	.byte $7a, $20, $7c, $83, $7d, $83, $7e, $83, $7f, $c1, $00, $a5, $7a, $24, $7c, $83, $7d, $81, $81
@song0ref369:
	.byte $7e, $83, $7f, $99, $7a, $1e, $7c, $83, $7d, $83, $7e, $83, $7f, $c1, $7a, $22, $7c, $83, $7d, $83, $7e, $83, $7f, $c1
@song0ref393:
	.byte $7a, $24, $7c, $83, $7d, $83, $7e, $83, $7f, $85, $00, $91, $7a, $24, $7c, $83, $7d, $83, $7e, $83, $7f, $85, $00, $91
@song0ref417:
	.byte $7a, $24, $7c, $83, $7d, $83, $7e, $83, $7f, $99, $7a, $22, $7c, $83, $7d, $83
@song0ref433:
	.byte $7e, $83, $7f, $99, $7a, $27, $7c, $83, $7d, $83, $7e, $83, $7f, $99
@song0ref447:
	.byte $7a, $29, $7c, $83, $7d, $83, $7e, $83, $7f, $99, $7a, $2c, $7c, $83, $7d, $83, $7e, $83, $7f, $99, $7a, $2e, $7c, $83
	.byte $7d, $83, $7e, $83, $7f, $99
	.byte $41, $15
	.word @song0ref328
	.byte $7d, $83
@song0ref482:
	.byte $7e, $83, $7f, $99, $7a, $1e, $7c, $83, $7d, $83, $7e, $83, $7f, $91, $af, $7a, $22, $7c, $83, $7d, $83, $7e, $83, $7f
	.byte $c1
@song0ref507:
	.byte $7a, $20, $7c, $83, $7d, $83, $7e, $83, $7f, $c1, $00, $a5, $7a, $24, $7c, $83, $7d, $83
	.byte $41, $19
	.word @song0ref369
	.byte $81, $8f
	.byte $41, $1e
	.word @song0ref417
	.byte $41, $0a
	.word @song0ref328
	.byte $7f, $d1, $bf
	.byte $41, $0a
	.word @song0ref507
	.byte $41, $0c
	.word @song0ref369
	.byte $41, $43
	.word @song0ref350
	.byte $41, $0c
	.word @song0ref328
	.byte $7a
	.byte $41, $0a
	.word @song0ref278
	.byte $7f, $91, $ff
	.byte $41, $0c
	.word @song0ref328
	.byte $7a, $1e, $7c, $83, $7d, $83, $7e, $83, $7f, $b1, $df
	.byte $41, $0a
	.word @song0ref288
	.byte $7f, $ff, $91, $7a, $1d, $7c, $83, $7d, $83, $7e, $83, $7f, $d1, $bf
	.byte $41, $0a
	.word @song0ref507
	.byte $41, $21
	.word @song0ref369
	.byte $7d, $81, $81
	.byte $41, $16
	.word @song0ref433
	.byte $41, $15
	.word @song0ref328
	.byte $7d, $83
	.byte $41, $0c
	.word @song0ref369
	.byte $41, $0a
	.word @song0ref507
	.byte $41, $0d
	.word @song0ref482
	.byte $41, $2c
	.word @song0ref393
	.byte $41, $0c
	.word @song0ref299
	.byte $41, $0a
	.word @song0ref507
	.byte $41, $0b
	.word @song0ref369
	.byte $7f, $81, $bf
	.byte $41, $0a
	.word @song0ref507
	.byte $41, $21
	.word @song0ref369
	.byte $7d, $81, $81
	.byte $41, $16
	.word @song0ref433
	.byte $41, $0c
	.word @song0ref328
	.byte $7a
	.byte $41, $10
	.word @song0ref278
	.byte $7f, $ff, $91, $7a, $1d, $7c, $83, $7d, $83, $7e, $83, $7f, $91, $ff, $7a
	.byte $41, $18
	.word @song0ref278
	.byte $41, $0a
	.word @song0ref507
	.byte $41, $0b
	.word @song0ref369
	.byte $7f, $81, $bf
	.byte $41, $2c
	.word @song0ref393
	.byte $7a, $20, $7c, $83, $7d, $83, $7e, $83, $7f, $f1, $9f
	.byte $41, $0f
	.word @song0ref339
	.byte $7d, $83
	.byte $41, $0c
	.word @song0ref369
	.byte $41, $0a
	.word @song0ref507
	.byte $41, $28
	.word @song0ref369
	.byte $7f, $91, $87
	.byte $41, $0f
	.word @song0ref447
	.byte $41, $10
	.word @song0ref328
	.byte $7f, $b1, $8f, $00, $a5, $7a, $24, $7c, $83, $7d, $83
	.byte $41, $0c
	.word @song0ref369
	.byte $41, $0a
	.word @song0ref507
	.byte $41, $0b
	.word @song0ref369
	.byte $7f, $81, $ff, $ff, $ff, $ff, $42
	.word @song0ch1loop
@song0ch2:
@song0ch2loop:
	.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bf, $80
@song0ref752:
	.byte $33, $bd, $df, $30, $ff, $9d, $31, $ff, $9d, $35, $dd, $bf, $33, $ff, $9d, $30, $ff, $9d, $31, $fd, $9f, $35, $ff, $9d
	.byte $00, $ff, $ff, $bd
@song0ref780:
	.byte $33, $ff, $9d, $30, $ff, $9d, $31, $ff, $9d, $35, $9d, $ff, $33, $ff, $9d, $30, $ff, $9d, $00, $bd, $ff, $ff
@song0ref802:
	.byte $33, $ff, $9d, $30, $dd, $bf, $31, $ff, $9d, $35, $ff, $9d, $33, $fd, $9f, $30, $ff, $9d, $00, $ff, $ff, $bd, $ff, $ff
	.byte $ff, $ff
@song0ref828:
	.byte $ff, $33, $ff, $9d, $30, $ff, $9d, $31, $bd, $df, $35, $ff, $9d
	.byte $41, $0c
	.word @song0ref802
	.byte $00, $fd, $ff, $bf
	.byte $41, $0a
	.word @song0ref780
	.byte $ff, $9d, $33, $ff, $9d, $30, $9d, $ff, $00, $ff, $ff, $bd
	.byte $41, $12
	.word @song0ref752
	.byte $00, $fd, $ff, $ff, $ff, $ff, $ff, $ff, $bf, $33, $ff, $9d, $30, $9d, $ff, $31, $ff, $9d, $35, $ff, $9d
	.byte $41, $0c
	.word @song0ref752
	.byte $00, $ff, $ff, $bd, $33, $fd, $9f, $30, $ff, $9d, $31, $ff, $9d, $35, $ff, $9d, $33, $ff, $9d, $30, $ff, $9d, $00, $ff
	.byte $bd
	.byte $41, $0d
	.word @song0ref828
	.byte $33, $ff, $9d, $30, $dd, $ff, $ff, $ff, $ff, $42
	.word @song0ch2loop
@song0ch3:
@song0ch3loop:
	.byte $ff, $ff, $bf, $80
@song0ref935:
	.byte $16, $7d, $81, $7c, $81, $7a, $81, $73, $8b
@song0ref944:
	.byte $7f, $14
@song0ref946:
	.byte $7d, $81, $7c, $81, $7a, $81
@song0ref952:
	.byte $73, $8b
@song0ref954:
	.byte $00, $a5
@song0ref956:
	.byte $7f, $1b, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $00, $b9, $7f, $16, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $7f, $18
	.byte $7d, $81, $7c, $81, $7a, $81, $73, $83, $87
	.byte $41, $0e
	.word @song0ref954
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $7f, $14, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $00, $95, $8f
	.byte $41, $10
	.word @song0ref956
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $17
	.word @song0ref944
@song0ref1020:
	.byte $73, $8b, $00, $a5, $7f, $1b, $7d, $81, $7c, $81, $7a, $81, $73, $87, $83, $00, $b9, $7f
	.byte $41, $1c
	.word @song0ref935
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $0d
	.word @song0ref944
	.byte $99, $9f, $7f, $16, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $7f, $18
	.byte $41, $12
	.word @song0ref946
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $19
	.word @song0ref944
	.byte $41, $0e
	.word @song0ref954
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $7f, $14, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $00, $95, $8f
	.byte $41, $10
	.word @song0ref956
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0b
	.word @song0ref1020
	.byte $7f
	.byte $41, $1c
	.word @song0ref935
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $0d
	.word @song0ref944
	.byte $99, $9f, $7f, $16, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $7f, $18
	.byte $41, $12
	.word @song0ref946
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0a
	.word @song0ref952
	.byte $ff, $ff, $bf, $7f
	.byte $41, $1e
	.word @song0ref935
	.byte $41, $0e
	.word @song0ref954
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $7f, $14, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $00, $95, $8f
	.byte $41, $10
	.word @song0ref956
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0b
	.word @song0ref1020
	.byte $7f
	.byte $41, $1c
	.word @song0ref935
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $0d
	.word @song0ref944
	.byte $99, $9f, $7f, $16, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $7f, $18
	.byte $41, $12
	.word @song0ref946
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $19
	.word @song0ref944
	.byte $41, $0e
	.word @song0ref954
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $7f, $14, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $00, $95, $8f
	.byte $41, $10
	.word @song0ref956
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0b
	.word @song0ref1020
	.byte $7f
	.byte $41, $1c
	.word @song0ref935
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $0d
	.word @song0ref944
	.byte $99, $9f, $7f, $16, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $7f, $18
	.byte $41, $0c
	.word @song0ref946
	.byte $ff, $ff, $f9, $7f
	.byte $41, $1c
	.word @song0ref935
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $19
	.word @song0ref944
	.byte $41, $0e
	.word @song0ref954
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $7f, $14, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $00, $95, $8f
	.byte $41, $10
	.word @song0ref956
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0b
	.word @song0ref1020
	.byte $7f
	.byte $41, $1c
	.word @song0ref935
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $0d
	.word @song0ref944
	.byte $99, $9f, $7f, $16, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $7f, $18
	.byte $41, $12
	.word @song0ref946
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $19
	.word @song0ref944
	.byte $41, $0e
	.word @song0ref954
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0f
	.word @song0ref952
	.byte $7f, $14, $7d, $81, $7c, $81, $7a, $81, $73, $8b, $00, $95, $8f
	.byte $41, $10
	.word @song0ref956
	.byte $41, $0f
	.word @song0ref952
	.byte $41, $17
	.word @song0ref944
	.byte $41, $0a
	.word @song0ref1020
	.byte $ff, $ff, $ff, $f9, $42
	.word @song0ch3loop
@song0ch4:
@song0ch4loop:
@song0ref1421:
	.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	.byte $41, $0a
	.word @song0ref1421
	.byte $41, $0a
	.word @song0ref1421
	.byte $41, $0a
	.word @song0ref1421
	.byte $41, $0a
	.word @song0ref1421
	.byte $41, $0a
	.word @song0ref1421
	.byte $41, $0a
	.word @song0ref1421
	.byte $41, $0a
	.word @song0ref1421
	.byte $41, $0a
	.word @song0ref1421
	.byte $41, $0a
	.word @song0ref1421
	.byte $41, $0a
	.word @song0ref1421
	.byte $ff, $ff, $ff, $ff, $ff, $ff, $42
	.word @song0ch4loop
