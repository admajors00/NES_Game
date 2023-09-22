.include "animations.inc"
.include "../graphics/Frames.inc"
.include "game.inc"


.segment "CODE"
.scope Obsticles


    pos_x = $50
    pos_y = $51

    screen_pos_x = $52

    Init:
        lda #$90
        sta pos_x 
        sta screen_pos_x

        lda #Game_Const::ground
        clc
        adc #$0A
        sta pos_y


        ldx #>Cone_Ani_Header
		ldy #<Cone_Ani_Header
		jsr Load_Animation
    rts


    Update:
        lda screen_pos_x
        sec
        sbc scroll
        sta pos_x
    rts
.endscope