.segment "HEADER"
  .byte $4E, $45, $53, $1A  ; iNES header identifier
  .byte 2                  ; 2x 16KB PRG-ROM Banks
  .byte 2                   ; 1x  8KB CHR-ROM
  .byte $03                 ; mapper 0 (NROM)
  .byte $00                 ; System: NES


.segment "ZEROPAGE"
main_pointer_LO = $f2  ; pointer variables are declared in RAM
main_pointer_HI = $f3  ; low byte first, high byte immediately after



amount_to_scroll = $f4; .res 1

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


load_palettes:
		lda	$2002		; read PPU status to reset the high/low latch
		lda	#$3f
		sta	$2006
		lda	#$00
		sta	$2006
		ldx	#$00
	@loop:
		lda	palette, x	; load palette byte
		sta	$2007		; write to PPU
		inx			; set index to next byte
		cpx	#$20
		bne	@loop		; if x = $20, 32 bytes copied, all done

; LoadSprites:
; 	ldx #$80
; 	stx Player::sprite_pos_x
; 	LDX #$00 ; start at 0
; 	LoadSpritesLoop:
; 		LDA sprites, x ; load data from address (sprites + x)
; 		STA $0200, x ; store into RAM address ($0200 + x)
; 		INX ; X = X + 1
; 		CPX #$20 ; Compare X to hex $10, decimal 16
; 		BNE LoadSpritesLoop ; Branch to LoadSpritesLoop if compare was Not Equal to zero
; 		; if compare was equal to 16, continue down  




; load_background:
; 	LDA $2002             ; read PPU status to reset the high/low latch
; 	LDA #$20
; 	STA $2006             ; write the high byte of $2000 address
; 	LDA #$00
; 	STA $2006             ; write the low byte of $2000 address

	LDA #<Start_Screen
	STA bg_data_pt_LO           ; put the low byte of address of background into pointer
	LDA #>Start_Screen        ; #> is the same as HIGH() function in NESASM, used to get the high byte
	STA bg_data_pt_HI           ; put high byte of address into pointer
	jsr Background::load_background_nt1
	; LDX #$00            ; start at pointer + 0
	; LDY #$00
	; OutsideLoop:
		
	; 	InsideLoop:
	; 		LDA (main_pointer_LO), y  ; copy one background byte from address in pointer plus Y
	; 		STA $2007           ; this runs 256 * 4 times		
	; 		INY                 ; inside loop counter
	; 		CPY #$00
	; 		BNE InsideLoop      ; run the inside loop 256 times before continuing down
		
	; 	INC main_pointer_HI       ; low byte went 0 to 256, so high byte needs to be changed now
	; 	INX
	; 	CPX #$08
	; 	BNE OutsideLoop     ; run the outside loop 256 times before continuing down
; inc scroll
; lda #$01
; sta scroll_HI
; jsr Background::Init
jsr Animation::Init

jsr Obsticles::Init
;jsr Game::Init




LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
STA $2000

LDA #%00011110   ; enable sprites, enable background, no clipping on left side
STA $2001         
              






	
forever:
	jmp	forever




nmi:
	
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
	sta $8000
	rts

;;;;;;;;;;;;;;  



palette:
;palette_EWL_StreetSkate_b:
.byte $0f,$10,$12,$00 ; level 1 pallet
.byte $0f,$12,$22,$32
.byte $0f,$16,$26,$36
.byte $0f,$14,$24,$38
; .byte $11,$0f,$10,$20 ;level 2
; .byte $11,$01,$21,$31
; .byte $11,$31,$22,$21
; .byte $11,$10,$19,$29


;palette_EWL_StreetSkate_a:
.byte $0f,$0f,$30,$27 ;sprite pallet
.byte $0f,$0f,$37,$31
.byte $0f,$0f,$10,$20
.byte $0f,$17,$16,$27
;palette_Level2_a:



Start_Screen:
	.incbin "../graphics/TitleScreen.bin"
	; .incbin"../graphics/Level_2_1.bin"

	; .incbin"../graphics/Level_2_2.bin"
Level_Screen_1:
	.incbin"../graphics/Level_1_1.bin"
Level_Screen_2:
	.incbin "../graphics/Level_1_2.bin"
Level_Screen_3:
	.incbin "../graphics/Level_1_3.bin"
Level_Screen_4:
	.incbin "../graphics/Level_1_4.bin"
Level_Screen_2_1:
	.incbin"../graphics/Level_2_1.bin"
Level_Screen_2_2:
	.incbin "../graphics/Level_2_2.bin"
Level_Screen_2_3:
	.incbin "../graphics/Level_2_3.bin"

End_Screen:
.incbin"../graphics/Level_1_3.bin"
	;.incbin "../graphics/Longer_street_end.bin"


; .include "../graphics/Longer_street.s"

.segment "SONG1"
song_test:
.include "../audio/Song2.s"

.segment "SONG2"
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
.segment "CHARS"
	; .incbin	"../graphics/Sprites.chr"	; includes 8KB graphics from SMB1
	; .incbin	"../graphics/StartScreen.chr"
 .segment "LEVEL1"
; ;.proc banked_chr_1
		.incbin	"../graphics/Sprites.chr"	; includes 8KB graphics from SMB1
		.incbin	"../graphics/StartScreen.chr"
	;.endproc
	

.segment "LEVEL2"	
	;.proc banked_chr_2
		.incbin	"../graphics/Sprites.chr"	; includes 8KB graphics from SMB1
		.incbin	"../graphics/Level1.chr"
	;.endproc
; .proc Bank_Table
; 	.addr banked_chr_1
; 	.byte <.bank (banked_chr_1)
; 	.addr banked_chr_2
; 	.byte <.bank (banked_chr_2)
; .endproc
