 .include "/inc/animations.inc"
.include "/inc/obsticles.inc"
.include "/inc/backgrounds.inc"
.include "/inc/Levels.inc"
.segment "CODE"
scroll_HI_prev = $30
bg_data_pt_LO = $31
bg_data_pt_HI = $32


level_bg_header_pt_LO = $33
level_bg_header_pt_HI = $34



nametable = $35

column_LO = $36
column_HI = $37

new_background_LO = $38
new_background_HI = $39

column_number = $3A

scroll_flags = $3B
bg_header_pt_LO = $3C
bg_header_pt_HI = $3D

scroll =$3e
scroll_HI = $3f


NEW_COLUMN_FLAG = 1<<0
NEW_ATTRIBUTE_FLAG = 1<<1
STATUS_BAR_FLAG = 1<<2
USE_RANDOM_BACKGROUND = 1<<3



.scope Background

	Init:
		lda #2
		sta scroll_HI_prev
		ldy #0 
		sty scroll_HI
		sty scroll
		sty nametable
		sty amount_to_scroll
		sty column_number
			
		jsr Next_Background
		jsr Background::load_background_nt1

		
		jsr Reset_Buffers
		lda #2
		sta scroll_HI_prev
		ldy #1
		sty scroll_HI
	
	
		jsr Next_Background
		jsr Draw_New_Collumn_To_Buffer
		jsr Draw_New_Attributes_To_Buffer
		lda #NEW_COLUMN_FLAG
		ora scroll_flags
		sta scroll_flags
		lda #NEW_ATTRIBUTE_FLAG
		ora scroll_flags
		sta scroll_flags
		
		
	rts

	Update:
		ldx amount_to_scroll
		beq scroll_done
		loop_1:
			lda scroll
			clc
			adc#$01
			sta scroll
			bcc @skip
			
				lda scroll_HI
				adc #0

				sta scroll_HI
			
				lda scroll_flags
				and #USE_RANDOM_BACKGROUND
				beq @continue
					jsr prng
					and #%00000111
					sta scroll_HI
			@skip:

				
			@continue:
			jsr Next_Background
			jsr Scroll
			New_Column_Check:
				LDA scroll
				and #%00000111
				bne @New_Column_Check_done
				
				
					lda column_number
					clc
					adc #$01
					and #%01111111
					sta column_number
					
					jsr Draw_New_Collumn_To_Buffer
					lda #NEW_COLUMN_FLAG
					ora scroll_flags
					sta scroll_flags

				
					LDA scroll
					AND #%00011111            ; check for multiple of 32
					Bne @New_Column_Check_done    ; if low 5 bits = 0, time to write new attribute bytes

						jsr Draw_New_Attributes_To_Buffer
						lda #NEW_ATTRIBUTE_FLAG
						ora scroll_flags
						sta scroll_flags
				@New_Column_Check_done:


			dec amount_to_scroll
			bne loop_1
			jmp scroll_done

		scroll_done:

	rts

	;inputs  x level header pt lo, y level header pt hi
	;drawing should be stopped before calling
	Load_Level_Background_Data:
		stx main_pointer_LO
		sty main_pointer_HI

		ldy #Level_t::bg_color
		lda (main_pointer_LO), y
		sta main_temp

		ldy #Level_t::bank_num
		lda (main_pointer_LO), y
		jsr BankSwitch

		

		ldy #Level_t::backgrounds_pt
		lda (main_pointer_LO), y
		sta level_bg_header_pt_LO
		iny
		lda (main_pointer_LO), y
		sta level_bg_header_pt_HI

		ldy #Level_t::pallet_table_pt
		lda (main_pointer_LO), y
		tax
		iny
		lda (main_pointer_LO), y
		tay 
		jsr load_palettes

		lda #$3f
		sta $2006
		lda #$00
		sta $2006
		lda main_temp
		sta $2007

		
		
	rts

	Next_Background: ;update bg header and bg data pointers
		
		lda scroll_HI
		cmp scroll_HI_prev ;check that scroll high has changed
		beq @done
			sta scroll_HI_prev

				lda scroll_HI
				asl A
				tay

			@check_random_done:
			lda (level_bg_header_pt_LO),y ;get bg header at the index of scroll hi
			sta bg_header_pt_LO
			iny
			lda (level_bg_header_pt_LO),y
			sta bg_header_pt_HI


			ldy #Background_t::background_data ;get the background data
			lda (bg_header_pt_LO), Y
			sta bg_data_pt_LO
			iny
			lda (bg_header_pt_LO), Y
			sta bg_data_pt_HI

			ldy #Background_t::num_obsticles
			lda (bg_header_pt_LO), Y ;if num obsticles == 0 jump to done
			beq @done
			

	

			ldy #Background_t::obsticle_list
			lda (bg_header_pt_LO), y ;get first item from obsticle list
			sta main_pointer_LO
			iny
			lda (bg_header_pt_LO ), y 
			sta main_pointer_HI

			ldx main_pointer_LO
			ldy main_pointer_HI		
			jsr Obsticles::Load 

		@done:
		
	rts
	
	load_background_nt1: ;rendering should be stopped before calling this function
		LDA $2002             ; read PPU status to reset the high/low latch
		LDA #$20
		STA $2006             ; write the high byte of $2000 address
		LDA #$00
		STA $2006             ; write the low byte of $2000 address


		LDX #$00            ; start at pointer + 0
		LDY #$00
		@OutsideLoop:
			
			@InsideLoop:
				LDA (bg_data_pt_LO), y  ; copy one background byte from address in pointer plus Y
				STA $2007           ; this runs 256 * 4 times		
				INY                 ; inside loop counter
				CPY #$00
				BNE @InsideLoop      ; run the inside loop 256 times before continuing down
			
			INC bg_data_pt_HI       ; low byte went 0 to 256, so high byte needs to be changed now
			INX
			CPX #$04
			BNE @OutsideLoop     ; run the outside loop 256 times before continuing down
	rts
		


		
	load_background_nt2: ;rendering should be stopped before calling this function
		LDA $2002             ; read PPU status to reset the high/low latch
		LDA #$24
		STA $2006             ; write the high byte of $2000 address
		LDA #$00
		STA $2006             ; write the low byte of $2000 address


		LDX #$04            ; start at pointer + 0
		LDY #$00
		@OutsideLoop:
			
			@InsideLoop:
				LDA (bg_data_pt_LO), y  ; copy one background byte from address in pointer plus Y
				STA $2007           ; this runs 256 * 4 times		
				INY                 ; inside loop counter
				CPY #$00
				BNE @InsideLoop      ; run the inside loop 256 times before continuing down
			
			INC bg_data_pt_HI       ; low byte went 0 to 256, so high byte needs to be changed now
			INX
			CPX #$08
			BNE @OutsideLoop     ; run the outside loop 256 times before continuing down
	rts
	Update_Background_Obsticles:
		lda scroll_HI
		asl A
		tay
		lda (level_bg_header_pt_LO),y
		sta bg_header_pt_LO
		iny
		lda (level_bg_header_pt_LO),y
		sta bg_header_pt_HI
	rts

	Reset_Buffers:
		ldy #32

		lda #0
		@loop:
		sta Attribute_Buffer, y 
		sta Scroll_Buffer, Y
		dey
		beq @loop


	rts


