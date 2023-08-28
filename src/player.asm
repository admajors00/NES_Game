sprites:
	;vert tile attr horiz
	.byte $C0, $A0, $00, $80 ;sprite 0
	.byte $C0, $A1, $00, $88 ;sprite 1
	.byte $C8, $A2, $00, $80 ;sprite 2
	.byte $C8, $A3, $00, $88 ;sprite 3

	; .byte $B0, $40, $01, $B0 ;sprite 0
	; .byte $B0, $41, $01, $B8 ;sprite 1
	; .byte $B8, $42, $01, $B0 ;sprite 2
	; .byte $B8, $43, $01, $B8 ;sprite 3

	; .byte $B0, $60, $01, $A0 ;sprite 0
	; .byte $B0, $61, $01, $A8 ;sprite 1
	; .byte $B8, $62, $01, $A0 ;sprite 2
	; .byte $B8, $63, $01, $A8 ;sprite 3

; OAM address ($2003) > write / OAM data ($2004) > write
; Set the "sprite" address using OAMADDR ($2003)
; Then write the following bytes via OAMDATA ($2004)
OAM_ADDR  = $2003
OAM_DATA	= $2004
OAM_DMA   = $4014

; - Byte 0 (Y Position)
OAM_Y    = 0

; - Byte 1 (Tile Index)
;
; 76543210
; ||||||||
; |||||||+- Bank ($0000 or $1000) of tiles
; +++++++-- Tile number of top of sprite (0 to 254; bottom half gets the next tile)
OAM_TILE = 1

; - Byte 2 (Attributes)
;
; 76543210
; ||||||||
; ||||||++- Palette (4 to 7) of sprite
; |||+++--- Unimplemented
; ||+------ Priority (0: in front of background; 1: behind background)
; |+------- Flip sprite horizontally
; +-------- Flip sprite vertically
OAM_ATTR = 2

; - Byte 3 (X Position)
OAM_X    = 3

.scope Sprite

	egg:
		.byte	$24, $25, $26, $27
	cat:
		.byte  	$C0, $C1, $C2, $C3
		.byte  	$C4, $C5, $C6, $C7
		.byte  	$C8, $C9, $CA, $CB
		.byte  	$CC, $CD, $CE, $CF

	look_up_table:
		.byte $C0, $C4, $C8, $CC

.endscope

.scope Player
	sprite_pos_x = $10
	sprite_pos_y = $11
	sprite_direction = $18
	character_velocity_x = $13
	character_velocity_y = $14
	sprite_animation_timer = $15
	sprite_animation_frame = $16
	player_state = $17

	.enum PlayerStates
		moving = 0
		idle = 1
	.endenum

	.enum Directions
		left = %10111111 ; $bf
		right = %01000000 ; $40
	.endenum

	init_character:
		ldx #$00
		stx character_velocity_x
		stx character_velocity_y
		stx sprite_animation_frame

		ldx #$80
		stx sprite_pos_x
		ldx #$C0
		stx sprite_pos_y

		ldx #5
		stx sprite_animation_timer

	
		

		ldx #PlayerStates::idle
		stx player_state

		ldx #Directions::left
		stx sprite_direction 


	rts


	moveCharacter:
		lda #BUTTON_LEFT
		and Port_1_Pressed_Buttons
		bne @right

		lda #BUTTON_RIGHT
		and Port_1_Pressed_Buttons
		bne @left

		ldx #PlayerStates::idle
		stx player_state
		jmp @end

		@left:
			ldx #PlayerStates::moving
			stx player_state

			ldx #Directions::left
			stx sprite_direction

			lda sprite_pos_x
			cmp #$E0
			bne @moveSpriteLeft
			INC scroll
			jsr Scroll
			jmp @end
		@moveSpriteLeft:
			ldx sprite_pos_x
			inx
			beq @end ;if position is 0 do not move 
			stx sprite_pos_x
			jmp @end
		@right:
			ldx #PlayerStates::moving
			stx player_state

			ldx #Directions::right
			stx sprite_direction

			lda sprite_pos_x
			cmp #$10
			bne @moveSpriteRight
			DEC scroll
			jsr Scroll
			jmp @end
		@moveSpriteRight:
			ldx sprite_pos_x
			dex
			beq @end
			stx sprite_pos_x
			jmp @end

		@end:


			
		rts
	
	update_sprite_frame:
		lda player_state
		cmp #PlayerStates::idle
		beq @done
		dec sprite_animation_timer
		beq @changeSprite
		jmp	@put_in_OAM
		@changeSprite:
			ldx #10
			stx sprite_animation_timer

			inc sprite_animation_frame
			lda sprite_animation_frame
			cmp #$04 ;if frame 0
			beq @reset_frame ;set to fram 1
			jmp @put_in_OAM

			@reset_frame:  ;selse set to frame 0
				lda #$00
				sta sprite_animation_frame
				jmp	@put_in_OAM
			

		@put_in_OAM:
			ldx sprite_animation_frame
			lda Sprite::look_up_table, x
			
			tax
			stx $200 + OAM_TILE
			inx
			stx $204 + OAM_TILE
			inx
			stx $208 + OAM_TILE
			inx
			stx $20C + OAM_TILE
			
		@done:
			rts

	update_sprite_pos:
		lda sprite_direction
		cmp #Directions::left
		beq @left
		@right:
			
			lda $200 + OAM_ATTR
			ora sprite_direction ;reset mirror bit for sprite
			sta $200 + OAM_ATTR

			lda $204 + OAM_ATTR
			ora sprite_direction
			sta $204 + OAM_ATTR

			lda $208 + OAM_ATTR
			ora sprite_direction
			sta $208 + OAM_ATTR

			lda $20C + OAM_ATTR
			ora sprite_direction
			sta $20C + OAM_ATTR

		
			ldy sprite_pos_x
			lda sprite_pos_x
			clc
			adc #$07
			tax 


			jmp @done
		@left:
			

			lda $200 + OAM_ATTR
			and sprite_direction ;reset mirror bit for sprite
			sta $200 + OAM_ATTR

			lda $204 + OAM_ATTR
			and sprite_direction
			sta $204 + OAM_ATTR

			lda $208 + OAM_ATTR
			and sprite_direction
			sta $208 + OAM_ATTR

			lda $20C + OAM_ATTR
			and sprite_direction
			sta $20C + OAM_ATTR

			ldx sprite_pos_x
			lda sprite_pos_x
			clc
			adc #$07
			tay 
			jmp @done
		@done:
			stx	$200 + OAM_X		; store sprite position
			sty $204 + OAM_X  ; add offset for other sprites
			stx	$208 + OAM_X
			sty $20C + OAM_X

			
	

		rts
.endscope

