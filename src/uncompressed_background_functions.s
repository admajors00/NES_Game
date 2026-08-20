.segment "CODE"



load_background_nt1: ;rendering should be stopped before calling this function
	LDA PpuStatus             ; read PPU status to reset the high/low latch
	LDA #$20
	STA PpuAddr             ; write the high byte of $2000 address
	LDA #$00
	STA PpuAddr             ; write the low byte of $2000 address
	
	LDX #$00            ; start at pointer + 0
	LDY #$00

	@OutsideLoop:
		@InsideLoop:
			LDA (bg_data_pt_LO), y  ; copy one background byte from address in pointer plus Y
			STA PpuData           ; this runs 256 * 4 times		
			INY                 ; inside loop counter
			CPY #$00
			BNE @InsideLoop      ; run the inside loop 256 times before continuing down
		
		INC bg_data_pt_HI       ; low byte went 0 to 256, so high byte needs to be changed now
		INX
		CPX #$04
		BNE @OutsideLoop     ; run the outside loop 256 times before continuing down
rts



load_background_nt2: ;rendering should be stopped before calling this function
	LDA PpuStatus             ; read PPU status to reset the high/low latch
	LDA #$24
	STA PpuAddr             ; write the high byte of $2000 address
	LDA #$00
	STA PpuAddr             ; write the low byte of $2000 address

	LDX #$04            ; start at pointer + 0
	LDY #$00
	@OutsideLoop:
		
		@InsideLoop:
			LDA (bg_data_pt_LO), y  ; copy one background byte from address in pointer plus Y
			STA PpuData           ; this runs 256 * 4 times		
			INY                 ; inside loop counter
			CPY #$00
			BNE @InsideLoop      ; run the inside loop 256 times before continuing down
		
		INC bg_data_pt_HI       ; low byte went 0 to 256, so high byte needs to be changed now
		INX
		CPX #$08
		BNE @OutsideLoop     ; run the outside loop 256 times before continuing down
rts



Draw_New_Column_To_Buffer:
	lda #0 
	sta new_background_HI

	lda column_number
	and #%00011111
	clc 
	adc bg_data_pt_LO
	sta new_background_LO

	lda bg_data_pt_HI
	adc #0
	sta new_background_HI

	lda #STATUS_BAR_FLAG
	and scroll_flags
	bne @add_status_bar_offset
		ldx #$1e   
		ldy #$00	
		jmp @add_status_bar_offset_done
	@add_status_bar_offset:
		ldx #$18
		ldy #$C0	;acreen new bg start addr offset for status bar
	@add_status_bar_offset_done:

	@loop:
		lda (new_background_LO),Y
		sta Scroll_Buffer, x
		
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



Draw_New_Attributes_To_Buffer:
    lda #0 
	sta new_background_HI

	lda column_number
	and #%00011111
	lsr A
	lsr A
	CLC 
	ADC bg_data_pt_LO
	STA new_background_LO
	LDA bg_data_pt_HI
	ADC #0
	STA new_background_HI

	lda new_background_LO
	clc
	adc #$C0
	sta new_background_LO

	lda new_background_HI
	adc #$03
	sta new_background_HI
	
	lda #STATUS_BAR_FLAG
	and scroll_flags
	bne @add_status_bar_offset
		LDY #$00
		jmp @add_status_bar_offset_done

	@add_status_bar_offset:
		LDY #$08
	@add_status_bar_offset_done:

	LDA PpuStatus             ; read PPU status to reset the high/low latch
	@loop:
		LDA (new_background_LO), y    ; copy new attribute byte
		sta Attribute_Buffer, y
		tya
		clc
		adc #$08
		tay
		; INY
		CPY #$40           ; copy 8 attribute bytes
		BNE @loop 
		@done:
rts