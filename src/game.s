
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

    timer = $75

    level_pt_LO= $76
    level_pt_HI = $77
    level = $78

    Init:
        lda #3
        sta lives
        lda #Game_States_e::start_screen
        sta game_state

        lda #0
        sta score_HI
        sta score_LO
        sta level
        

    rts

    Update_level:

        lda level
        cmp #NUM_LEVELS
        bcc @cont
            lda #0
            sta level
        @cont:
        asl 
        tay
        lda Levels_table,Y
        sta level_pt_LO
        iny 
        lda Levels_table,Y
        sta level_pt_HI
        ldx level_pt_LO
        ldy level_pt_HI
        jsr Background::Load_Level_Background_Data

        
    rts

    game_state_jump_table:
        .addr Start_Screen_Loop, Game_Loop, Paused_Loop, GameOver_Loop, Level_Restart_Loop, Next_Level_Loop

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
        ;jsr Animation::Update
        jsr UpdateButtons
        lda score_LO 
        ; beq @cont
        ;     jsr Update_Score
        ; @cont:
        lda #BUTTON_START
        and Port_1_Pressed_Buttons
        beq @done
           
       
            LDA #%00000000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
            STA $2000
            LDA #%00000000   ; enable sprites, enable background, no clipping on left side
            STA $2001   
           
            ldx #<music_data_untitled
            ldy #>music_data_untitled
            lda #1 ; NTSC
            jsr famistudio_init
            lda #0
            jsr famistudio_music_play

            jsr Init
            jsr Status_Bar_Init
            jsr Update_level
            jsr Background::Init
            jsr Obsticles::Init
            jsr Chaser::Init
            jsr Player::Init

            lda #Game_States_e::running
            sta game_state

            lda #$3f
            sta $2006
            lda #$00
            sta $2006
            

            ldy #Level_t::bg_color
            lda (level_pt_LO), y
            sta $2007

            LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
            STA $2000
            LDA #%00011110   ; enable sprites, enable background, no clipping on left side
            STA $2001
        @done:
    rts

    Game_Loop:
       
        

        ldy #Level_t::num_screens
        lda (level_pt_LO),y
        cmp scroll_HI
        bne @cont
            inc level
            lda #Game_States_e::next_level
            sta game_state
        @cont:
        jsr Update_Score
        jsr Obsticles::Update
        jsr Background::Update 
        
        jsr Check_For_Hit
       
        jsr Animation::Update
        
        jsr UpdateButtons
        
        jsr Player::Update
        jsr Chaser::Update
       
        

        
        @done:
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

        jsr store_high_score

        ldx #<palette_TitleScreen
        ldy #>palette_TitleScreen
        jsr load_palettes
        lda #0
        jsr BankSwitch
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
        jsr Player::Update
        jsr UpdateButtons
        jsr Update_Score
        lda Port_1_Pressed_Buttons
         
        beq @done
            LDA #%00000000   ;disable nmi
            STA $2000
            LDA #%00000000   ; disable rendering
            STA $2001  
            lda #0
            ; sta score_HI
            ; sta score_LO
            sta scroll
            sta scroll_HI
            lda #Game_States_e::running
            sta game_state 
            jsr Background::Init
            jsr Obsticles::Init
            jsr Chaser::Reset
            jsr Player::Init 
            LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
        STA $2000
        LDA #%00011110   ; enable sprites, enable background, no clipping on left side
        STA $2001  
        @done:
    rts

    Next_Level_Loop:
        ;load level number screen wait for a minute 
        
		LDA #%00000000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
		STA $2000
		LDA #%00000000   ; enable sprites, enable background, no clipping on left side
		STA $2001   

         lda #Game_States_e::level_restart
            sta game_state 
	
        jsr Update_level

        lda Chaser::velocity_x_LO
        clc
        adc #$80
        sta  Chaser::velocity_x_LO
        lda  Chaser::velocity_x_HI
        adc #0
        sta Chaser::velocity_x_HI

	
		

		lda #2
		sta scroll_HI_prev
		ldy #0 
		sty scroll_HI
		sty scroll
		sty nametable
			
		; jsr Background::Next_Background
		; jsr Background::load_background_nt1
		; inc scroll_HI
		; jsr Background::Next_Background
		; jsr Background::load_background_nt2
		
		; jsr  Background::Reset_Buffers

		; ldy #0
		; sty scroll_HI
		; sty amount_to_scroll
		; sty column_number
		; jsr  Background::Next_Background
		;inc scroll
		
        lda #Game_States_e::running
        sta game_state 
        jsr Background::Init
        jsr Obsticles::Init
        jsr Chaser::Reset
        jsr Player::Init 

         lda #$3f
            sta $2006
            lda #$00
            sta $2006
            

            ldy #Level_t::bg_color
            lda (level_pt_LO), y
            sta $2007

		LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
		STA $2000
		LDA #%00011110   ; enable sprites, enable background, no clipping on left side
		STA $2001
       


    rts
    Check_For_Hit:
        jsr check_obst_hit
        jsr check_chaser_hit  
    rts


    check_obst_hit:;the players x value is inside the obstical
        lda obsticles_active_flag ;check if there are any obsticals on the scrren
       
        beq @not_over_obst
            lda Obsticles::pos_x
            clc
            cmp Player::pos_x_HI    ;check if player is inside of ostical
            bcc @not_over_obst
                sec
                sbc Obsticles::length
                clc
                cmp Player::pos_x_HI
                bcc @over_obst
        @not_over_obst:
            lda #<~HIT_OBST_f
            and hit_flag
            sta hit_flag
            jmp @done
        @over_obst:
            ;check if player is hitting or above obsticle
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

                lda Obsticles::type
                cmp #Obstical_Types_e::trip
                beq @trip

                lda Obsticles::type
                cmp #Obstical_Types_e::rough
                beq @rough

                lda Obsticles::type
                cmp #Obstical_Types_e::ramp
                beq @ramp
                @trip:
                    lda player_input_flags_g
                    ora #PLAYER_HIT_DETECTED_f
                    sta player_input_flags_g

                    ; lda #LIVES_CHANGE
                    ; ora status_bar_flags
                    ; sta status_bar_flags
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
                @rough:
                    lda player_input_flags_g
                    ora #PLAYER_ROUGH_DETECTED_f
                    sta player_input_flags_g
                    lda #<~HIT_OBST_f
                    and hit_flag
                    sta hit_flag
                    jmp @done
                @ramp:
                    lda player_input_flags_g
                    ora #PLAYER_RAMP_DETECTED_f
                    sta player_input_flags_g
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

                lda score_LO
                clc
                adc Player::velocity_x_HI
                ;adc Player::velocity_x_HI
                sta score_LO
                lda score_HI
                adc#0
                sta score_HI

                lda #SCORE_CHANGE
                ora status_bar_flags
                sta status_bar_flags
                jmp @done
        @done:
    rts
            ; lda #Player::PlayerActionStates::crash
            ; sta Player::player_action_state
    check_chaser_hit:
        lda Chaser::pos_x_HI
        clc
        cmp Player::pos_x_HI
        bcc @not_grabed
        sec
        sbc #8
        clc
        cmp Player::pos_x_HI
        bcc @check_hit
        @not_grabed:
            lda #<~HIT_CHASER_f
            and hit_flag
            sta hit_flag
            jmp @done

        @check_hit:

            ; lda #HIT_CHASER_f
            ; and hit_flag
            ; bne @done ;jump i the player has already hit the obsticle
                lda #HIT_CHASER_f
                ora hit_flag
                sta hit_flag
                lda player_input_flags_g
                ora #PLAYER_GRAB_DETECTED_f
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

.endscope

; .ENDIF