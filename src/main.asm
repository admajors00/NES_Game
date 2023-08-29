.segment "HEADER"
  .byte $4E, $45, $53, $1A  ; iNES header identifier
  .byte 2                   ; 2x 16KB PRG-ROM Banks
  .byte 1                   ; 1x  8KB CHR-ROM
  .byte $01                 ; mapper 0 (NROM)
  .byte $00                 ; System: NES


.segment "ZEROPAGE"
pointerLo = $00   ; pointer variables are declared in RAM
pointerHi = $01   ; low byte first, high byte immediately after

scroll =$23
nametable = $24

.segment "RAM"


;;; "nes" linker config requires a STARTUP section, even if it's empty

.segment "STARTUP"


.segment "CODE"

.include "controller.asm"
.include "famistudio_ca65.s"
.include "../graphics/StreetCanvas_2.asm"
.include "player.asm"






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

LoadSprites:
	ldx #$80
	stx Player::sprite_pos_x
	LDX #$00 ; start at 0
	LoadSpritesLoop:
		LDA sprites, x ; load data from address (sprites + x)
		STA $0200, x ; store into RAM address ($0200 + x)
		INX ; X = X + 1
		CPX #$20 ; Compare X to hex $10, decimal 16
		BNE LoadSpritesLoop ; Branch to LoadSpritesLoop if compare was Not Equal to zero
		; if compare was equal to 16, continue down  




load_background:
	LDA $2002             ; read PPU status to reset the high/low latch
	LDA #$20
	STA $2006             ; write the high byte of $2000 address
	LDA #$00
	STA $2006             ; write the low byte of $2000 address

	LDA #<StreetCanvas_2 
	STA pointerLo           ; put the low byte of address of background into pointer
	LDA #>StreetCanvas_2        ; #> is the same as HIGH() function in NESASM, used to get the high byte
	STA pointerHi           ; put high byte of address into pointer

	LDX #$00            ; start at pointer + 0
	LDY #$00
	OutsideLoop:
		
		InsideLoop:
			LDA (pointerLo), y  ; copy one background byte from address in pointer plus Y
			STA $2007           ; this runs 256 * 4 times		
			INY                 ; inside loop counter
			CPY #$00
			BNE InsideLoop      ; run the inside loop 256 times before continuing down
		
		INC pointerHi       ; low byte went 0 to 256, so high byte needs to be changed now
		INX
		CPX #$08
		BNE OutsideLoop     ; run the outside loop 256 times before continuing down

jsr Player::init_character
ldx #.lobyte(music_data_untitled)
ldy #.hibyte(music_data_untitled)
lda #1 ; NTSC
jsr famistudio_init
lda #0
jsr famistudio_music_play


LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
STA $2000

LDA #%00011110   ; enable sprites, enable background, no clipping on left side
STA $2001         
              






	
forever:
	jmp	forever




nmi:
	; sprite DMA from $0200
	jsr UpdateButtons

	jsr Player::updatePlayer
	


	@end:

	lda	#$00		; set the low byte (00) of the RAM address
	sta	$2003
	lda	#$02		; set the high byte (02) of the RAM address 
	sta	$4014		; start the transfer
	LDA #$00
	STA $2006        ; clean up PPU address registers
	STA $2006

	LDA scroll
	STA $2005        ; write the horizontal scroll count register

	LDA #$00         ; no vertical scrolling
	STA $2005

	;;This is the PPU clean up section, so rendering the next frame starts properly.
	LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
	ORA nametable    ; select correct nametable for bit 0
	STA $2000

	LDA #%00011110   ; enable sprites, enable background, no clipping on left side
	STA $2001	  
	jsr famistudio_update

	rti

vblankwait:
	bit	$2002
	bpl	vblankwait
	rts

Scroll:
	       ; add one to our scroll variable each frame
	@NTSwapCheck:
		LDA scroll       ; check if the scroll just wrapped from 255 to 0
		BNE @NTSwapCheckDone
	
	@NTSwap:
		LDA nametable    ; load current nametable number (0 or 1)
		EOR #$01         ; exclusive OR of bit 0 will flip that bit
		STA nametable    ; so if nametable was 0, now 1
					;    if nametable was 1, now 0
	@NTSwapCheckDone:
  	rts
  




palette:



.byte $2d,$3d,$38,$00
.byte $2d,$12,$22,$32
.byte $2d,$16,$26,$36
.byte $2d,$14,$24,$34

.byte $0f,$00,$30,$27
.byte $0f,$01,$21,$31
.byte $0f,$06,$16,$26
.byte $0f,$09,$19,$29



	;; Background palette
	; .byte 	$0f,$21,$31,$30
	; .byte 	$0f,$21,$39,$19
	; .byte 	$0f,$39,$29,$19
	; .byte 	$0f,$27,$17,$26
	; 	;; Sprite palette
	; .byte	$0F,$2E,$16,$26
	; .byte	$0F,$2E,$27,$36
	; .byte	$0F,$36,$17,$2C
	; .byte	$0F,$30,$12,$2B



.segment "SONG1"
song_test:
.include "../audio/Song2.s"


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

	.incbin	"../graphics/EWL.chr"	; includes 8KB graphics from SMB1

	