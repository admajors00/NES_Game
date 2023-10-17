
; .IFNDEF GAME_INC
; GAME_INC =1
.include "/inc/game.inc"
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
    rts

    game_state_jump_table:
        .addr Start_Screen_Loop, Game_Loop, Paused_Loop, GameOver_Loop

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
        jsr UpdateButtons
        lda #BUTTON_START
        and Port_1_Pressed_Buttons
        beq @done
            ; LDA #<Longer_street_1
            ; STA main_pointer_LO           ; put the low byte of address of background into pointer
            ; LDA #>Longer_street_1        ; #> is the same as HIGH() function in NESASM, used to get the high byte
            ; STA main_pointer_HI           ; put high byte of address into pointer
            ; jsr Background::load_background
            ; 	LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
            ; ;	ORA nametable    ; select correct nametable for bit 0
            ; STA $2000
            ; inc scroll
            ; lda #$01
            ; sta scroll_HI
            jsr Init
            jsr Chaser::Init
            jsr Player::init_character

            lda #Game_States_e::running
            sta game_state
        @done:
    rts

    Game_Loop:
        ; jsr Handle_Scroll

	    ; jsr famistudio_update
        jsr Background::Update 
        jsr Obsticles::Update
        jsr Check_For_Hit
        jsr Animation::Update
        
        jsr UpdateButtons
        
        jsr Player::updatePlayer
        jsr Chaser::Update
       
        jsr Update_Score
    rts


    Paused_Loop:

    rts

    GameOver_Loop:
        lda #Game_States_e::start_screen
        sta game_state
    rts

    Check_For_Hit:
        lda active_flag
        beq @done
        lda Obsticles::pos_x
        clc
        cmp Player::pos_x_HI
        bcc @done
        sec
        sbc Obsticles::length
        clc
        cmp Player::pos_x_HI
        bcc @check_hit


        lda #0
        sta hit_flag
        jmp @done



        @check_hit:;the players x value is inside the obstical
            lda Obsticles::pos_y
            sec
            sbc Obsticles::height
            clc
            cmp Player::pos_y_HI
            bcs @not_hit ;jump if the player is above the obstical

            lda hit_flag
            bne @done ;jump i the player has already hit the obsticle

            adc #1
            sta hit_flag
            lda #0
            sta Player::velocity_x_HI
            sta Player::velocity_x_LO
            ldx lives
            beq @dead
                ; lda #3
                ; sta lives
                ; jmp @done
            dex
            stx lives
            jmp @done
            @dead:
                lda #Game_States_e::game_over
                sta game_state
                jmp @done
            @not_hit:
                
                lda score_LO
                clc
                adc Player::player_action_state
                ;adc Player::velocity_x_HI
                sta score_LO
                lda score_HI
                adc#0
                sta score_HI
            

            ; lda #Player::PlayerActionStates::crash
            ; sta Player::player_action_state
        
        @done:
    rts

.endscope

; .ENDIF