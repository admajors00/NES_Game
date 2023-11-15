.segment "HEADER"
;   .byte $4E, $45, $53, $1A  ; iNES header identifier
;   .byte 2                  ; 2x 16KB PRG-ROM Banks
;   .byte 4                 ; 1x  8KB CHR-ROM
; ;   .byte 0
;   .byte $03                ; mapper 0 (NROM)
;   .byte $00                 ; System: NES
INES_MAPPER = 3 ; 0 = NROM
INES_MIRROR = 1 ; 0 = horizontal mirroring, 1 = vertical mirroring
INES_SRAM   = 0 ; 1 = battery backed SRAM at $6000-7FFF

.byte $4E, $45, $53, $1A ; ID "NES", $1a;
.byte $02 ; 16k PRG chunk count
.byte $04 ; 8k CHR chunk count
.byte INES_MIRROR | (INES_SRAM << 1) | ((INES_MAPPER & $f) << 4)
.byte (INES_MAPPER & %11110000)
.byte $0, $0, $0, $0, $0, $0, $0, $0 ; padding

.segment "ZEROPAGE"
main_pointer_LO = $f2  ; pointer variables are declared in RAM
main_pointer_HI = $f3  ; low byte first, high byte immediately after



amount_to_scroll = $f4; .res 1
main_temp = $f5
bg_chr_rom_start_addr = $f6
bg_sprite_on_off = $f7
frame_counter = $f8	

rng_seed_LO = $f9
rng_seed_HI = $fA
.org $f9
seed: .res 2
.reloc
.segment "RAM"


;;; "nes" linker config requires a STARTUP section, even if it's empty

.segment "STARTUP"


.segment "CODE"
.autoimport 	+

.include "controller.s"

;.include "../graphics/StreetCanvas_2.s"

.include "player.s"
.include "chaser.s"
.include "obsticles.s"
.include "animations.s"
.include "background.s"
.include "game.s"
.include "StatusBar.s"
.include "famistudio_ca65.s"




PpuCtrl			= $2000
PpuMask			= $2001
PpuStatus		= $2002
OamAddr			= $2003
OamData			= $2004
PpuScroll		= $2005
PpuAddr			= $2006
PpuData			= $2007
OamDma			= $4014

playList:
	.addr music_data_untitled, music_data_get_fucked

reset:
	sei			; disable IRQs
	cld			; disable decimal mode
	ldx	#$40
	stx	$4017		; dsiable APU frame IRQ
	ldx	#$ff		; Set up stack
	txs			;  .
	inx			; now X = 0
	stx	$2000		; disable NMI
	stx	$2001		; disable rendering
	stx	$4010		; disable DMC I	RQs
 

	;; first wait for vblank to make sure PPU is ready
jsr vblankwait

clear_memory:
	lda	#$00
	sta	$0000, x
	sta	$0100, x
	sta	$0300, x
	sta	$0400, x
	sta	$0500, x
	sta	$0600, x
	sta	$0700, x
	lda	#$fe
	sta	$0200, x	; move all sprites off screen
	inx
	bne	clear_memory

	;; second wait for vblank, PPU is ready after this
jsr vblankwait


clear_nametables:
		lda	$2002		; read PPU status to reset the high/low latch
		lda	#$20		; write the high byte of $2000
		sta	$2006		;  .
		lda	#$00		; write the low byte of $2000
		sta	$2006		;  .
		ldx	#$08		; prepare to fill 8 pages ($800 bytes)
		ldy	#$00		;  x/y is 16-bit counter, high byte in x
		lda	#$2F		; fill with tile $27 (a solid box)
	@loop:
		sta	$2007
		dey
		bne	@loop
		dex
		bne	@loop
jsr vblankwait

lda #$69
sta rng_seed_LO
lda #$42
sta rng_seed_HI


jsr Game::Start_Screen_Init

	
forever:
	jmp	forever




nmi:
	inc frame_counter
	jsr Handle_Scroll

	jsr famistudio_update
	
	jsr Game::Update
	
	
	@end:
rti






vblankwait:
	bit	$2002
	bpl	vblankwait
rts


BankSwitch:
	tax

	sta BankValues, x
	rts
BankValues:
	.byte $00, $01, $02, $03
;;;;;;;;;;;;;; 

prng:
	ldy #8     ; iteration count (generates 8 bits)
	lda seed+0
:
	asl        ; shift the register
	rol seed+1
	bcc :+
	eor #$39   ; apply XOR feedback whenever a 1 bit is shifted out
