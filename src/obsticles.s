.include "/inc/animations.inc"
.include "../graphics/Frames.inc"
.include "/inc/game.inc"
.include "/inc/obsticles.inc"



.segment "CODE"

obsticles_active_flag = $57
.scope Obsticles


    pos_x = $50
    pos_y = $51



    screen_pos_x = $52

    header_pt_LO = $53
    header_pt_HI = $54

    length = $55
    height  = $56

    temp1 = $5E

    Init:
        lda #$00
        sta pos_x 
        sta screen_pos_x

        lda #Game_Const::ground
        clc
        adc #$00
        sta pos_y


        ldx #>Empty_Ani_Header
		ldy #<Empty_Ani_Header
		jsr Load_Animation

        ldx #>Cone
		ldy #<Cone
		jsr Load
        

    rts


    Update:
        lda screen_pos_x
        sec
        sbc scroll
        sta pos_x
        
        ldy #Sprite_Positions_e::obst_1_x
		lda pos_x
		sta Sprite_positions_table, y
		iny 
		lda pos_y
		sta Sprite_positions_table, y
    rts


    Load:
        inc temp1
        sty header_pt_LO
        stx header_pt_HI

        ldy #Obstical_t::pos_x
        lda (header_pt_LO), Y
        sta pos_x

        iny
        lda (header_pt_LO), Y
        sta pos_y

        iny
        lda (header_pt_LO), Y
        sta  length

        iny
        lda (header_pt_LO), Y
        sta  height
    rts

.endscope







