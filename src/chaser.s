.include "animations.inc"
.include "../graphics/Frames.inc"
.include "game.inc"
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
		coasting = 1
		pushing = 2
		ollie = 3
		kickflip = 4
	.endenum

    .proc Init
        lda #0
        sta pos_x_LO
        sta pos_y_LO

        lda #$20
        sta pos_x_HI

        lda #Game_Const::ground
        adc #4
        sta pos_y_HI

        
		ldx #>chaser_Ani_Header
		ldy #<chaser_Ani_Header
		jsr Load_Animation

	 
	
        rts
    .endproc
.endscope