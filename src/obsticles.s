.include "/inc/animations.inc"
.include "../graphics/Frames.inc"
.include "/inc/game.inc"
.include "/inc/obsticles.inc"



.segment "CODE"

obsticles_active_flag = $58

OBST_1_ACTIVE_f = 1<< 0
OBST_2_ACTIVE_f = 1<< 1
OBST_3_ACTIVE_f = 1<< 2
OBST_4_ACTIVE_f = 1<< 3

MAX_OBSTICLES  = 4

Obstical_headers:
    .addr 0 ,0, 0 ,0 
.scope Obsticles


    pos_x = $50
    pos_y = $51



    screen_pos_x = $52

    header_pt_LO = $53
    header_pt_HI = $54

    length = $55
    height  = $56

    type = $57


    obsticle_index = $5e

    internal_flags = $5f
    

    Init:
        lda #$00
        sta pos_x 
        sta screen_pos_x

        lda #Game_Const::ground
        clc
        adc #$00
        sta pos_y


        ldy #>Empty_Ani_Header
		ldx #<Empty_Ani_Header
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
        ; lda #0
        ; sta index
        ; lda #1
        ; sta main_temp
        ; lda obsticles_active_flag
        ; sec
        ; @loop_1: ;check obsticals active flags for inactive obstcal
        ;     lda index
        ;     cmp #MAX_OBSTICLES
        ;     bcs @done
        ;     inc index
        ;     asl main_temp
        ;     lsr a
        ;     bcs @loop_1
        ; lsr main_temp

        ; lda obsticles_active_flag
        ; ora main_temp
        ; sta obsticles_active_flag;set obstical active flag

        
        stx header_pt_LO
        sty header_pt_HI

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

        iny
        lda (header_pt_LO), Y
        sta  type
        @done:
    rts

.endscope







