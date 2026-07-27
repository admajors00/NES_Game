;;;;;;;;;;;;;;;;

.segment "CODE"

.scope BgManager

.include "inc/background_manager.inc"
.include "compressed_background_functions.s"
.include "uncompressed_background_functions.s"

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
		ldx #$1E
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
	sta PpuCtrl
	lda PpuStatus
	lda column_HI
	sta PpuAddr
	lda column_LO
	sta PpuAddr
	@loop:
		lda Scroll_Buffer,x
		sta PpuData
        dex
		bne @loop

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
	LDA PpuStatus             ; read PPU status to reset the high/low latch
	@loop:
		LDA column_HI
		STA PpuAddr             ; write the high byte of column address
		LDA column_LO
		STA PpuAddr             ; write the low byte of column address
		LDA Attribute_Buffer, y    ; copy new attribute byte
		STA PpuData
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






Handle_Scroll:
    
   
    LDA #NEW_COLUMN_FLAG
    and scroll_flags
    beq @update_att
            
    	jsr Draw_New_Collumn_From_Buffer
		lda #<~NEW_COLUMN_FLAG
		and scroll_flags
		sta scroll_flags
	@update_att:
	
	lda scroll_flags
	and #NEW_BG_FLAG
	beq @New_Column_Check_done
		lda nametable
		eor #1
		tax
		jsr RLE::Decode_RLE_Background_Attribute_Table_Into_PPU
		lda #<~NEW_BG_FLAG
		and scroll_flags
		sta scroll_flags


    @New_Column_Check_done:
       

	lda	#$00		; set the low byte (00) of the RAM address
	sta	OamAddr
	lda	#$02		; set the high byte (02) of the RAM address 
	sta	OamDma		; start the transfer
	LDA #$00
	STA PpuAddr     ; clean up PPU address registers
	STA PpuAddr

	LDA #$00
	STA PpuScroll        ; write the horizontal scroll count register        ; no vertical scrolling
	STA PpuScroll

	;;This is the PPU clean up section, so rendering the next frame starts properly.
	LDA bg_chr_rom_start_addr  ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
	
    ;	ORA nametable    ; select correct nametable for bit 0
	STA PpuCtrl

	lda bg_sprite_on_off   ; enable sprites, enable background, no clipping on left side
	STA PpuMask	  

	LDA #STATUS_BAR_FLAG
	and	scroll_flags
	beq skip_statusbar
    WaitNotSprite0:
        lda PpuStatus
        and #%01000000
        bne WaitNotSprite0   ; wait until sprite 0 not hit

    WaitSprite0:
        lda PpuStatus
        and #%01000000
        beq WaitSprite0      ; wait until sprite 0 is hit

    ldx #$20
    WaitScanline:
        dex
        bne WaitScanline
	skip_statusbar:
    ; now set the scroll and nametable to use for the rest of the screen down
  
    LDA scroll
    STA PpuScroll        ; write the horizontal scroll count register

    LDA #$00         ; no vertical scrolling
    STA PpuScroll
        
    LDA bg_chr_rom_start_addr  ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    ORA nametable    ; select correct nametable for bit 0
    STA PpuCtrl

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


.endscope