; .IFNDEF PLAYER_INC
; PLAYER_INC =1
;.include "game.asm"
;.include "animations.s"
;.include "player.inc"


; .import Game
.include "animations.inc"
.include "../graphics/Frames.inc"
; OAM address ($2003) > write / OAM data ($2004) > write
; Set the "sprite" address using OAMADDR ($2003)
; Then write the following bytes via OAMDATA ($2004)
OAM_ADDR  = $2003
OAM_DATA	= $2004
OAM_DMA   = $4014

OAM_Y    = 0
OAM_TILE = 1
OAM_ATTR = 2
OAM_X    = 3


.scope Player

	 .import Load_Animation
	 .import flags
	sprite_pos_x = $10
	sprite_pos_y = $11
	skateboard_animation_frame= $12
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
		
		idle = 0
		coasting = 1
		pushing = 2
		airborne = 3
	.endenum

	.enum Directions
		left =  %10111111 ; $bf
		right = %01000000 ; $40
	.endenum



	.proc init_character
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

		ldx #>Coast_Ani_Header
		ldy #<Coast_Ani_Header
		jsr Load_Animation
		rts
	.endproc


	updatePlayer:
		jsr moveCharacter
		jsr checkButtons
		jsr update_sprite_frame
		;jsr update_sprite_pos
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
			lda #PlayerStates::coasting
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
		; lda flags
		; and #ACTIVE
		; bne @done
		lda player_state


	
		; dec sprite_animation_timer
		; bne @done
		cmp #PlayerStates::idle
		beq @idle_ani

		cmp #PlayerStates::pushing
		beq @pushing_animation

		cmp #PlayerStates::airborne
		beq @jumping_animation

		cmp #PlayerStates::coasting
		beq @coasting
		
		jmp @done

		@idle_ani:
			; /ldx #>EWL_StreetSkate_pointers_IDLE
			; ldy #<EWL_StreetSkate_pointers_IDLE
			; jsr Load_Animation
			jmp @done

		jmp	@done
		@pushing_animation:
			ldx #>Push_Ani_Header
			ldy #<Push_Ani_Header
			jsr Load_Animation
			jmp @done

		@jumping_animation:
			; ldx #>Jump_Ani_Header
			; ldy #<Jump_Ani_Header
			; jsr Load_Animation
			jmp @done

		@coasting:
			; ldx #>Coast_Ani_Header
			; ldy #<Coast_Ani_Header
			; jsr Load_Animation
			jmp @done


		@reset_frame:  ;sel1e set to frame 0
			jmp @done
		@done:
	rts

.endscope


; .export Player
;  .ENDIF