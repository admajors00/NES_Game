.include "/inc/animations.inc"
.include "../graphics/Frames.inc"
.include "/inc/game.inc"
.segment "CODE"
.scope Chaser
    movement_state = $40

	pos_x_LO = $41
	pos_x_HI = $42
	pos_y_LO = $43
	pos_y_HI = $44

	velocity_x_LO = $45
	velocity_x_HI = $46
	velocity_y_LO = $47
	velocity_y_HI = $48

	relative_velocity = $4E

	animation_flag = $49
	state_change_flag = $4A ;state change this frame if 1, otherwise 0

	action_state = $4B

	pointer_1_LO = $4C
	pointer_1_HI = $4D

    .enum MovementStates		
		idle = 0
		inAirMoving = 1
		inAirNotMoving = 2
		onGroundMoving = 3
		
	.endenum
	; movementStateJumpTable:
	; 	.addr GroundedNotMoving, AirborneMoving, AirborneNotMoving, GroundedMoving

	.enum ActionStates
		idle = 0
		running = 1
		jumping = 2
		ollie = 3
	
	.endenum

    .proc Init
        lda #0
        sta pos_x_LO
        sta pos_y_LO

        lda #$10
        sta pos_x_HI

        lda #Game_Const::ground
        ;adc #
        sta pos_y_HI

        
		ldx #>chaser_Ani_Header
		ldy #<chaser_Ani_Header
		jsr Load_Animation

		lda #2
	 	sta velocity_x_HI
		lda #$B0
		sta velocity_x_LO
	
        rts
    .endproc

	 Update:
		; lda Player::character_velocity_x_HIGH
		; sta velocity_x_HI
		; lda Player::character_velocity_x_LOW
		;sta velocity_x_LO

		; sec
		; sbc #8
		; @skip
		; sta velocity_x_LO
		
		
		lda velocity_x_HI
		sbc amount_to_scroll
		sta relative_velocity


		lda pos_x_LO
		clc 
		adc velocity_x_LO
		sta pos_x_LO
		lda pos_x_HI
		adc relative_velocity

		;lda pos_x_HI
		cmp Player::pos_x_HI
		bcs @done
		sta pos_x_HI

		lda pos_x_HI

		cmp #$0f
		bcc @hide_chaser
			lda #Game_Const::ground
       		sta pos_y_HI
			jmp @done
		@hide_chaser:
			lda #$FF
			sta pos_y_HI
			;sta pos_x_HI
		@done:


		ldy #Sprite_Positions_e::chaser_x
		lda pos_x_HI
		sta Sprite_positions_table, y
		iny 
		lda pos_y_HI
		sta Sprite_positions_table, y
		rts
	
.endscope