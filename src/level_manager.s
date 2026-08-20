
.include "inc/level_manager.inc"


Update_level:
    lda level
    cmp #NUM_LEVELS
    bcc @cont
        jsr Game::WIN_Init
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
    jsr ScManager::Load_Level_Data
    lda #0
rts



Next_Level_Loop:
    ;load level number screen
    LDA #%00000000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA PpuCtrl
    LDA #%00000000   ; enable sprites, enable background, no clipping on left side
    STA PpuMask   

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
    sta ::game_state
    jsr ScManager::Init
    jsr Obsticles::Init
    jsr Chaser::Reset
    jsr Player::Init 

    @done:

    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA PpuCtrl
    sta bg_chr_rom_start_addr
    LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    STA PpuMask
    sta bg_sprite_on_off
rts



Level_Restart_Loop:
    jsr Animation::Update
    jsr Player::Update
    jsr UpdateButtons
    jsr Update_Score
    lda Port_1_Pressed_Buttons
        
    beq @done
        LDA #%00000000   ;disable nmi
        STA PpuCtrl
        LDA #%00000000   ; disable rendering
        STA PpuMask  
        lda #0
        ; sta score_HI
        ; sta score_LO
        sta scroll
        sta scroll_HI
        lda #Game_States_e::running
        sta ::game_state 
        jsr ScManager::Init
        jsr Obsticles::Init
        jsr Chaser::Reset
        jsr Player::Init 
    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA PpuCtrl
    sta bg_chr_rom_start_addr
    LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    STA PpuMask  
    sta bg_sprite_on_off
    @done:
rts


