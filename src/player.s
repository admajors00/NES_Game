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
.segment "CODE"
OAM_ADDR  = $2003
OAM_DATA  = $2004
OAM_DMA   = $4014

OAM_Y    = 0
OAM_TILE = 1
OAM_ATTR = 2
OAM_X    = 3


.scope Player

	 .import Load_Animation
	 .import flags

	player_state = $10

	player_pos_x_LOW = $11
	player_pos_x_HIGH = $12
	player_pos_y_LOW = $13
	player_pos_y_HIGH = $14

	character_velocity_x_LOW = $15
	character_velocity_x_HIGH = $16
	character_velocity_y_LOW = $17
	character_velocity_y_HIGH = $18

	player_animation_flag = $19
	state_change_flag = $1A ;state change this frame if 1, otherwise 0
	.enum PlayerStates
		
		idle = 0
		coasting = 1
		pushing = 2
		airborne = 3
		kickflip = 4
	.endenum

	.enum Directions
		left =  %10111111 ; $bf
		right = %01000000 ; $40
	.endenum



	.proc init_character
		ldx #$00
		
		stx character_velocity_y_HIGH
		
		stx player_pos_x_LOW
		stx player_pos_y_LOW

		ldx #$01
		stx character_velocity_x_LOW
		ldx #$10
		stx player_pos_x_HIGH

		ldx #Game::ground
		stx player_pos_y_HIGH


	

		ldx #PlayerStates::idle
		stx player_state
		lda #$10
		sta player_animation_flag

		ldx #>Idle_Ani_Header
		ldy #<Idle_Ani_Header
		jsr Load_Animation
		rts
	.endproc


	updatePlayer:
		ldx #0
		stx state_change_flag

		lda player_animation_flag;if 0 then an animation has finishjed, return to default state
		bne @continue
			lda PlayerStates::airborne
			sta player_state
			inc state_change_flag

		@continue:

		jsr moveCharacter
		jsr checkButtons
		jsr handle_states
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
					cmp #PlayerStates::idle
					beq @end
						ldx #PlayerStates::idle
						stx player_state
						inc state_change_flag
				;jmp @end

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

			cmp #Game::ground
			bcs @landed
			sta player_pos_y_HIGH
			jmp @end
		 	

		@landed:
			lda #Game::ground
			sta player_pos_y_HIGH
			lda #0
			sta player_pos_y_LOW

			lda #PlayerStates::airborne
			cmp player_state
			bne @end
			lda #PlayerStates::coasting
			sta player_state
			inc state_change_flag
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

		lda#BUTTON_UP
		and Port_1_Pressed_Buttons
		bne @kickflip

		jmp @end

		@push:
			lda player_state
			cmp #PlayerStates::pushing
			beq @end
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
			inc state_change_flag

			jmp @end
		
		@jump:
			lda player_state
			cmp #PlayerStates::airborne
			beq @end
			cmp #PlayerStates::pushing
			beq @end
			cmp #PlayerStates::kickflip
			beq @end
			ldx #Game::jump_speed_high
			
			stx character_velocity_y_HIGH
			ldx #Game::jump_speed_low
			stx character_velocity_y_LOW
			dec player_pos_y_HIGH
			ldx #PlayerStates::airborne
			stx player_state
			inc state_change_flag
			jmp @end
		@kickflip:

			lda player_state
			cmp #PlayerStates::airborne
			beq @end
			cmp #PlayerStates::pushing
			beq @end
			cmp #PlayerStates::kickflip
			beq @end
			ldx #Game::jump_speed_high			
			stx character_velocity_y_HIGH
			ldx #Game::jump_speed_low
			stx character_velocity_y_LOW
			dec player_pos_y_HIGH
			ldx #PlayerStates::kickflip
			stx player_state
			inc state_change_flag
			jmp @end

		@end:

	rts
	
	handle_states:
		; lda flags
		; and #ACTIVE
		; bne @done
		lda state_change_flag
		beq @done1

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

		cmp #PlayerStates::kickflip
		beq @kickflip
		
		jmp @done1

		@idle_ani:
			lda player_animation_flag
			bne @done
			lda #$10
			sta player_animation_flag
			ldx #>Idle_Ani_Header
			ldy #<Idle_Ani_Header
			jsr Load_Animation
			jmp @done1

		jmp	@done1
		@pushing_animation:
			lda #$10
			and player_animation_flag
			bne @load_push
			lda player_animation_flag
			bne @done
			@load_push:
				lda #1
				sta player_animation_flag

				ldx #>Push_Ani_Header
				ldy #<Push_Ani_Header
				jsr Load_Animation
				jmp @done
		@done1:
			jmp @done
		@jumping_animation:
			
			lda #$10
			and player_animation_flag
			bne @load_jump
			lda player_animation_flag
			bne @done
			@load_jump:
				lda #1
				sta player_animation_flag
				ldx #>Jump_Ani_Header
				ldy #<Jump_Ani_Header
				jsr Load_Animation
				jmp @done

		@coasting:
			lda player_animation_flag
			bne @done
			lda #$10
			sta player_animation_flag
			ldx #>Coast_Ani_Header
			ldy #<Coast_Ani_Header
			jsr Load_Animation
			jmp @done

		@kickflip:
			lda #$10
			and player_animation_flag
			bne @load_kf
			lda player_animation_flag
			bne @done
			@load_kf:
				lda #1
				sta player_animation_flag
				ldx #>KickFlip_Ani_Header
				ldy #<KickFlip_Ani_Header
				jsr Load_Animation
				jmp @done

		
		@done:
	rts

	
.endscope


; .export Player
;  .ENDIF