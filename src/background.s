


Handle_Scroll:
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