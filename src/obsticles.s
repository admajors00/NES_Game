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
    obsticles_inFrame_flag = $59

    Init:
        lda #$00
        sta screen_pos_x
        sta obsticles_active_flag
        sta obsticles_inFrame_flag
        lda #$F8
        sta pos_x 

        lda #Game_Const::ground
        clc
        adc #$00
        sta pos_y


        ldy #>Obs_0_Empty_Ani_Header
		ldx #<Obs_0_Empty_Ani_Header
		jsr Load_Animation


         ldy #>Obs_1_Empty_Ani_Header
		ldx #<Obs_1_Empty_Ani_Header
		jsr Load_Animation
        ; ldx #>Cone
		; ldy #<Cone
		; jsr Load
        

    rts


    Update:
        lda obsticles_active_flag
        beq @done

        lda scroll
        cmp screen_pos_x
        bcc @done

        lda obsticles_inFrame_flag
        bne @cont
            lda #1
            sta obsticles_inFrame_flag
            ldy #Obstical_t::animation_header_addr
            lda (header_pt_LO), Y
            tax

            iny
            lda (header_pt_LO), Y
            tay
            jsr Load_Animation

        @cont:

        lda pos_x
        sec 
        sbc amount_to_scroll
        sta pos_x
     



        ; lda pos_x
        ; sec
        ; sbc scroll
        ; sta pos_x
        clc
        lda pos_x
        cmp #$10
        bcs @dont_hide_obs

            lda #$F8
            sta pos_x 
            lda #0
            sta obsticles_active_flag
           ; lda #0
            sta obsticles_inFrame_flag
            ldy #Animation_Header_t::flags
            lda obs1_header_table, Y
            and #<~ACTIVE
            sta obs1_header_table, Y

            ldy #Animation_Header_t::flags
            lda obs0_header_table, Y
            and #<~ACTIVE
            sta obs0_header_table, Y


                ldy #Sprite_Positions_e::obst_1_x
            lda pos_x
            sta Sprite_positions_table, y
            iny 
            lda pos_y
            sta Sprite_positions_table, y

            ldy #Sprite_Positions_e::obst_0_x
            lda pos_x
            sta Sprite_positions_table, y
            iny 
            lda pos_y
            sta Sprite_positions_table, y

            jmp @done
        @dont_hide_obs:
           
        ldy #Sprite_Positions_e::obst_1_x
		lda pos_x
		sta Sprite_positions_table, y
		iny 
		lda pos_y
		sta Sprite_positions_table, y

        ldy #Sprite_Positions_e::obst_0_x
		lda pos_x
		sta Sprite_positions_table, y
		iny 
		lda pos_y
		sta Sprite_positions_table, y

        @done: 
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

        lda #1
        sta obsticles_active_flag

        ldy #Obstical_t::pos_x
        lda (header_pt_LO), Y
        sta screen_pos_x

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

        ; iny
        ; lda (header_pt_LO), Y
        ; tax

        ; iny
        ; lda (header_pt_LO), Y
        ; tay
        ; jsr Load_Animation

       
        @done:
    rts
    Remove:
        ldy #Animation_Header_t::flags
        lda obs1_header_table, Y
        and #<~ACTIVE
        sta obs1_header_table, Y

        ldy #Animation_Header_t::flags
        lda obs0_header_table, Y
        and #<~ACTIVE
        sta obs0_header_table, Y

    rts 
.endscope