.endscope
;inputs x lo pt, y hi pt
load_palettes:
		stx main_pointer_LO
		sty main_pointer_HI
		lda	$2002		; read PPU status to reset the high/low latch
		lda	#$3f
		sta	$2006
		lda	#$00
		sta	$2006
		ldy	#$00
	@loop:
		lda	(main_pointer_LO), y	; load palette byte
		sta	$2007		; write to PPU
		iny			; set index to next byte
		cpy	#$20
		bne	@loop		; if x = $20, 32 bytes copied, all done

rts

Handle_Scroll:
    
   
    LDA #NEW_COLUMN_FLAG
    and scroll_flags
    beq @New_Column_Check_done
            
        jsr Draw_New_Collumn_From_Buffer
    
        LDA #NEW_ATTRIBUTE_FLAG   
        AND scroll_flags       ; check for multiple of 32
        Beq @New_Column_Check_done    ; if low 5 bits = 0, time to write new attribute bytes

        jsr Draw_New_Attributes_From_Buffer

    @New_Column_Check_done:
        lda scroll_flags
        and #<~NEW_ATTRIBUTE_FLAG
		and #<~NEW_COLUMN_FLAG

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
	LDA bg_chr_rom_start_addr  ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
	
    ;	ORA nametable    ; select correct nametable for bit 0
	STA $2000

	lda bg_sprite_on_off   ; enable sprites, enable background, no clipping on left side
	STA $2001	  

	LDA #STATUS_BAR_FLAG
	and	scroll_flags
	beq skip_statusbar
    WaitNotSprite0:
        lda $2002
        and #%01000000
        bne WaitNotSprite0   ; wait until sprite 0 not hit

    WaitSprite0:
        lda $2002
        and #%01000000
        beq WaitSprite0      ; wait until sprite 0 is hit

    ldx #$20
    WaitScanline:
        dex
        bne WaitScanline
	skip_statusbar:
    ; now set the scroll and nametable to use for the rest of the screen down
  
    LDA scroll
    STA $2005        ; write the horizontal scroll count register

    LDA #$00         ; no vertical scrolling
    STA $2005
        
    LDA bg_chr_rom_start_addr  ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
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


	LDA $2002             ; read PPU status to reset the high/low latch
	@loop:
		LDA (new_background_LO), y    ; copy new attribute byte
		sta Attribute_Buffer, y
		tya
		clc
		adc #$08
		tay
		; INY
		CPY #$40           ; copy 8 attribute bytes
		BEQ @done 
		
		JMP @loop
		@done:

