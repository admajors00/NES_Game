
.include "game.asm"
sprites:
	;vert tile attr horiz
	.byte $94, $C0, $00, $80 ;sprite 0
	.byte $94, $C1, $00, $88 ;sprite 1
	.byte $9B, $C2, $00, $80 ;sprite 2
	.byte $9B, $C3, $00, $88 ;sprite 3

	.byte $B7, $24, $00, $80 ;sprite 0
	.byte $B7, $25, $00, $88 ;sprite 1
	.byte $C0, $26, $00, $80 ;sprite 2
	.byte $C0, $27, $00, $88 ;sprite 3

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
		.byte	$28, $29, $2A, $2B
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
	sprite_direction = $12
	sprite_animation_timer = $13
	sprite_animation_frame = $14	
	player_state = $15
	egg_animation_frame = $16

	player_pos_x_LOW = $17
	player_pos_x_HIGH = $18
	player_pos_y_LOW = $19
	player_pos_y_HIGH = $1A

	character_velocity_x_LOW = $1B
	character_velocity_x_HIGH = $1C
	character_velocity_y_LOW = $1D
	character_velocity_y_HIGH = $1E
	.enum PlayerStates
		moving = 0
		idle = 1
		pushing = 2
		airborne = 3
	.endenum

	.enum Directions
		left =  %10111111 ; $bf
		right = %01000000 ; $40
	.endenum



	init_character:
		ldx #$00
		
		stx character_velocity_y_HIGH
		stx sprite_animation_frame
		stx egg_animation_frame
		stx player_pos_x_LOW
		stx player_pos_y_LOW

		ldx #$01
		stx character_velocity_x_LOW
		ldx #$10
		stx sprite_pos_x
		stx player_pos_x_HIGH

		ldx #Game::ground
		stx sprite_pos_y
		stx player_pos_y_HIGH

		ldx #5
		stx sprite_animation_timer

		ldx #PlayerStates::idle
		stx player_state

		ldx #Directions::left
		stx sprite_direction 
	rts



	updatePlayer:
		jsr moveCharacter
		jsr checkButtons
		jsr update_sprite_frame
		jsr update_sprite_pos
	rts



	moveCharacter:
		lda character_velocity_x_HIGH
		beq @check_velocity_x_low
		jmp @decrease_velocity_x

		@check_velocity_x_low:
			lda character_velocity_x_LOW
			beq @set_state_idle

		@decrease_velocity_x:
			lda character_velocity_x_LOW
			sec
			sbc #Game::friction
			sta character_velocity_x_LOW
			lda character_velocity_x_HIGH
			sbc #$00
			sta character_velocity_x_HIGH

			lda player_pos_x_HIGH
			cmp #Game::scroll_wall
			bcs @scroll_screen
				lda player_pos_x_LOW
				clc
				adc character_velocity_x_LOW
				sta player_pos_x_LOW
				lda player_pos_x_HIGH
				adc character_velocity_x_HIGH
				sta player_pos_x_HIGH
				sta sprite_pos_x
				jmp @accelerate_y


			@scroll_screen:
				lda player_pos_x_LOW
				clc
				adc character_velocity_x_LOW
				sta player_pos_x_LOW
				lda scroll
				adc character_velocity_x_HIGH
				sta scroll
				jsr Scroll
			jmp @accelerate_y

		
			@set_state_idle:
				lda player_state
				cmp #PlayerStates::airborne
				beq @accelerate_y
				ldx #PlayerStates::idle
				stx player_state

		@accelerate_y:
			lda player_pos_y_HIGH
			cmp #Game::ground
			bcs @landed
			lda character_velocity_y_LOW
			sec
			sbc #Game::gravity
			sta character_velocity_y_LOW
			lda character_velocity_y_HIGH
			sbc #$00
			sta character_velocity_y_HIGH

			lda player_pos_y_LOW
			sec
			sbc character_velocity_y_LOW
			sta player_pos_y_LOW
			lda player_pos_y_HIGH
			sbc character_velocity_y_HIGH
			sta player_pos_y_HIGH
			sta sprite_pos_y
			jmp @end

		@landed:
			lda #PlayerStates::airborne
			cmp player_state
			bne @end
			lda #PlayerStates::idle
			sta player_state
			jmp @end

		@end:
	rts

	checkButtons:
		lda #BUTTON_A
		and Port_1_Pressed_Buttons
		bne @push

		lda #BUTTON_B
		and Port_1_Pressed_Buttons
		bne @jump

		jmp @end

		@push:
			lda character_velocity_x_HIGH
			cmp #Game::max_speed 
			bcs @end
			lda character_velocity_x_LOW
			clc
			adc #Game::push_speed_low
			sta character_velocity_x_LOW
			lda character_velocity_x_HIGH
			adc #Game::push_speed_high
			sta character_velocity_x_HIGH
			        
			ldx #PlayerStates::pushing
			stx player_state
			jmp @end
		
		@jump:
			lda player_state
			cmp #PlayerStates::airborne
			beq @end
			ldx #Game::jump_speed_high
			
			stx character_velocity_y_HIGH
			ldx #Game::jump_speed_low
			stx character_velocity_y_LOW
			dec player_pos_y_HIGH
			ldx #PlayerStates::airborne
			stx player_state
		
		@end:

	rts
	
	update_sprite_frame:
		lda player_state
		cmp #PlayerStates::pushing
		bne @done
		dec sprite_animation_timer
		beq @changeSprite
		jmp	@put_in_OAM
		@changeSprite:
			ldx #10
			stx sprite_animation_timer

			inc sprite_animation_frame

			ldx #$04
				lda Sprite::egg, x
				sta egg_animation_frame
			lda sprite_animation_frame
			cmp #$04 ;if frame 0
			beq @reset_frame ;set to fram 1
			jmp @put_in_OAM

			@reset_frame:  ;selse set to frame 0
				ldx #30
				stx sprite_animation_timer
				lda #$00
				sta sprite_animation_frame

				
				lda Sprite::egg
				sta egg_animation_frame

				ldx #PlayerStates::moving
				stx player_state
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

			ldx egg_animation_frame
			lda Sprite::egg, x
			stx $210 + OAM_TILE
			inx
			stx $214 + OAM_TILE
			inx
			stx $218 + OAM_TILE
			inx
			stx $21C + OAM_TILE
			
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


			lda $210 + OAM_ATTR
			ora sprite_direction
			sta $210 + OAM_ATTR

			lda $214 + OAM_ATTR
			ora sprite_direction
			sta $214 + OAM_ATTR

			lda $218 + OAM_ATTR
			ora sprite_direction
			sta $218 + OAM_ATTR

			lda $21C + OAM_ATTR
			ora sprite_direction
			sta $21C + OAM_ATTR
		
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


			lda $210 + OAM_ATTR
			and sprite_direction
			sta $210 + OAM_ATTR

			lda $214 + OAM_ATTR
			and sprite_direction
			sta $214 + OAM_ATTR

			lda $218 + OAM_ATTR
			and sprite_direction
			sta $218 + OAM_ATTR
			
			lda $21C + OAM_ATTR
			and sprite_direction
			sta $21C + OAM_ATTR

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

			stx	$210 + OAM_X		; store sprite position
			sty $214 + OAM_X  ; add offset for other sprites
			stx	$218 + OAM_X
			sty $21C + OAM_X

			lda sprite_pos_y
			sta	$200 + OAM_Y		
			sta $204 + OAM_Y

			adc #$08			  
			sta	$208 + OAM_Y
			sta $20C + OAM_Y

			lda sprite_pos_y
			sbc #$0E
			sta	$210 + OAM_Y
			sta $214 + OAM_Y
	
			lda sprite_pos_y
			sbc #$07
			
			sta	$218 + OAM_Y
			sta $21C + OAM_Y

	rts
.endscope

