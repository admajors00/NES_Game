 .include "/inc/animations.inc"
.include "/inc/obsticles.inc"
.include "/inc/backgrounds.inc"
 
.segment "CODE"
scroll_HI_prev = $30
bg_data_pt_LO = $31
bg_data_pt_HI = $32


obst_header_pt_LO = $33
obst_header_pt_HI = $34



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


NEW_COLUMN_FLAG = %00000001
NEW_ATTRIBUTE_FLAG = %00000010





.scope Background

Init:

    lda #<Backgrounds_Array
    sta bg_header_pt_LO
    lda #>Backgrounds_Array
    sta bg_header_pt_HI

    ldy #0
    lda #<Background_1
    sta (bg_header_pt_LO),Y
    iny 
    lda #>Background_1
    sta (bg_header_pt_LO),Y

    iny
    lda #<Background_2
    sta (bg_header_pt_LO),Y
    iny 
    lda #>Background_2
    sta (bg_header_pt_LO),Y

    iny
    lda #<Background_3
    sta (bg_header_pt_LO),Y
    iny 
    lda #>Background_3
    sta (bg_header_pt_LO),Y

	    iny
    lda #<Background_4
    sta (bg_header_pt_LO),Y
    iny 
    lda #>Background_4
    sta (bg_header_pt_LO),Y

    LDA #<Longer_street_2
	STA bg_data_pt_LO           ; put the low byte of address of background into pointer
	LDA #>Longer_street_2       ; #> is the same as HIGH() function in NESASM, used to get the high byte
	STA bg_data_pt_HI    

    ; ldy #0
    ; lda Backgrounds_Array, y
    ; sta bg_header_pt_LO
    ; iny
    ; lda Backgrounds_Array,y
    ; sta bg_header_pt_HI

    lda #1
    sta scroll_HI_prev


rts

Update:
    
   
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
		cmp #NUM_BACKGROUNDS	
		bcc @continue
			lda #0
			sta scroll_HI
            
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

Next_Background:
    
    lda scroll_HI
    cmp scroll_HI_prev
    beq @done
        sta scroll_HI_prev
      ;  jsr Update_Background_Obsticles

        lda scroll_HI
        asl A
        tay

        lda Backgrounds_Array,y
        sta bg_header_pt_LO
        iny
        lda Backgrounds_Array, y
        sta bg_header_pt_HI


        ldy #Background_t::background_data
        lda (bg_header_pt_LO), Y
        sta bg_data_pt_LO
        iny
        lda (bg_header_pt_LO), Y
        sta bg_data_pt_HI

        ldy #Background_t::num_obsticles
        lda (bg_header_pt_LO), Y ;if num obsticles == 0 jump to done
        beq @remove_obsticles
        

        lda #1
        sta active_flag

        ldy #Background_t::obsticle_list
        lda (bg_header_pt_LO), y ;get first item from obsticle list
        sta obst_header_pt_LO
        iny
        lda (bg_header_pt_LO ), y 
        sta obst_header_pt_HI

        ldx obst_header_pt_HI
        ldy obst_header_pt_LO

        jsr Obsticles::Load 


        ldy #Obstical_t::animation_header_addr ; load the animation 
        iny 
        lda (obst_header_pt_LO), Y
        tax
        dey
        lda (obst_header_pt_LO ), Y
        tay


        jsr Animation::Load_Animation
        jmp @done

        @remove_obsticles:
            lda #0
            sta active_flag
            ldx #>Empty_Ani_Header
            ldy #<Empty_Ani_Header
            jsr Animation::Load_Animation
            jmp @done

    @done:
    
    
rts


Update_Background_Obsticles:
    lda scroll_HI
    asl A
    tay
    lda Backgrounds_Array,y
    sta bg_header_pt_LO
    iny
    lda Backgrounds_Array,y
    sta bg_header_pt_HI
rts
.endscope





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
        lda #0
        sta scroll_flags

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


	LDY #$08
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
	
	LDA scroll
	LSR A
	LSR A
	LSR A
	LSR A
	LSR A
	CLC
	ADC #$C8
	STA column_LO    ; attribute base + scroll / 32



	LDY #$08
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


	ldx #$1A
	ldy #$80

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
		lda Scroll_Buffer,x
		sta $2007
        dex
		bne @loop

  rts