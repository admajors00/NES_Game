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
OBS_ON_SCREEN_F = 1<<0 ;
OBS_OFF_SCREEN_F = 1<<1 ;obstical is in the upcoming background but is not displayed yet
OBS_IN_QUEUE = 1<<2
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
    
    temp_obst_HI=$5A
    temp_obst_LO=$5B
    obsticle_index = $5e
    internal_flags = $5f


    Init:
        lda #$00
        sta screen_pos_x
        sta obsticles_active_flag
        sta internal_flags
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
        
        ldy #>Indicator_Ani_Header
		ldx #<Indicator_Ani_Header
		jsr Load_Animation
        
        

    rts


    Update:
        lda obsticles_active_flag ;this is set when ther is an obsticle in the upcoming frame
        beq @done

        lda internal_flags;check if obs already on screen
        and #OBS_ON_SCREEN_F
        bne @obs_on_screen

        lda scroll ;check if obs is on screan now
        cmp screen_pos_x;dont want to draw the obstical until its actually in the frame
        bcs @obs_on_screen
            lda internal_flags
            and #OBS_OFF_SCREEN_F
            bne @done
                lda internal_flags
                ora #OBS_OFF_SCREEN_F
                sta internal_flags

                ldy #Animation_Header_t::flags
                lda indicator_header_table, Y
                ora #ACTIVE
                sta indicator_header_table, Y
                JMP @done
        @obs_on_screen:
        lda internal_flags;only want to load obsticl animation once so branc
        and #OBS_ON_SCREEN_F
        bne @cont
            lda internal_flags
            ora #OBS_ON_SCREEN_F
            and #<~OBS_OFF_SCREEN_F
            sta internal_flags
            ldy #Obstical_t::animation_header_addr
            lda (header_pt_LO), Y
            tax

            iny
            lda (header_pt_LO), Y
            tay
            jsr Load_Animation

            ldy #Animation_Header_t::flags ;obstial is now on screen so turn off indicator
            lda indicator_header_table, Y
            and #<~ACTIVE
            sta indicator_header_table, Y

        @cont:

        lda pos_x
        sec 
        sbc amount_to_scroll
        sta pos_x
        clc
        lda pos_x
        cmp #$08
        bcs @dont_hide_obs
            ;remove obstical from frame as it scrolls off the screen
          
            jsr Remove
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

    Remove:
        lda #$F8
        sta pos_x 

        lda internal_flags
        and #<~OBS_ON_SCREEN_F
        and #<~OBS_OFF_SCREEN_F
        sta internal_flags

        lda #0
        sta obsticles_active_flag

        

        ldy #Animation_Header_t::flags
        lda obs1_header_table, Y
        and #<~ACTIVE
        sta obs1_header_table, Y

        ldy #Animation_Header_t::flags
        lda obs0_header_table, Y
        and #<~ACTIVE
        sta obs0_header_table, Y

        LDA internal_flags
        AND #OBS_IN_QUEUE
        beq @done
            LDA internal_flags
            AND #<~OBS_IN_QUEUE
            sta internal_flags
            ldx temp_obst_LO
            ldy temp_obst_HI
            jmp Load 
        ; ldy #Sprite_Positions_e::obst_1_x
        ; lda pos_x
        ; sta Sprite_positions_table, y
        ; iny 
        ; lda pos_y
        ; sta Sprite_positions_table, y

        ; ldy #Sprite_Positions_e::obst_0_x
        ; lda pos_x
        ; sta Sprite_positions_table, y
        ; iny 
        ; lda pos_y
        ; sta Sprite_positions_table, y
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

        lda obsticles_active_flag
        beq @no_obs_loaded
            lda internal_flags
            ora #OBS_IN_QUEUE
            sta internal_flags
            stx temp_obst_LO
            sty temp_obst_HI
            jmp @done

        @no_obs_loaded:
        stx header_pt_LO
        sty header_pt_HI

        lda #1
        sta obsticles_active_flag
        ; lda #0
        ; ; and #<~OBS_ON_SCREEN_F
        ; ; and #<~OBS_OFF_SCREEN_F
        ; sta internal_flags
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

.endscope