rts

Draw_New_Attributes_From_Buffer:
	LDA nametable
	EOR #$01          ; invert low bit, A = $00 or $01
	ASL A             ; shift up, A = $00 or $02
	ASL A             ; $00 or $04
	CLC
	ADC #$23          ; add high byte of attribute base address ($23C0)
	STA column_HI    ; now address = $23 or $27 for nametable 0 or 1
	
	

	lda #STATUS_BAR_FLAG
	and scroll_flags
	bne @add_status_bar_offset
		LDA scroll
		LSR A
		LSR A
		LSR A
		LSR A
		LSR A
		CLC
		ADC #$c0	;attribute table start adress offset
		STA column_LO    ; attribute base + scroll / 32

		LDY #$00
		jmp @add_status_bar_offset_done
	@add_status_bar_offset:
		LDA scroll
		LSR A
		LSR A
		LSR A
		LSR A
		LSR A
		CLC
		ADC #$c8	;attribute table start adress offset
		STA column_LO    ; attribute base + scroll / 32

		LDY #$08
	@add_status_bar_offset_done:
	LDA $2002             ; read PPU status to reset the high/low latch
	@loop:
		LDA column_HI
		STA $2006             ; write the high byte of column address
		LDA column_LO
		STA $2006             ; write the low byte of column address
		LDA Attribute_Buffer, y    ; copy new attribute byte
		STA $2007
		tya
		clc
		adc #$08
		tay
		; INY
		CPY #$40           ; copy 8 attribute bytes
		BEQ @done 
		
		LDA column_LO         ; next attribute byte is at address + 8
		CLC
		ADC #$08
		STA column_LO
		JMP @loop
		@done:

rts


Draw_New_Collumn_To_Buffer:
	
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
		ldx #$1e ;buffer start addr offset for status bar
		ldy #$00	;acreen new bg start addr offset for status bar
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

Draw_New_Collumn_From_Buffer:
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
	

	

	lda #STATUS_BAR_FLAG
	and scroll_flags
	bne @add_status_bar_offset
		ldx #$1E ;buffer start addr offset for status bar
		jmp @add_status_bar_offset_done
	@add_status_bar_offset:
		
	
		LDA column_LO
		CLC
		ADC #$C0 ;nametable start addr offset for status bar
		STA column_LO
		LDA column_HI
		ADC #$00
		STA column_HI 
		ldx #$18;buffer start addr offset for status bar
	@add_status_bar_offset_done:
	

	lda #%00000100
	sta $2000
	lda $2002
	lda column_HI
	sta $2006
	lda column_LO
	sta $2006
	@loop:
		lda Scroll_Buffer,x
		sta $2007
        dex
		bne @loop

  rts