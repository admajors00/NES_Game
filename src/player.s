; .IFNDEF PLAYER_INC
; PLAYER_INC =1
;.include "game.asm"
;.include "animations.s"
;.include "player.inc"


; .import Game

.include "/inc/animations.inc"
.include "/inc/game.inc"
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

	frame_speed = $1E

	jump_speed_LO = $80
	jump_speed_HI = $81
	.enum PlayerMovementStates		
		idle = 0
		inAirMoving = 1
		inAirNotMoving = 2
		onGroundMoving = 3
		crash = 4
		
	.endenum
	movementStateJumpTable:
		.addr GroundedNotMoving, AirborneMoving, AirborneNotMoving, GroundedMoving

	.enum PlayerActionStates
		idle = 0
		coasting = 1
		pushing = 2
		ollie = 3
		kickflip = 4
		loadup = 5
		crash = 6
	.endenum
actionStateJumpTable:
	.addr idle_ani, coasting, pushing_animation, jumping_animation, kickflip_animation,loadUp_animation, crashed_animation



	.proc init_character
		ldx #$00
		
		stx character_velocity_y_HIGH
		
		stx player_pos_x_LOW
		stx player_pos_y_LOW

		ldx #$ff
		stx character_velocity_x_LOW
		ldx #$02
		stx character_velocity_x_HIGH
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

		lda player_animation_flag;if 0 then an animation has finished, return to default state
		bne @action_not_done

			lda #PlayerActionStates::coasting
			sta player_action_state
			inc state_change_flag
		@action_not_done:
		jsr Handle_movement_state
		

		
		jsr checkButtons
		jsr handle_states
		
		ldy #Sprite_Positions_e::player_x
		lda player_pos_x_HIGH
		sta Sprite_positions_table, y
		iny 
		lda player_pos_y_HIGH
		sta Sprite_positions_table, y

		lda character_velocity_x_HIGH
		sta frame_speed
		lda character_velocity_x_LOW
		asl 
		rol frame_speed
		asl 
		rol frame_speed
	rts

	
	AirborneMoving:
		
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
		
	rts

	GroundedNotMoving:
		lda #PlayerActionStates::crash
		cmp player_action_state
		beq @done
			sta player_action_state
			inc state_change_flag
		@done:
	rts

	; Crashed:
	; 	lda #PlayerActionStates::crash
	; 	sta player_action_state
	; 	inc state_change_flag
	; 	lda #PlayerMovementStates::idle
	; 	sta player_movement_state
		
	; rts
	

	Handle_movement_state:
		lda #PlayerMovementStates::crash
		cmp player_movement_state
		beq @done
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
			lda amount_to_scroll
			;clc
			adc character_velocity_x_HIGH
			sta amount_to_scroll

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
		ldx jump_speed_HI		
		stx character_velocity_y_HIGH
		ldx jump_speed_LO
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
		bne push

		lda#BUTTON_UP
		and Port_1_Pressed_Buttons
		bne kickflip

		lda #BUTTON_B
		and Port_1_Pressed_Buttons
		bne loadup_start

		lda #BUTTON_B
		and Port_1_Down_Buttons
		bne loadup

		lda #BUTTON_B
		and Port_1_Released_Buttons
		bne jump

		
		@done:
		rts

	push:
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
		@done:
		rts
	
	jump:
		jsr Apply_Jump_Y		
		ldx #PlayerActionStates::ollie
		stx player_action_state
		inc state_change_flag
	rts

	kickflip:
		jsr Apply_Jump_Y
		lda #0
		sta jump_speed_HI
		sta jump_speed_LO
		ldx #PlayerActionStates::kickflip
		stx player_action_state
		inc state_change_flag
	rts

	
	loadup_start:
		lda #0
		sta jump_speed_HI
		sta jump_speed_LO
		ldx #PlayerActionStates::loadup
		stx player_action_state
		inc state_change_flag
	rts


	loadup:
	
		lda jump_speed_HI
		cmp #Game_Const::jump_speed_max_high
		bcc @add_speed
		lda jump_speed_LO
		cmp #Game_Const::jump_speed_max_low
		bcs	@done
		
		@add_speed:
		lda jump_speed_LO
		clc
		adc #$0F
		sta jump_speed_LO
		lda jump_speed_HI
		adc#0
		sta jump_speed_HI
		jmp @done
	@done:

	rts
	
	handle_states:
		; lda flags
		; and #ACTIVE
		; bne @done
		lda state_change_flag
		beq @done
		lda player_action_state
			asl 
			tax
			lda actionStateJumpTable, x
			sta pointer_1_LO
			lda actionStateJumpTable+1, x
			sta pointer_1_LO+1
			jmp (pointer_1_LO)
		
	@done:	
	rts	

	idle_ani:
		lda #$11
		sta player_animation_flag
		ldx #>Idle_Ani_Header
		ldy #<Idle_Ani_Header
		jsr Load_Animation
		

	rts

	pushing_animation:
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
		@done:
	rts


	jumping_animation:
		
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
		@done:
		rts

	coasting:
		lda player_animation_flag
		bne @done
		lda #$11
		sta player_animation_flag
		ldx #>Coast_Ani_Header
		ldy #<Coast_Ani_Header
		jsr Load_Animation
		@done:
		rts
	loadUp_animation:
		lda player_animation_flag
		beq @loadup
		lda #$10
		and player_animation_flag
		bne @loadup
		
		bne @done
		@loadup:
			; lda player_animation_flag
			; bne @done
			lda #$01
			sta player_animation_flag
			ldx #>LoadUp_Ani_Header
			ldy #<LoadUp_Ani_Header
			jsr Load_Animation
		@done:
		rts

	kickflip_animation:
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

	crashed_animation:
		lda player_animation_flag
		beq @crash_
		lda #$10
		and player_animation_flag
		bne @crash_
		
		bne @done
		@crash_:
		lda #01
		sta player_animation_flag
		ldx #>Crash_Ani_Header
		ldy #<Crash_Ani_Header
		jsr Load_Animation
		@done:
	rts	
	
.endscope


; .export Player
;  .ENDIF