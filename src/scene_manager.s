 .include "/inc/animations.inc"
.include "/inc/obsticles.inc"

.include "/inc/scenes.inc"
.include "/inc/scene_manager.inc"
.include "/inc/Levels.inc"


.segment "CODE"




.scope ScManager


	Init:
		jsr BgManager::RLE::Reset_RLE_Variables
		lda #2
		sta scroll_HI_prev
		ldy #0 
		sty scroll_HI
		sty scroll
		sty nametable
		sty amount_to_scroll
		sty column_number
			
		jsr Next_Scene
		jsr BgManager::RLE::Load_RLE_Background
		ldx #$00
		jsr BgManager::RLE::Decode_RLE_Background_Attribute_Table_Into_PPU
		
		jsr Reset_Buffers
		lda #2
		sta scroll_HI_prev
		ldy #1
		sty scroll_HI
	
		jsr Next_Scene
		jsr BgManager::RLE::Reset_RLE_Variables
		jsr BgManager::RLE::Decode_RLE_Background_Column_Into_Buffer
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
			; increment scroll value
			lda scroll
			clc
			adc #$01
			sta scroll
			; if scroll overflowed 
			bcc @skip
				lda scroll_HI
				adc #0

				sta scroll_HI
			
				lda scroll_flags
				and #USE_RANDOM_BACKGROUND
				beq @continue
					jsr LoadRandNumIntoAcc
					and #%00000111
					sta scroll_HI
			@skip:

			@continue:
			jsr Next_Scene
			jsr BgManager::Scroll
			New_Column_Check:
				LDA scroll
				and #%00000111
				bne @New_Column_Check_done
				
				
					lda column_number
					clc
					adc #$01
					and #%01111111
					sta column_number
					
					jsr BgManager::RLE::Decode_RLE_Background_Column_Into_Buffer
					lda #NEW_COLUMN_FLAG
					ora scroll_flags
					sta scroll_flags

				
					LDA scroll
					AND #%00011111            ; check for multiple of 32
					Bne @New_Column_Check_done    ; if low 5 bits = 0, time to write new attribute bytes
						;jsr Draw_New_Attributes_To_Buffer
						lda #NEW_ATTRIBUTE_FLAG
						ora scroll_flags
						sta scroll_flags

				@New_Column_Check_done:

			dec amount_to_scroll
			bne loop_1

		scroll_done:

	rts

	;inputs  x level header pt lo, y level header pt hi
	;drawing should be stopped before calling
	Load_Level_Data:
		stx main_pointer_LO
		sty main_pointer_HI

		ldy #Level_t::bg_color
		lda (main_pointer_LO), y
		sta main_temp

		ldy #Level_t::bank_num
		lda (main_pointer_LO), y
		jsr BankSwitch

		

		ldy #Level_t::scene_array_pt
		lda (main_pointer_LO), y
		sta level_sc_array_pt_LO
		iny
		lda (main_pointer_LO), y
		sta level_sc_array_pt_HI

		ldy #Level_t::pallet_table_pt
		lda (main_pointer_LO), y
		tax
		iny
		lda (main_pointer_LO), y
		tay 
		jsr load_palettes

		lda #$3f
		sta PpuAddr
		lda #$00
		sta PpuAddr
		lda main_temp
		sta PpuData
		

		
		
	rts

	Next_Scene: ;update bg header and bg data pointers
		
		lda scroll_HI
		cmp scroll_HI_prev ;check that scroll high has changed
		beq @done
			sta scroll_HI_prev

			lda scroll_HI
			asl A
			tay
			lda #NEW_BG_FLAG
			ora scroll_flags
			sta scroll_flags
			@check_random_done:
			lda (level_sc_array_pt_LO),y ;get bg header at the index of scroll hi
			sta curr_sc_pt_LO
			iny
			lda (level_sc_array_pt_LO),y
			sta curr_sc_pt_HI

			; get the background data
			ldy #Scene_t::background_data 
			lda (curr_sc_pt_LO), Y
			sta bg_data_pt_LO
			iny
			lda (curr_sc_pt_LO), Y
			sta bg_data_pt_HI

			; Get the attribute data
			ldy #Scene_t::attribute_data 
			lda (curr_sc_pt_LO), Y
			sta at_data_pt_LO
			iny
			lda (curr_sc_pt_LO), Y
			sta at_data_pt_HI

			ldy #Scene_t::num_obsticles
			lda (curr_sc_pt_LO), Y ;if num obsticles == 0 jump to done
			beq @done
			
			ldy #Scene_t::obsticle_list
			lda (curr_sc_pt_LO), y ;get first item from obsticle list
			sta main_pointer_LO
			iny
			lda (curr_sc_pt_LO ), y 
			sta main_pointer_HI

			ldx main_pointer_LO
			ldy main_pointer_HI		
			jsr Obsticles::Load 
		@done:
		
	rts
	

		


		
	
	Update_Scene_Obsticles:
		lda scroll_HI
		asl A
		tay
		lda (level_sc_array_pt_LO),y
		sta curr_sc_pt_LO
		iny
		lda (level_sc_array_pt_LO),y
		sta curr_sc_pt_HI
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
		lda	PpuStatus		; read PPU status to reset the high/low latch
		lda	#$3f
		sta	PpuAddr
		lda	#$00
		sta	PpuAddr
		ldy	#$00
	@loop:
		lda	(main_pointer_LO), y	; load palette byte
		sta	PpuData		; write to PPU
		iny			; set index to next byte
		cpy	#$20
		bne	@loop		; if x = $20, 32 bytes copied, all done

rts










