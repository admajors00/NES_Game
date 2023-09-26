.segment "HEADER"
  .byte $4E, $45, $53, $1A  ; iNES header identifier
  .byte 2                   ; 2x 16KB PRG-ROM Banks
  .byte 1                   ; 1x  8KB CHR-ROM
  .byte $01                 ; mapper 0 (NROM)
  .byte $00                 ; System: NES


.segment "ZEROPAGE"
pointerLo = $60   ; pointer variables are declared in RAM
pointerHi = $61   ; low byte first, high byte immediately after

scroll =$33
scroll_HI = $34
nametable = $35

column_LO = $36
column_HI = $37

new_background_LO = $38
new_background_HI = $39

column_number = $3A

amount_to_scroll = $3B

temp1 = $1e
temp2 = $1F

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
.include "game.s"
.include "famistudio_ca65.s"




;.include "game.asm"






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




load_background:
	LDA $2002             ; read PPU status to reset the high/low latch
	LDA #$20
	STA $2006             ; write the high byte of $2000 address
	LDA #$00
	STA $2006             ; write the low byte of $2000 address

	LDA #<Longer_street 
	STA pointerLo           ; put the low byte of address of background into pointer
	LDA #>Longer_street        ; #> is the same as HIGH() function in NESASM, used to get the high byte
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
inc scroll
lda #$01
sta scroll_HI
jsr Animation::Init
jsr Chaser::Init
jsr Player::init_character
jsr Obsticles::Init


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
	; jsr Scroll
	;ldx amount_to_scroll
	ldx amount_to_scroll
	
	beq scroll_done
	loop_1:
		lda scroll
		clc
		adc#$01
		sta scroll
		lda scroll_HI
		adc #0
		sta scroll_HI
		cmp #3	
		bcc @continue
			lda #0
			sta scroll_HI
		@continue:
		
		New_Column_Check:
			LDA scroll
			and #%00000111
			bne @New_Column_Check_done
			
			
				lda column_number
				clc
				adc #$01
				and #%01111111
				sta column_number
				jsr Scroll
				jsr Draw_New_Collumn
			
				LDA scroll
				AND #%00011111            ; check for multiple of 32
				BNE @New_Column_Check_done    ; if low 5 bits = 0, time to write new attribute bytes

				jsr DrawNewAttributes

			@New_Column_Check_done:


		dec amount_to_scroll
		bne loop_1
		jmp scroll_done


		
	scroll_done:
	;
	lda	#$00		; set the low byte (00) of the RAM address
	sta	$2003
	lda	#$02		; set the high byte (02) of the RAM address 
	sta	$4014		; start the transfer
	LDA #$00
	STA $2006        ; clean up PPU address registers
	STA $2006

	LDA #$00
	STA $2005        ; write the horizontal scroll count register        ; no vertical scrolling
	STA $2005

	;;This is the PPU clean up section, so rendering the next frame starts properly.
	LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
;	ORA nametable    ; select correct nametable for bit 0
	STA $2000

	LDA #%00011110   ; enable sprites, enable background, no clipping on left side
	STA $2001	  


WaitNotSprite0:
  lda $2002
  and #%01000000
  bne WaitNotSprite0   ; wait until sprite 0 not hit

WaitSprite0:
  lda $2002
  and #%01000000
  beq WaitSprite0      ; wait until sprite 0 is hit

  ldx #$10
WaitScanline:
  dex
  bne WaitScanline
  
  ; now set the scroll and nametable to use for the rest of the screen down
  
  LDA scroll
  STA $2005        ; write the horizontal scroll count register

  LDA #$00         ; no vertical scrolling
  STA $2005
    
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  ORA nametable    ; select correct nametable for bit 0
  STA $2000
  
   
	jsr famistudio_update
	
	jsr Animation::Update
	jsr UpdateButtons
	jsr Game::Update
	jsr Player::updatePlayer
	jsr Obsticles::Update
	
	
	@end:
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



Draw_New_Collumn:
	lda scroll
	lsr A
	lsr A
	lsr A
	sta column_LO

	lda nametable
	eor #$01
	asl A
	asl A
	clc 
	adc #$20
	sta column_HI
	
	 
	lda scroll_HI
	asl 
	asl	
	sta new_background_HI

	lda column_number
	and #%00011111
	sta new_background_LO

	lda new_background_LO
	clc 
	adc #<Longer_street
	sta new_background_LO

	lda new_background_HI
	adc #>Longer_street
	sta new_background_HI

	LDA column_LO
	CLC
	ADC #$80
	STA column_LO
	LDA column_HI
	ADC #$00
	STA column_HI 

	lda #%00000100
	sta $2000
	lda $2002
	lda column_HI
	sta $2006
	lda column_LO
	sta $2006

	ldx #$1A
	ldy #$80

	@loop:
		lda (new_background_LO),Y
		sta $2007
		
		lda new_background_LO
		clc
		adc #$20
		sta new_background_LO
		lda new_background_HI
		adc #$0
		sta new_background_HI


		dex
		bne @loop

  rts

DrawNewAttributes:
	LDA nametable
	EOR #$01          ; invert low bit, A = $00 or $01
	ASL A             ; shift up, A = $00 or $02
	ASL A             ; $00 or $04
	CLC
	ADC #$23          ; add high byte of attribute base address ($23C0)
	STA column_HI    ; now address = $23 or $27 for nametable 0 or 1
	
	LDA scroll
	LSR A
	LSR A
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$C8
	STA column_LO    ; attribute base + scroll / 32


	lda scroll_HI
	asl 
	asl	
	sta new_background_HI

	lda column_number
	and #%00011111
	lsr A
	lsr A
	sta new_background_LO


	LDA new_background_LO       ; column data start + offset = address to load column data from
	CLC 
	ADC #<Longer_street
	STA new_background_LO
	LDA new_background_HI
	ADC #>Longer_street
	STA new_background_HI

	lda new_background_LO
	clc
	adc #$C0
	sta new_background_LO

	lda new_background_HI
	adc #$03
	sta new_background_HI


	LDY #$08
	LDA $2002             ; read PPU status to reset the high/low latch
	DrawNewAttributesLoop:
		LDA column_HI
		STA $2006             ; write the high byte of column address
		LDA column_LO
		STA $2006             ; write the low byte of column address
		LDA (new_background_LO), y    ; copy new attribute byte
		STA $2007
		tya
		clc
		adc #$08
		tay
		; INY
		CPY #$40           ; copy 8 attribute bytes
		BEQ DrawNewAttributesLoopDone 
		
		LDA column_LO         ; next attribute byte is at address + 8
		CLC
		ADC #$08
		STA column_LO
		JMP DrawNewAttributesLoop
		DrawNewAttributesLoopDone:

rts
;;;;;;;;;;;;;;  



palette:



.byte $2d,$3d,$38,$00
.byte $2d,$12,$22,$32
.byte $2d,$16,$26,$36
.byte $2d,$14,$24,$34



.byte $0f,$0f,$30,$27
.byte $0f,$0f,$38,$31
.byte $0f,$0f,$00,$20
.byte $0f,$00,$37,$02






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

.include "../graphics/Longer_street.s"

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

	