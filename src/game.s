
; .IFNDEF GAME_INC
; GAME_INC =1
.include "/inc/game.inc"
.include "/inc/level_manager.inc"



.scope Game


    game_state_jump_table:
        .addr Start_Screen_Loop, Game_Loop, Paused_Loop, GameOver_Loop, Level_Restart_Loop, Next_Level_Loop, Intro_Loop, WIN_Loop


    Init:
        lda #Game_Const::number_of_lives
        sta ::lives
        lda #Game_States_e::start_screen
        sta ::game_state

        lda #0
        sta ::score_HI
        sta ::score_LO
        sta ::level
    rts 

    

    Update:
        lda ::game_state
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
        STA PpuCtrl
        LDA #%00000000   ; disable sprites, enable background, no clipping on left side
        STA PpuMask
        lda #Game_States_e::start_screen
        sta ::game_state

        lda scroll_flags
        AND #<~STATUS_BAR_FLAG
        sta scroll_flags
        
        ldx #<palette_TitleScreen
        ldy #>palette_TitleScreen
        jsr load_palettes
        
        jsr famistudio_music_pause
        LDA #<TitleScreen_bg
        STA bg_data_pt_LO           ; put the low byte of address of background into pointer
        LDA #>TitleScreen_bg        ; #> is the same as HIGH() function in NESASM, used to get the high byte
        STA bg_data_pt_HI   
        LDA #<TitleScreen_at
        STA at_data_pt_LO           
        LDA #>TitleScreen_at        
        STA at_data_pt_HI  
         
        ldx $00        ; put high byte of address into pointer
        jsr BgManager::RLE::Load_RLE_Background
        ldx $00
        jsr BgManager::RLE::Decode_RLE_Background_Attribute_Table_Into_PPU
        lda #0
        sta nametable
        sta scroll
        jsr BankSwitch

        LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
        STA PpuCtrl
        sta bg_chr_rom_start_addr

        LDA #%00001110   ; enable sprites, enable background, no clipping on left side
        STA PpuMask
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
        STA PpuCtrl
        LDA #%00000000   ; disable sprites, enable background, no clipping on left side
        STA PpuMask   

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
        jsr ScManager::Init
        jsr Obsticles::Init
        jsr Chaser::Init
        jsr Player::Init
      
        lda #Game_States_e::running
        sta ::game_state


        LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
        STA PpuCtrl
        sta bg_chr_rom_start_addr
        LDA #%00011110   ; enable sprites, enable background, no clipping on left side
        STA PpuMask
        sta bg_sprite_on_off
    rts



    Game_Loop:
        ldy #Level_t::num_screens
        lda scroll_HI
        cmp (level_pt_LO),y
        bcc @cont
            inc ::level
            lda #Game_States_e::next_level
            sta ::game_state
        @cont:
        jsr Update_Score
        jsr Obsticles::Update
        jsr ScManager::Update 
        
        jsr Check_For_Hit
       
        jsr Animation::Update
        
        jsr UpdateButtons
        lda #BUTTON_SELECT
        and Port_1_Pressed_Buttons
        beq @cont2
            lda #Game_States_e::paused
            sta ::game_state
        @cont2:
        
        jsr Player::Update
        jsr Chaser::Update
       
        jsr Add_Tricks_To_Score

        
        @done:
    rts



    Intro_Init:
        LDA #%00000000   ; disable NMI
        STA PpuCtrl
        LDA #%00000000   ; disable sprites, enable background, no clipping on left side
        STA PpuMask 
        lda scroll_flags
        AND #<~STATUS_BAR_FLAG
        sta scroll_flags

        lda #80
        sta timer

        ldx #<Intro_h
        ldy #>Intro_h
        jsr ScManager::Load_Level_Data
        jsr ScManager::Init
        lda #Game_States_e::intro
        sta ::game_state

        LDA #%10000000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 0
        STA PpuCtrl
        sta bg_chr_rom_start_addr
        LDA #%00001110   ; disable sprites, enable background, no clipping on left side
        STA PpuMask
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
            jsr ScManager::Update

        @done:
    rts



    Infinite_Init:
        LDA #%00000000   ; disable NMI
        STA PpuCtrl
        LDA #%00000000   ; disable sprites, enable background, no clipping on left side
        STA PpuMask 
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
        jsr ScManager::Load_Level_Data
        jsr ScManager::Init
        jsr Obsticles::Init
        jsr Chaser::Init
        jsr Player::Init
        
        LDA #Game_Const::chaser_max_speed_LO
        STA Chaser::velocity_x_LO
        LDA #Game_Const::chaser_max_speed_HI
        STA Chaser::velocity_x_HI

        lda #Game_States_e::running
        sta ::game_state

        LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 0
        STA PpuCtrl
        sta bg_chr_rom_start_addr
        LDA #%00011110     ; disable sprites, enable background, no clipping on left side
        STA PpuMask
        sta bg_sprite_on_off
    rts

   

    Paused_Loop:
        jsr UpdateButtons
        lda #BUTTON_SELECT
        and Port_1_Pressed_Buttons
        beq @cont
            lda #Game_States_e::running
            sta ::game_state
        @cont:
        lda #BUTTON_START
        and Port_1_Pressed_Buttons
        beq @done
            JMP Start_Screen_Init
        @done:
    rts



    Game_Over_Init:
        LDA #%00000000   ;disable nmi
        STA PpuCtrl
        LDA #%00000000   ; disable rendering
        STA PpuMask    

        lda scroll_flags
        AND #<~STATUS_BAR_FLAG
        sta scroll_flags

        lda#0
        sta nametable
        sta scroll
        lda #Game_States_e::game_over
        sta ::game_state   

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
        LDA #<EndScreen_bg
        STA bg_data_pt_LO           ; put the low byte of address of background into pointer
        LDA #>EndScreen_bg       ; #> is the same as HIGH() function in NESASM, used to get the high byte
        STA bg_data_pt_HI           ; put high byte of address into pointer
        LDA #<EndScreen_at
        STA at_data_pt_LO           
        LDA #>EndScreen_at        
        STA at_data_pt_HI
        ldx $00
        jsr BgManager::RLE::Load_RLE_Background
        ldx $00
        jsr BgManager::RLE::Decode_RLE_Background_Attribute_Table_Into_PPU

        LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
        STA PpuCtrl
        sta bg_chr_rom_start_addr
        LDA #%00011110   ; enable sprites, enable background, no clipping on left side
        STA PpuMask  
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
        STA PpuCtrl
        LDA #%00000000   ; disable rendering
        STA PpuMask    

        lda scroll_flags
        AND #<~STATUS_BAR_FLAG
        sta scroll_flags

        lda#0
        sta nametable
        sta scroll
        lda #Game_States_e::win
        sta ::game_state   

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
        LDA #<WinScreen_bg
        STA bg_data_pt_LO           ; put the low byte of address of background into pointer
        LDA #>WinScreen_bg       ; #> is the same as HIGH() function in NESASM, used to get the high byte
        STA bg_data_pt_HI           ; put high byte of address into pointer
        LDA #<WinScreen_at
        STA at_data_pt_LO           
        LDA #>WinScreen_at        
        STA at_data_pt_HI
        ldx $00
        jsr BgManager::RLE::Load_RLE_Background
        ldx $00
        jsr BgManager::RLE::Decode_RLE_Background_Attribute_Table_Into_PPU
        
        LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
        STA PpuCtrl
        sta bg_chr_rom_start_addr
        LDA #%00011110   ; enable sprites, enable background, no clipping on left side
        STA PpuMask  
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
            lda #<~::HIT_OBST_f
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

            lda #::HIT_OBST_f
            and hit_flag
            bne @done ;jump if the player has already hit the obsticle
                lda #::HIT_OBST_f
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
    
                    ldx ::lives
                    beq dead
 
                    dex
                    stx ::lives
                    
                    lda #Game_States_e::level_restart
                    sta ::game_state  
                    jmp @done

                @rough:
                    lda player_input_flags_g
                    ora #PLAYER_ROUGH_DETECTED_f
                    sta player_input_flags_g
                    lda #<~::HIT_OBST_f
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
            lda #<~::HIT_CHASER_f
            and hit_flag
            sta hit_flag
            jmp @done

        @check_hit:
                lda #::HIT_CHASER_f
                ora hit_flag
                sta hit_flag
                lda player_input_flags_g
                ora #PLAYER_GRAB_DETECTED_f
                sta player_input_flags_g
                ldx ::lives
                beq dead
      
                dex
                lda #Game_States_e::level_restart
                sta ::game_state
                stx ::lives
                jmp @done
        @done:
    rts



    dead:
        jmp Game_Over_Init
    rts



    Add_Obstical_To_Score:
        lda ::score_LO
        clc
        adc #10

        sta ::score_LO
        lda ::score_HI
        adc#0
        sta ::score_HI

        lda ::score_LO
        clc
        adc Player::velocity_x_HI

        sta ::score_LO
        lda ::score_HI
        adc#0
        sta ::score_HI

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


            clc
            lda ::score_LO
            
            adc Player::player_action_state
            sta ::score_LO
            lda ::score_HI
            adc #0
            sta ::score_HI
        @done:
    rts



.endscope