:
	dey
	bne :--
	sta seed+0
	cmp #0     ; reload flags
	rts

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
;palette_EWL_StreetSkate_b:
.byte $0f,$10,$12,$00 ; level 1 pallet
.byte $0f,$12,$22,$32
.byte $0f,$16,$26,$36
.byte $0f,$14,$24,$38

.byte $0f,$0f,$30,$27 ;sprite pallet
.byte $0f,$0f,$37,$31
.byte $0f,$0f,$10,$20
.byte $0f,$17,$16,$27

;palette_Level2_a:

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


Start_Screen:
	.incbin "../graphics/Backgrounds/TitleScreen.bin"
Level_Screen_1:
	.incbin"../graphics/Backgrounds/Level_1_1.bin"
Level_Screen_2:
	.incbin "../graphics/Backgrounds/Level_1_2.bin"
Level_Screen_3:
	.incbin "../graphics/Backgrounds/Level_1_3.bin"
Level_Screen_4:
	.incbin "../graphics/Backgrounds/Level_1_4.bin"
Level_Screen_2_1:
	.incbin"../graphics/Backgrounds/Level_2_1.bin"
Level_Screen_2_2:
	.incbin "../graphics/Backgrounds/Level_2_2.bin"
; Level_Screen_2_3:
; 	.incbin "../graphics/Backgrounds/Level_2_3.bin"


Level_Screen_3_1:
	.incbin"../graphics/Backgrounds/Level_3_1.bin"
Level_Screen_3_2:
	.incbin "../graphics/Backgrounds/Level_3_2.bin"
Level_Screen_3_3:
	.incbin "../graphics/Backgrounds/Level_3_3.bin"
Level_Screen_3_4:
	.incbin "../graphics/Backgrounds/Level_3_4.bin"
Level_Screen_3_5:
	.incbin "../graphics/Backgrounds/Level_3_5.bin"
End_Screen:
	.incbin"../graphics/Backgrounds/EndScreen.bin"
WIN_Screen:
    .incbin"../graphics/Backgrounds/WinScreen.bin"
Intro_Screen_1:
	.incbin"../graphics/Backgrounds/Intro_1.bin"
Intro_Screen_2:
	.incbin"../graphics/Backgrounds/Intro_2.bin"	
Intro_Screen_3:
	.incbin"../graphics/Backgrounds/Intro_3.bin"
Intro_Screen_4:
	.incbin"../graphics/Backgrounds/Intro_4.bin"

Level_Screen_House:
	.incbin "../graphics/Backgrounds/House.bin"
Level_Screen_Lake_sign:
	.incbin "../graphics/Backgrounds/Lake_sign.bin"
Level_Screen_Market_sign:
	.incbin "../graphics/Backgrounds/Market_sign.bin"
Level_Screen_SkatePark_sign:
	.incbin "../graphics/Backgrounds/SkatePark_sign.bin"	
song_test:
.include "../audio/Song2.s"


song_game_over:
.include "../audio/gameover_get_fucked.s"


;;;;;;;;;;;;;;  
  
.segment "VECTORS"

	;; When an NMI happens (once per frame if enabled) the label nmi:
	.word	nmi
	;; When the processor first turns on or is reset, it will jump to the
	;; label reset:
	.word	reset
	;; External interrupt IRQ is not used in this tutorial 
	.word	0
  
;;;;;;;;;;;;;;  
; .segment "CHARS"
	; .incbin	"../graphics/Sprites.chr"	; includes 8KB graphics from SMB1
	; .incbin	"../graphics/StartScreen.chr"
 .segment "TITLEBANK"
; ;.proc banked_chr_1
		.incbin	"../graphics/Intro.chr"	; includes 8KB graphics from SMB1
		.incbin	"../graphics/StartScreen.chr"
	;.endproc
	

.segment "LEVEL1"	
	;.proc banked_chr_2
		.incbin	"../graphics/Sprites.chr"	; includes 8KB graphics from SMB1
		.incbin	"../graphics/Level1.chr"
.segment "LEVEL2"	
	;.proc banked_chr_2
		.incbin	"../graphics/Sprites.chr"	; includes 8KB graphics from SMB1
		.incbin	"../graphics/Level2.chr"
.segment "LEVEL3"	
	;.proc banked_chr_2
		.incbin	"../graphics/Sprites.chr"	; includes 8KB graphics from SMB1
		.incbin	"../graphics/Level2.chr"
	;.endproc
; .proc Bank_Table
; 	.addr banked_chr_1
; 	.byte <.bank (banked_chr_1)
; 	.addr banked_chr_2
; 	.byte <.bank (banked_chr_2)
; .endproc
