; .IFNDEF PLAYER_INC
; PLAYER_INC =1
;.include "game.asm"
;.include "animations.s"
;.include "player.inc"


; .import Game

.include "animations.inc"
.include "game.inc"
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

	player_movement_state = $10

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

	player_action_state = $1B

	pointer_1_LO = $1C
	pointer_1_HI = $1D
	.enum PlayerMovementStates		
		idle = 0
		inAirMoving = 1
		inAirNotMoving = 2
		onGroundMoving = 3
		
	.endenum
	movementStateJumpTable:
		.addr GroundedNotMoving, AirborneMoving, AirborneNotMoving, GroundedMoving

	.enum PlayerActionStates
		idle = 0
		coasting = 1
		pushing = 2
		ollie = 3
		kickflip = 4
	.endenum




	.proc init_character
		ldx #$00
		
		stx character_velocity_y_HIGH
		
		stx player_pos_x_LOW
		stx player_pos_y_LOW

		ldx #$01
		stx character_velocity_x_LOW
		ldx #$30
		stx player_pos_x_HIGH

		ldx #Game_Const::ground
		stx player_pos_y_HIGH


	

		ldx #PlayerMovementStates::idle
		stx player_movement_state
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
		bne @action_not_done

			lda #PlayerActionStates::coasting
			sta player_action_state
			inc state_change_flag
		@action_not_done:
		jsr Handle_movement_state
		

		
		jsr checkButtons
		jsr handle_states
		
	rts

	
	AirborneMoving:
		jsr Apply_Friction_X
		jsr Apply_Gravity_Y
		jsr Update_Pos_X
		jsr Update_Pos_Y
	rts
	AirborneNotMoving:
		jsr Apply_Gravity_Y
		jsr Update_Pos_Y

	rts

	GroundedMoving:
		jsr Apply_Friction_X
		jsr Update_Pos_X
		;jsr Update_Pos_Y
	rts

	GroundedNotMoving:
		lda #PlayerActionStates::idle
		cmp player_action_state
		beq @done
			sta player_action_state
			inc state_change_flag
		@done:
	rts
	

	Handle_movement_state:
		
		lda player_pos_y_HIGH
		cmp #Game_Const::ground
		bcc @airborne
			lda #Game_Const::ground
			sta player_pos_y_HIGH
			lda #0
			sta player_pos_y_LOW
			lda character_velocity_x_HIGH
			bne @groundedmoving
			lda character_velocity_x_LOW


			bne @groundedmoving
				;grounded not moving
				lda #PlayerMovementStates::idle
				sta player_movement_state
				jmp @done
			@groundedmoving:
				lda #PlayerMovementStates::onGroundMoving
				sta player_movement_state
				jmp @done
			
		@airborne:
		;airborne
			lda character_velocity_x_HIGH
			bne @airborneMoving
			lda character_velocity_x_LOW
			bne @airborneMoving
				;AIRBORNE NOT MOVING
				lda #PlayerMovementStates::inAirNotMoving
				sta player_movement_state
				jmp @done
			@airborneMoving:
				lda #PlayerMovementStates::inAirMoving
				sta player_movement_state
				jmp @done
		@done:
	lda player_movement_state
			asl 
			tax
			lda movementStateJumpTable, x
			sta pointer_1_LO
			lda movementStateJumpTable+1, x
			sta pointer_1_LO+1
			jmp (pointer_1_LO)
	rts



	Apply_Friction_X:
		lda character_velocity_x_LOW
		sec
		sbc #Game_Const::friction
		sta character_velocity_x_LOW
		lda character_velocity_x_HIGH
		sbc #$00
		sta character_velocity_x_HIGH
	rts

	Update_Pos_X:
		lda player_pos_x_HIGH
		cmp #Game_Const::scroll_wall
		bcs @scroll_screen
		lda player_pos_x_LOW
		clc
		adc character_velocity_x_LOW
		sta player_pos_x_LOW
		lda player_pos_x_HIGH
		adc character_velocity_x_HIGH
		sta player_pos_x_HIGH
		jmp @done
		@scroll_screen:
			lda player_pos_x_LOW
			clc
			adc character_velocity_x_LOW
			sta player_pos_x_LOW
			lda scroll
			adc character_velocity_x_HIGH
			sta scroll
			jsr Scroll
		@done:
	rts

	Apply_Gravity_Y:
		lda character_velocity_y_LOW
		sec
		sbc #Game_Const::gravity
		sta character_velocity_y_LOW
		lda character_velocity_y_HIGH
		sbc #$00
		sta character_velocity_y_HIGH
	rts

	Apply_Jump_Y:
		ldx #Game_Const::jump_speed_high			
		stx character_velocity_y_HIGH
		ldx #Game_Const::jump_speed_low
		stx character_velocity_y_LOW
		dec player_pos_y_HIGH
	rts

	Apply_Push_X:
		lda character_velocity_x_LOW
		clc
		adc #Game_Const::push_speed_low
		sta character_velocity_x_LOW
		lda character_velocity_x_HIGH
		adc #Game_Const::push_speed_high
		sta character_velocity_x_HIGH
	rts

	Update_Pos_Y:
		lda player_pos_y_LOW
		sec
		sbc character_velocity_y_LOW
		sta player_pos_y_LOW
		lda player_pos_y_HIGH
		sbc character_velocity_y_HIGH
		sta player_pos_y_HIGH
	rts

	

	checkButtons:

		lda player_movement_state			
		cmp #PlayerMovementStates::inAirNotMoving
		beq @done
		cmp #PlayerMovementStates::inAirMoving
		beq @done

		lda #BUTTON_A
		and Port_1_Pressed_Buttons
		bne @push

		lda #BUTTON_B
		and Port_1_Pressed_Buttons
		bne @jump

		lda#BUTTON_UP
		and Port_1_Pressed_Buttons
		bne @kickflip

		jmp @done

		@push:
			lda player_action_state
			cmp #PlayerActionStates::pushing
			beq @done
			lda character_velocity_x_HIGH
			cmp #Game_Const::max_speed 
			bcs @done
			
			jsr Apply_Push_X        
			ldx #PlayerActionStates::pushing
			stx player_action_state
			inc state_change_flag

			jmp @done
		
		@jump:
			jsr Apply_Jump_Y		
			ldx #PlayerActionStates::ollie
			stx player_action_state
			inc state_change_flag
			jmp @done

		@kickflip:
			jsr Apply_Jump_Y
			ldx #PlayerActionStates::kickflip
			stx player_action_state
			inc state_change_flag
			jmp @done

		@done:

	rts
	
	handle_states:
		; lda flags
		; and #ACTIVE
		; bne @done
		lda state_change_flag
		beq @done1

		lda player_action_state

		cmp #PlayerActionStates::idle
		beq @idle_ani

		cmp #PlayerActionStates::pushing
		beq @pushing_animation

		cmp #PlayerActionStates::ollie
		beq @jumping_animation

		cmp #PlayerActionStates::coasting
		beq @coasting

		cmp #PlayerActionStates::kickflip
		beq @kickflip
		
		jmp @done1

		@idle_ani:
			lda #$11
			sta player_animation_flag
			ldx #>Idle_Ani_Header
			ldy #<Idle_Ani_Header
			jsr Load_Animation
			jmp @done1

		jmp	@done1
		@pushing_animation:
			lda player_animation_flag
			beq @load_push
			lda #$10
			and player_animation_flag
			bne @load_push
			bne @done
			@load_push:
				lda #11
				sta player_animation_flag

				ldx #>Push_Ani_Header
				ldy #<Push_Ani_Header
				jsr Load_Animation
				jmp @done
		@done1:
			jmp @done
		@jumping_animation:
			
			lda player_animation_flag
			beq @load_jump
			lda #$10
			and player_animation_flag
			bne @load_jump
			bne @done
			@load_jump:
				lda #01
				sta player_animation_flag
				ldx #>Jump_Ani_Header
				ldy #<Jump_Ani_Header
				jsr Load_Animation
				jmp @done

		@coasting:
			lda player_animation_flag
			bne @done
			lda #$11
			sta player_animation_flag
			ldx #>Coast_Ani_Header
			ldy #<Coast_Ani_Header
			jsr Load_Animation
			jmp @done

		@kickflip:
			lda player_animation_flag
			beq @load_kf
			lda #$10
			and player_animation_flag
			bne @load_kf
			
			bne @done
			@load_kf:
				lda #01
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