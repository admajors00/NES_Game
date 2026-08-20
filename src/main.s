.list on
.segment "HEADER"
;   .byte $4E, $45, $53, $1A  ; iNES header identifier
;   .byte 2                  ; 2x 16KB PRG-ROM Banks
;   .byte 4                 ; 1x  8KB CHR-ROM
;   .byte 0
;   .byte $03                ; mapper 0 (NROM)
;   .byte $00                 ; System: NES

INES_MAPPER = 3 ; 0 = NROM
INES_MIRROR = 1 ; 0 = horizontal mirroring, 1 = vertical mirroring
INES_SRAM   = 0 ; 1 = battery backed SRAM at $6000-7FFF

.byte $4E, $45, $53, $1A ; ID "NES", $1a;
.byte $02 ; 16k PRG chunk count
.byte $03 ; 8k CHR chunk count
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
.segment "STARTUP" ;;; "nes" linker config requires a STARTUP section, even if it's empty
.segment "CODE"
.autoimport 	+

.include "controller.s"
.include "player.s"
.include "chaser.s"
.include "obsticles.s"
.include "animations.s"

.include "background_manager.s"
.include "scene_manager.s"
.include "level_manager.s"
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



reset:
	sei			; disable IRQs
	cld			; disable decimal mode
	ldx	#$40
	stx	$4017		; dsiable APU frame IRQ
	ldx	#$ff		; Set up stack
	txs			;  .
	inx			; now X = 0
	stx	PpuCtrl		; disable NMI
	stx	PpuMask		; disable rendering
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
		lda	PpuStatus		; read PPU status to reset the high/low latch
		lda	#$20		; write the high byte of $2000
		sta	PpuAddr		;  .
		lda	#$00		; write the low byte of $2000
		sta	PpuAddr		;  .
		ldx	#$08		; prepare to fill 8 pages ($800 bytes)
		ldy	#$00		;  x/y is 16-bit counter, high byte in x
		lda	#$2F		; fill with tile $27 (a solid box)
	@loop:
		sta	PpuData
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
	jsr BgManager::Handle_Scroll
	jsr famistudio_update
	jsr Game::Update
	@end:
rti



vblankwait:
	bit	PpuStatus
	bpl	vblankwait
rts



BankSwitch:
	tax
	sta BankValues, x
	rts



BankValues:
	.byte $00, $01, $02, $03



LoadRandNumIntoAcc:
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



.include "/inc/palettes.inc"
.include "/inc/BackgroundData.inc"



song_test:
	.include "../audio/Song2.s"



song_game_over:
	.include "../audio/gameover_get_fucked.s"



.segment "VECTORS"
	;; When an NMI happens (once per frame if enabled) the label nmi:
	.word	nmi
	;; When the processor first turns on or is reset, it will jump to the
	;; label reset:
	.word	reset
	;; External interrupt IRQ is not used in this tutorial 
	.word	0
  


 .segment "TITLEBANK"
		.incbin	"../graphics/Intro.chr"	; includes 8KB graphics from SMB1
		.incbin	"../graphics/StartScreen.chr"



.segment "LEVEL1"	
		.incbin	"../graphics/Sprites.chr"	; includes 8KB graphics from SMB1
		.incbin	"../graphics/Level1.chr"



.segment "LEVEL2"	
		.incbin	"../graphics/Sprites.chr"	; includes 8KB graphics from SMB1
		.incbin	"../graphics/Level2.chr"

