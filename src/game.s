
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

    game_state_jump_table:
        .addr Start_Screen_Loop, Game_Loop, Paused_Loop, GameOver_Loop, Level_Restart_Loop, Next_Level_Loop, Intro_Loop, WIN_Loop

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
           jsr WIN_Init
           lda #1
           rts

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
        lda #0
        
    rts

    
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

    Start_Screen_Init:
        LDA #%00000000   ; disable NMI
        STA $2000
        LDA #%00000000   ; disable sprites, enable background, no clipping on left side
        STA $2001
        lda #Game_States_e::start_screen
        sta game_state

        lda scroll_flags
        AND #<~STATUS_BAR_FLAG
        sta scroll_flags
        
        ldx #<palette_TitleScreen
        ldy #>palette_TitleScreen
        jsr load_palettes
        

        LDA #<Start_Screen
        STA bg_data_pt_LO           ; put the low byte of address of background into pointer
        LDA #>Start_Screen        ; #> is the same as HIGH() function in NESASM, used to get the high byte
        STA bg_data_pt_HI           ; put high byte of address into pointer
        jsr Background::load_background_nt1

        lda #0
        sta nametable
        sta scroll
        jsr BankSwitch
       
        ;jsr Game::Init




        LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
        STA $2000
        sta bg_chr_rom_start_addr

        LDA #%00001110   ; enable sprites, enable background, no clipping on left side
        STA $2001
        sta bg_sprite_on_off        
    rts

    Start_Screen_Loop:
      
        jsr UpdateButtons
       
        lda #BUTTON_SELECT
        and Port_1_Pressed_Buttons
        beq @cont
       
            jmp Infinite_Init
        @cont:
        lda #BUTTON_START
        and Port_1_Pressed_Buttons
        beq @done
           JMP Intro_Init
        @done:
    rts



    Start_Game:
        LDA #%00000000   ; disable NMI
        STA $2000
        LDA #%00000000   ; disable sprites, enable background, no clipping on left side
        STA $2001   

        lda scroll_flags
        ora #STATUS_BAR_FLAG
        sta scroll_flags

        lda scroll_flags
        AND #<~USE_RANDOM_BACKGROUND
        sta scroll_flags

        ldx #<music_data_untitled
        ldy #>music_data_untitled
        lda #1 ; NTSC
        jsr famistudio_init
        lda #0
        jsr famistudio_music_play

        jsr Animation::Init
        jsr Init
        jsr Status_Bar_Init
        jsr Update_level
        jsr Background::Init
        jsr Obsticles::Init
        jsr Chaser::Init
        jsr Player::Init
      
        lda #Game_States_e::running
        sta game_state


        LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
        STA $2000
        sta bg_chr_rom_start_addr
        LDA #%00011110   ; enable sprites, enable background, no clipping on left side
        STA $2001
        sta bg_sprite_on_off
    rts
    Game_Loop:
        ;lda scroll_flags
        ; and #USE_RANDOM_BACKGROUND
        ; bne @cont
            ldy #Level_t::num_screens
            lda scroll_HI
            cmp (level_pt_LO),y
            bcc @cont
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
        lda #BUTTON_SELECT
        and Port_1_Pressed_Buttons
        beq @cont2
            lda #Game_States_e::paused
            sta game_state
        @cont2:
        
        jsr Player::Update
        jsr Chaser::Update
       
        jsr Add_Tricks_To_Score

        
        @done:
    rts
    Intro_Init:
        LDA #%00000000   ; disable NMI
        STA $2000
        LDA #%00000000   ; disable sprites, enable background, no clipping on left side
        STA $2001 
        lda scroll_flags
        AND #<~STATUS_BAR_FLAG
        sta scroll_flags

        lda #80
        sta timer

        ldx #<Intro_h
        ldy #>Intro_h
        jsr Background::Load_Level_Background_Data
        jsr Background::Init
        lda #Game_States_e::intro
        sta game_state

        ; ldy #Level_t::bg_color
        ; lda Intro_h, y
        ; sta $2007

        LDA #%10000000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 0
        STA $2000
        sta bg_chr_rom_start_addr
        LDA #%0001110   ; disable sprites, enable background, no clipping on left side
        STA $2001
        sta bg_sprite_on_off
    rts

    Intro_Loop:
        jsr UpdateButtons
        lda #BUTTON_START
        and Port_1_Pressed_Buttons
        beq @cont
            jmp Start_Game
        @cont:
        ldy #Level_t::num_screens
        lda scroll_HI

        cmp Intro_h, Y
        beq @done

        dec timer
        bne @done
            lda #1
            sta timer
            sta amount_to_scroll
            jsr Background::Update

        @done:
    rts

    Infinite_Init:
        LDA #%00000000   ; disable NMI
        STA $2000
        LDA #%00000000   ; disable sprites, enable background, no clipping on left side
        STA $2001 
        lda scroll_flags
        ora #STATUS_BAR_FLAG
        sta scroll_flags


       lda scroll_flags
       ora #USE_RANDOM_BACKGROUND
       sta scroll_flags

        

        lda #$69
        sta rng_seed_LO
        lda #$42
        sta rng_seed_HI

        ldx #<music_data_untitled
        ldy #>music_data_untitled
        lda #1 ; NTSC
        jsr famistudio_init
        lda #0
        jsr famistudio_music_play
        
        
        jsr Animation::Init
        jsr Init
        jsr Status_Bar_Init
        
        
       
        ldx #<Level_Random_h
        stx level_pt_LO
        ldy #>Level_Random_h
        sty level_pt_HI
        jsr Background::Load_Level_Background_Data
        jsr Background::Init
        jsr Obsticles::Init
        jsr Chaser::Init
        jsr Player::Init
        

        LDA #Game_Const::chaser_max_speed_LO
        STA Chaser::velocity_x_LO
        LDA #Game_Const::chaser_max_speed_HI
        STA Chaser::velocity_x_HI
        ; ldy #Level_t::bg_color
        ; lda Intro_h, y
        ; sta $2007
        lda #Game_States_e::running
        sta game_state

        LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 0
        STA $2000
        sta bg_chr_rom_start_addr
        LDA #%00011110     ; disable sprites, enable background, no clipping on left side
        STA $2001
        sta bg_sprite_on_off
    rts

   
    Paused_Loop:
        jsr UpdateButtons
        lda #BUTTON_SELECT
        and Port_1_Pressed_Buttons
        beq @cont
            lda #Game_States_e::running
            sta game_state
        @cont:
        lda #BUTTON_START
        and Port_1_Pressed_Buttons
        beq @done
            JMP Start_Screen_Init
        @done:
    rts

    Game_Over_Init:
  
        LDA #%00000000   ;disable nmi
        STA $2000
        LDA #%00000000   ; disable rendering
        STA $2001    

        ;jsr Background::Draw_Box

        lda scroll_flags
        AND #<~STATUS_BAR_FLAG
        sta scroll_flags

        lda#0
        sta nametable
        sta scroll
        lda #Game_States_e::game_over
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
        lda #1
        jsr BankSwitch
        LDA #<End_Screen
        STA bg_data_pt_LO           ; put the low byte of address of background into pointer
        LDA #>End_Screen       ; #> is the same as HIGH() function in NESASM, used to get the high byte
        STA bg_data_pt_HI           ; put high byte of address into pointer
        jsr Background::load_background_nt1
       

        
        LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
        STA $2000
        sta bg_chr_rom_start_addr
        LDA #%00011110   ; enable sprites, enable background, no clipping on left side
        STA $2001  
        sta bg_sprite_on_off

    rts
    GameOver_Loop:
        jsr UpdateButtons
        lda #BUTTON_START
        and Port_1_Pressed_Buttons
        beq @done
            jmp Start_Screen_Init
        @done:
    rts


    WIN_Init:
  
        LDA #%00000000   ;disable nmi
        STA $2000
        LDA #%00000000   ; disable rendering
        STA $2001    

        ;jsr Background::Draw_Box

        lda scroll_flags
        AND #<~STATUS_BAR_FLAG
        sta scroll_flags

        lda#0
        sta nametable
        sta scroll
        lda #Game_States_e::win
        sta game_state   

        ldx #<music_data_get_fucked
        ldy #>music_data_get_fucked
        lda #1 ; NTSC
        jsr famistudio_init

        

        jsr store_high_score
        ldx #<palette_TitleScreen
        ldy #>palette_TitleScreen
        jsr load_palettes
        lda #1
        jsr BankSwitch
        LDA #<WIN_Screen
        STA bg_data_pt_LO           ; put the low byte of address of background into pointer
        LDA #>WIN_Screen       ; #> is the same as HIGH() function in NESASM, used to get the high byte
        STA bg_data_pt_HI           ; put high byte of address into pointer
        jsr Background::load_background_nt1
       

        
        LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
        STA $2000
        sta bg_chr_rom_start_addr
        LDA #%00011110   ; enable sprites, enable background, no clipping on left side
        STA $2001  
        sta bg_sprite_on_off
    rts
    WIN_Loop:
        jsr UpdateButtons
        lda #BUTTON_START
        and Port_1_Pressed_Buttons
        beq @done
            jmp Start_Screen_Init
        @done:
    rts
    ; Instructions_Init:
  
    ;     LDA #%00000000   ;disable nmi
    ;     STA $2000
    ;     LDA #%00000000   ; disable rendering
    ;     STA $2001    

    ;     ;jsr Background::Draw_Box

    ;     lda scroll_flags
    ;     AND #<~STATUS_BAR_FLAG
    ;     sta scroll_flags

    ;     lda #0
    ;     sta nametable
    ;     sta scroll
    ;     jsr BankSwitch

    ;     lda #Game_States_e::instructions  
    ;     sta game_state
    ;     jsr store_high_score
        
    ;     ldx #<palette_Instructions
    ;     ldy #>palette_Instructions
    ;     jsr load_palettes
        
    ;     LDA #<Instructions_Screen
    ;     STA bg_data_pt_LO           ; put the low byte of address of background into pointer
    ;     LDA #>Instructions_Screen       ; #> is the same as HIGH() function in NESASM, used to get the high byte
    ;     STA bg_data_pt_HI           ; put high byte of address into pointer
    ;     jsr Background::load_background_nt1
       
    ;     lda #$3f
	; 	sta $2006
	; 	lda #$00
	; 	sta $2006
	; 	lda #$0f
	; 	sta $2007
        
    ;     LDA #%10000000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    ;     STA $2000
    ;     sta bg_chr_rom_start_addr
    ;     LDA #%00001110   ; enable sprites, enable background, no clipping on left side
    ;     STA $2001 
    ;     sta bg_sprite_on_off 

    ; rts

    ; Instruction_Loop:
    ;     jsr UpdateButtons
    ;     lda #BUTTON_SELECT
    ;     and Port_1_Pressed_Buttons
    ;     beq @done
    ;         jmp Start_Screen_Init
    ;     @done:
    ; rts

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
        sta bg_chr_rom_start_addr
        LDA #%00011110   ; enable sprites, enable background, no clipping on left side
        STA $2001  
        sta bg_sprite_on_off
        @done:
    rts

    Next_Level_Loop:
        ;load level number screen wait for a minute 
        
		LDA #%00000000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
		STA $2000
		LDA #%00000000   ; enable sprites, enable background, no clipping on left side
		STA $2001   

        ; lda #Game_States_e::level_restart
        ; sta game_state 
	
        jsr Update_level
        bne @done

        lda Chaser::velocity_x_HI       
        cmp #Game_Const::chaser_max_speed_HI;if chaser velocity hi is les than ax hi then add speed
        bcc @cont;if cchaser velocity hi is equal to max then chek low
            bne @skip
            lda Chaser::velocity_x_LO;if velocity lo is greater than or equal to max lo then skip
            cmp #Game_Const::chaser_max_speed_LO
            bcs  @skip   
		@cont:
            lda Chaser::velocity_x_LO
            clc
            adc #Game_Const::chaser_speed_increase
            sta  Chaser::velocity_x_LO
            lda  Chaser::velocity_x_HI
            adc #0
            sta Chaser::velocity_x_HI
        @skip:

		lda #2
		sta scroll_HI_prev
		ldy #0 
		sty scroll_HI
		sty scroll
		sty nametable
	
		
        lda #Game_States_e::running
        sta game_state 
        jsr Background::Init
        jsr Obsticles::Init
        jsr Chaser::Reset
        jsr Player::Init 

        @done:

		LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
		STA $2000
        sta bg_chr_rom_start_addr
		LDA #%00011110   ; enable sprites, enable background, no clipping on left side
		STA $2001
        sta bg_sprite_on_off
       


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
                jmp Add_Obstical_To_Score
                
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
        jmp Game_Over_Init
    rts

    Add_Obstical_To_Score:
        lda score_LO
        clc
        adc #10
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
    rts
    Add_Tricks_To_Score:
        lda Player::player_movement_state
        cmp #Player::PlayerMovementStates::inAirMoving
        bne @done
            lda #SCORE_CHANGE
            ora status_bar_flags
            sta status_bar_flags

            ; lda #Game_Const::ground
            ; sec
            ; sbc Player::pos_y_HI
            ; lsr a
            ; lsr A
            ; lsr A
            
            ; sta main_temp

            ;  clc
            ; lda score_LO
           
            ; adc main_temp
            ; sta score_LO
            ; lda score_HI
            ; adc #0
            ; sta score_HI

            clc
            lda score_LO
            
            adc Player::player_action_state
            sta score_LO
            lda score_HI
            adc #0
            sta score_HI
        @done:
    rts
.endscope

; .ENDIF