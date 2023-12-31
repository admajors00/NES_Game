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

player_input_flags_g = $1A

PLAYER_ANI_DONE_f = 1<<0
PLAYER_HIT_DETECTED_f = 1<<1

PLAYER_GRIND_DETECTED_f = 1<<2
PLAYER_RAMP_DETECTED_f = 1<<3
PLAYER_GRAB_DETECTED_f = 1<<4
PLAYER_ROUGH_DETECTED_f 	= 1<<5

ACTION_INTERRUPTABLE_f 	= 1<<0
ACTION_STATE_CHANGE_f	= 1<<1
MOTION_STATE_CHANGE_f 	= 1<<2
UPDATE_ANIMATION_f 		= 1<<3
.scope Player

	.import Load_Animation
	.import flags

	player_movement_state = $10

	pos_x_LO = $11
	pos_x_HI = $12
	pos_y_LO = $13
	pos_y_HI = $14

	velocity_x_LO = $15
	velocity_x_HI = $16
	velocity_Y_LO = $17
	velocity_Y_HI = $18


	internal_flags = $19

	player_action_state = $1B

	pointer_1_LO = $1C
	pointer_1_HI = $1D

	frame_speed = $1E;animation frame speed

	player_state = $1F

	jump_speed_LO = $80
	jump_speed_HI = $81
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
		loadup = 5
		crash = 6
		shuvit=7
	.endenum



	
	
	; actionStateJumpTable:
	; 	.addr idle_ani, coasting, pushing_animation, jumping_animation, kickflip_animation,loadUp_animation, crashed_animation, shuv_it_animation
	actionStateAniTable:
		.addr Idle_Ani_Header, Coast_Ani_Header, Push_Ani_Header, Jump_Ani_Header, KickFlip_Ani_Header, LoadUp_Ani_Header, Crash_Ani_Header, ShuvIt_Ani_Header
	.enum PlayerGameStates_e
		normal = 0
		crashed = 1
		starting = 2

	.endenum

	playerGameStateJumpTable:
		.addr Normal_Update, Crashed_Update, Starting_Update

	.proc Init
		ldx #$00
		
		stx velocity_Y_HI
		
		stx pos_x_LO
		stx pos_y_LO
		stx internal_flags
		stx player_input_flags_g
		ldx #$ff
		stx velocity_x_LO
		ldx #$02
		stx velocity_x_HI
		ldx #$30
		stx pos_x_HI

		ldx #Game_Const::ground
		stx pos_y_HI

		ldy #>Idle_Ani_Header
		ldx #<Idle_Ani_Header
		jsr Load_Animation


		lda #PlayerActionStates::coasting
		sta player_action_state

		ldx #PlayerMovementStates::idle
		stx player_movement_state

		lda #PlayerGameStates_e::starting
		sta player_state
		rts
	.endproc


	Update:
	
		jsr Handle_input_flags
		

		lda player_state
		asl 
		tax
		lda playerGameStateJumpTable, x
		sta pointer_1_LO
		lda playerGameStateJumpTable+1, x
		sta pointer_1_LO+1
		jmp (pointer_1_LO)
		
	rts	
		
	Handle_input_flags:
		lda #PLAYER_ANI_DONE_f;if 0 then an animation has finished, return to default state
		and player_input_flags_g
		beq @action_not_done

			lda #PlayerActionStates::coasting
			sta player_action_state

			lda internal_flags
			ora #ACTION_STATE_CHANGE_f
			sta internal_flags

			lda player_input_flags_g;if 0 then an animation has finished, return to default state
			and #<~PLAYER_ANI_DONE_f
			sta player_input_flags_g
			
		@action_not_done:


		lda  #PLAYER_RAMP_DETECTED_f
		and player_input_flags_g
		bne @ramp

		lda #PLAYER_HIT_DETECTED_f
		and player_input_flags_g
		bne @trip

		lda  #PLAYER_GRAB_DETECTED_f
		and player_input_flags_g
		bne @grabbed

		lda  #PLAYER_ROUGH_DETECTED_f
		and player_input_flags_g
		bne @rough

		
		

		jmp @flag_check_done

		@ramp:
			lda player_input_flags_g
			and #<~PLAYER_RAMP_DETECTED_f
			sta player_input_flags_g
			; lda player_movement_state
			; cmp #PlayerMovementStates::inAirMoving
			; beq @trip

			lda #PlayerActionStates::ollie
			sta player_action_state
			lda #ACTION_STATE_CHANGE_f
			ora internal_flags
			sta internal_flags
			;  lsr velocity_x_HI
			;  ror velocity_x_LO

			; lda velocity_Y_LO
			; clc
			; adc velocity_x_LO
			; sta velocity_Y_LO
			; lda velocity_Y_HI
			; adc velocity_x_HI
			; sta velocity_Y_HI
			; dec pos_y_HI
			lda #0
			sta jump_speed_LO
			sta jump_speed_HI
			lda velocity_x_LO
			
			sta velocity_Y_LO
			clc
			lda velocity_x_HI
			
			sta velocity_Y_HI


			sec 
			lda velocity_Y_LO
			sbc #$FF
			sta velocity_Y_LO
			lda velocity_Y_HI
			sbc #0
			sta velocity_Y_HI

			dec pos_y_HI
			rts

		@trip:
			lda player_input_flags_g
			and #<~PLAYER_HIT_DETECTED_f
			sta player_input_flags_g
			
			lda #PlayerGameStates_e::crashed
			sta player_state
			lda #0
			sta velocity_Y_HI
			sta velocity_Y_LO
			sta velocity_x_LO
			sta velocity_x_HI
			ldx #<Crash_Ani_Header
			ldy #>Crash_Ani_Header
			
			jsr Load_Animation
			
			RTS

		@grabbed:
			lda player_input_flags_g
			and #<~PLAYER_GRAB_DETECTED_f
			sta player_input_flags_g
			
			lda #PlayerGameStates_e::crashed
			sta player_state
			lda #0
			sta velocity_Y_HI
			sta velocity_Y_LO
			sta velocity_x_LO
			sta velocity_x_HI
			ldx #<Crash_Ani_Header
			ldy #>Crash_Ani_Header
			
			jsr Load_Animation
			rts
		@rough:
			lda #<~PLAYER_ROUGH_DETECTED_f
			and player_input_flags_g
			sta player_input_flags_g

			
			lda velocity_x_HI
			bne @continue
			;IF VxHI is zero check if VxLO is greater than friction
				LDA velocity_x_LO
				cmp #$F0
				bcs @continue
				; lda #0 ;if VxLO is less than friction, set to 0
				; sta velocity_x_LO
				jmp @done
			@continue:
				; else, subtract from both
				lda velocity_x_LO
				sec
				sbc #$18
				
				sta velocity_x_LO
				lda velocity_x_HI
				sbc #$00
				;bvs @done
				sta velocity_x_HI
			@done:

			
		@flag_check_done:

	rts
	Normal_Update:	
		jsr Handle_movement_state
		jsr Handle_action_state
		jsr load_action_state_ani

		
		ldy #Sprite_Positions_e::player_x
		lda pos_x_HI
		sta Sprite_positions_table, y
		iny 
		lda pos_y_HI
		sta Sprite_positions_table, y

		ldy #Sprite_Positions_e::ind_x
		lda pos_x_HI


		sta Sprite_positions_table, y ;update indicator pos
		iny 
		lda pos_y_HI
		sec
		sbc #24
		sta Sprite_positions_table, y

		lda velocity_x_HI
		sta frame_speed
		lda velocity_x_LO
		asl 
		rol frame_speed
		asl 
		rol frame_speed
	rts
	Crashed_Update:
		jsr Handle_movement_state
		ldy #Sprite_Positions_e::player_x
		lda pos_x_HI
		sta Sprite_positions_table, y
		iny 
		lda pos_y_HI
		sta Sprite_positions_table, y
		lda Port_1_Pressed_Buttons
		beq @done
			lda #PlayerGameStates_e::starting
			sta player_state
		@done:
	rts

	Starting_Update:
		lda #PlayerGameStates_e::normal
		sta player_state

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
		; lda #PlayerActionStates::crash
		; cmp player_action_state
		; beq @done
		; 	sta player_action_state
		; 	inc state_change_flag
			
		; @done:
	rts


	

	Handle_movement_state:
		lda pos_y_HI
		cmp #Game_Const::ground
		bcc @airborne
			lda #Game_Const::ground
			sta pos_y_HI
			lda #0
			sta pos_y_LO
			lda velocity_x_HI
			bne @groundedmoving
			lda velocity_x_LO


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
			lda velocity_x_HI
			bne @airborneMoving
			lda velocity_x_LO
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
		lda velocity_x_HI
		bne @continue
			;IF VxHI is zero check if VxLO is greater than friction
			LDA velocity_x_LO
			cmp #Game_Const::friction
			bcs @continue
			lda #0 ;if VxLO is less than friction, set to 0
			sta velocity_x_LO
			jmp @done
		@continue:
			; else, subtract from both
			lda velocity_x_LO
			sec
			sbc #Game_Const::friction
			
			sta velocity_x_LO
			lda velocity_x_HI
			sbc #$00
			;bvs @done
			sta velocity_x_HI
		@done:
	rts

	Update_Pos_X:
		lda pos_x_HI
		cmp #Game_Const::scroll_wall
		bcs @scroll_screen
		lda pos_x_LO
		clc
		adc velocity_x_LO
		sta pos_x_LO
		lda pos_x_HI
		adc velocity_x_HI
		sta pos_x_HI
		jmp @done
		@scroll_screen:
			lda pos_x_LO
			clc
			adc velocity_x_LO
			sta pos_x_LO
			lda amount_to_scroll
		
			adc velocity_x_HI
			sta amount_to_scroll

		@done:
	rts

	Apply_Gravity_Y:
		lda velocity_Y_LO
		sec
		sbc #Game_Const::gravity
		sta velocity_Y_LO
		lda velocity_Y_HI
		sbc #$00
		sta velocity_Y_HI
	rts

	Apply_Jump_Y:
		ldx jump_speed_HI		
		stx velocity_Y_HI
		ldx jump_speed_LO
		stx velocity_Y_LO
		dec pos_y_HI
	rts

	Apply_Push_X:
		lda velocity_x_HI
		cmp #Game_Const::max_speed_HI  

		bcc @cont
			bne @done	
			lda velocity_x_LO
			cmp #Game_Const::max_speed_LO 
			BCS @done
		@cont:
		lda velocity_x_LO
		clc
		adc #Game_Const::push_speed_low
		sta velocity_x_LO
		lda velocity_x_HI
		adc #Game_Const::push_speed_high
		sta velocity_x_HI
		@done:
	rts

	Update_Pos_Y:
		lda pos_y_LO
		sec
		sbc velocity_Y_LO
		sta pos_y_LO
		lda pos_y_HI
		sbc velocity_Y_HI
		sta pos_y_HI
	rts

	

	Handle_action_state:

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

		lda#BUTTON_LEFT
		and Port_1_Pressed_Buttons
		bne shuv_it

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
		cmp #PlayerActionStates::loadup
		beq @cont
			lda#0
			sta jump_speed_LO
			sta jump_speed_HI
		@cont:
		
		
		jsr Apply_Push_X        
		ldx #PlayerActionStates::pushing
		stx player_action_state

		lda #ACTION_STATE_CHANGE_f
		ora internal_flags
		sta internal_flags
		@done:
		rts
	
	jump:
		jsr Apply_Jump_Y		
		ldx #PlayerActionStates::ollie
		stx player_action_state

		lda #ACTION_STATE_CHANGE_f
		ora internal_flags
		sta internal_flags
	rts

	kickflip:
		jsr Apply_Jump_Y
		lda #0
		sta jump_speed_HI
		sta jump_speed_LO
		ldx #PlayerActionStates::kickflip
		stx player_action_state

		lda #ACTION_STATE_CHANGE_f
		ora internal_flags
		sta internal_flags
	rts
	shuv_it:
		jsr Apply_Jump_Y
		lda #0
		sta jump_speed_HI
		sta jump_speed_LO
		ldx #PlayerActionStates::shuvit
		stx player_action_state

		lda #ACTION_STATE_CHANGE_f
		ora internal_flags
		sta internal_flags
	rts

	
	loadup_start:
		lda #0
		sta jump_speed_HI
		sta jump_speed_LO
		ldx #PlayerActionStates::loadup
		stx player_action_state

		lda #ACTION_STATE_CHANGE_f
		ora internal_flags
		sta internal_flags
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
		adc #$18
		sta jump_speed_LO
		lda jump_speed_HI
		adc #0
		sta jump_speed_HI
		jmp @done
	@done:

	rts
	




	load_action_state_ani:
		; lda flags
		; and #ACTIVE
		; bne @done
		lda #ACTION_STATE_CHANGE_f 
		and internal_flags
		beq @done
			lda #<~ACTION_STATE_CHANGE_f 
			and internal_flags
			sta internal_flags
			
			lda player_action_state
			asl 
			tax
			lda actionStateAniTable, x
			sta pointer_1_LO
			lda actionStateAniTable+1, x
			sta pointer_1_HI

			ldx pointer_1_LO
			ldy pointer_1_HI 
			jsr Load_Animation
			;jmp (pointer_1_LO)
		
		@done:	
	rts	

	; idle_ani:
	; 	lda #$11
	; 	sta player_animation_flag
	; 	ldx #<Idle_Ani_Header
	; 	ldy #>Idle_Ani_Header
		
	; 	jsr Load_Animation
		

	; rts

	; pushing_animation:
	; 	lda player_animation_flag
	; 	beq @load_push
	; 	lda #$10
	; 	and player_animation_flag
	; 	bne @load_push
	; 	bne @done
	; 	@load_push:
	; 		lda #11
	; 		sta player_animation_flag

	; 		ldy #>Push_Ani_Header
	; 		ldx #<Push_Ani_Header
	; 		jsr Load_Animation
	; 		jmp @done
	; 	@done:
	; rts


	; jumping_animation:
		
	; 	lda player_animation_flag
	; 	beq @load_jump
	; 	lda #$10
	; 	and player_animation_flag
	; 	bne @load_jump
	; 	bne @done
	; 	@load_jump:
	; 		lda #01
	; 		sta player_animation_flag
	; 		ldy #>Jump_Ani_Header
	; 		ldx #<Jump_Ani_Header
	; 		jsr Load_Animation
	; 	@done:
	; 	rts

	; coasting:
	; 	lda player_animation_flag
	; 	bne @done
	; 	lda #$11
	; 	sta player_animation_flag
	; 	ldy #>Coast_Ani_Header
	; 	ldx #<Coast_Ani_Header
	; 	jsr Load_Animation
	; 	@done:
	; 	rts
	; loadUp_animation:
	; 	lda player_animation_flag
	; 	beq @loadup
	; 	lda #$10
	; 	and player_animation_flag
	; 	bne @loadup
		
	; 	bne @done
	; 	@loadup:
	; 		; lda player_animation_flag
	; 		; bne @done
	; 		lda #$01
	; 		sta player_animation_flag
	; 		ldy #>LoadUp_Ani_Header
	; 		ldx #<LoadUp_Ani_Header
	; 		jsr Load_Animation
	; 	@done:
	; 	rts

	; kickflip_animation:
	; 	lda player_animation_flag
	; 	beq @load_kf
	; 	lda #$10
	; 	and player_animation_flag
	; 	bne @load_kf
		
	; 	bne @done
	; 	@load_kf:
	; 		lda #$01
	; 		sta player_animation_flag
	; 		ldy #>KickFlip_Ani_Header
	; 		ldx #<KickFlip_Ani_Header
	; 		jsr Load_Animation
	; 		jmp @done
	; @done:
	; rts
	; shuv_it_animation:
	; 	lda player_animation_flag
	; 	beq @load_si
	; 	lda #$10
	; 	and player_animation_flag
	; 	bne @load_si
		
	; 	bne @done
	; 	@load_si:
	; 		lda #$01
	; 		sta player_animation_flag
	; 		ldy #>ShuvIt_Ani_Header
	; 		ldx #<ShuvIt_Ani_Header
	; 		jsr Load_Animation
	; 		jmp @done
	; @done:
	; rts
	; crashed_animation:
	; 	lda player_animation_flag
	; 	beq @crash_
	; 	lda #$10
	; 	and player_animation_flag
	; 	bne @crash_
		
	; 	bne @done
	; 	@crash_:
	; 	lda #$01
		
	; 	sta player_animation_flag
	; 	ldy #>Crash_Ani_Header
	; 	ldx #<Crash_Ani_Header
	; 	jsr Load_Animation
	; 	@done:
	; rts	
	
.endscope


; .export Player
;  .ENDIF