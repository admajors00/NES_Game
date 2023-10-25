
; .IFNDEF GAME_INC
; GAME_INC =1
.include "/inc/game.inc"

HIT_OBST_f = 1<< 0
HIT_CHASER_f = 1<<1

.scope Game
    ;some game constants
    score_HI = $71
    score_LO = $70
    hit_flag = $72
    lives = $73
    game_state = $74


    Init:
        lda #3
        sta lives
        lda #Game_States_e::start_screen
        sta game_state

        lda #0
        sta score_HI
        sta score_LO
        

    rts

    game_state_jump_table:
        .addr Start_Screen_Loop, Game_Loop, Paused_Loop, GameOver_Loop, Level_Restart_Loop

    Update:
        lda game_state
        asl
        tax
        LDA game_state_jump_table, x
        STA main_pointer_LO
        LDA game_state_jump_table+1, x
        STA main_pointer_HI
        jmp (main_pointer_LO)
    rts



    Start_Screen_Loop:
        jsr Animation::Update
        jsr UpdateButtons
        ;jsr Update_Score
        lda #BUTTON_START
        and Port_1_Pressed_Buttons
        beq @done
            
           
            ldx #<music_data_untitled
            ldy #>music_data_untitled
            lda #1 ; NTSC
            jsr famistudio_init
            lda #0
            jsr famistudio_music_play

            jsr Init
            jsr Background::Init
            jsr Chaser::Init
            jsr Player::Init

            lda #Game_States_e::running
            sta game_state
        @done:
    rts

    Game_Loop:
       
        jsr Background::Update 
        jsr Obsticles::Update
        jsr Check_For_Hit
        jsr Animation::Update
        
        jsr UpdateButtons
        
        jsr Player::Update
        jsr Chaser::Update
       
        jsr Update_Score
    rts


    Paused_Loop:

    rts

    GameOver_Loop:
        
        LDA #%00000000   ;disable nmi
        STA $2000
        LDA #%00000000   ; disable rendering
        STA $2001    

        ;jsr Background::Draw_Box
        lda#0
        sta nametable
        sta scroll
        lda #Game_States_e::start_screen
        sta game_state   

        ldx #<music_data_get_fucked
        ldy #>music_data_get_fucked
        lda #1 ; NTSC
        jsr famistudio_init

        lda #0
        jsr famistudio_music_play


        
        LDA #<End_Screen
        STA bg_data_pt_LO           ; put the low byte of address of background into pointer
        LDA #>End_Screen       ; #> is the same as HIGH() function in NESASM, used to get the high byte
        STA bg_data_pt_HI           ; put high byte of address into pointer
        jsr Background::load_background_nt1
       



        LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
        STA $2000
        LDA #%00011110   ; enable sprites, enable background, no clipping on left side
        STA $2001  
        
       

    rts

    Level_Restart_Loop:
        jsr Animation::Update
        jsr UpdateButtons
        jsr Update_Score
        lda Port_1_Pressed_Buttons
         
        beq @done
            lda #0
            sta score_HI
            sta score_LO
            sta scroll
            sta scroll_HI
            lda #Game_States_e::running
            sta game_state 
            jsr Background::Init
            jsr Chaser::Init
            jsr Player::Init  
        @done:
    rts
    Check_For_Hit:
        lda obsticles_active_flag
        beq @done
        lda Obsticles::pos_x
        clc
        cmp Player::pos_x_HI
        bcc @check_Chaser
        sec
        sbc Obsticles::length
        clc
        cmp Player::pos_x_HI
        bcc check_obst_hit
        
        @check_Chaser:
        lda #<~HIT_OBST_f
        and hit_flag
        sta hit_flag
        lda Chaser::pos_x_HI
        clc
        cmp Player::pos_x_HI
        bcc @done
        sec
        sbc #8
        clc
        cmp Player::pos_x_HI
        bcc check_chaser_hit
        
        jmp @done

        @done: 
        lda #<~HIT_CHASER_f
        and hit_flag
        sta hit_flag

        
    rts

    check_obst_hit:;the players x value is inside the obstical
        lda Obsticles::pos_y
        sec
        sbc Obsticles::height
        clc
        cmp Player::pos_y_HI
        bcs @above_obst ;jump if the player is above the obstical

        lda #HIT_OBST_f
        and hit_flag
        bne @done ;jump if the player has already hit the obsticle
            lda #HIT_OBST_f
            ora hit_flag
            sta hit_flag
            lda player_input_flags_g
            ora #PLAYER_HIT_DETECTED_f
            sta player_input_flags_g
            ldx lives
            beq dead
                ; lda #3
                ; sta lives
                ; jmp @done
            dex
            stx lives
            lda #Game_States_e::level_restart
            sta game_state  
            jmp @done
        
        @above_obst:
            
            lda score_LO
            clc
            adc Player::player_action_state
            ;adc Player::velocity_x_HI
            sta score_LO
            lda score_HI
            adc#0
            sta score_HI
            jmp @done
        @done:
    rts
            ; lda #Player::PlayerActionStates::crash
            ; sta Player::player_action_state
    check_chaser_hit:
        lda #HIT_CHASER_f
        and hit_flag
        bne @done ;jump i the player has already hit the obsticle
            lda #HIT_CHASER_f
            ora hit_flag
            sta hit_flag
            lda player_input_flags_g
            ora #PLAYER_HIT_DETECTED_f
            sta player_input_flags_g
            ldx lives
            beq dead
                ; lda #3
                ; sta lives
                ; jmp @done
            dex
            lda #Game_States_e::level_restart
            sta game_state
            stx lives
            jmp @done
    @done:
    rts

    dead:
        lda #Game_States_e::game_over
        sta game_state
        jmp @done
        @done:
    rts

    crashed: 
.endscope

; .ENDIF