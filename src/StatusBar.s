
UPPER_4 = %11110000
LOWER_4 = %00001111


SCORE_CHANGE = 1 << 0
DISP_HIGH_SCORE = 1<<1
LIVES_CHANGE = 1 << 2


ten_thousands_place = $60
thousands_place = $61
hundreds_place = $62
tens_place = $63
ones_place = $64



temp_score_HI = $65
temp_score_LO = $66

status_oam_size = $67

score_pos_x_ = $68
status_bar_flags = $69
score_pos_y_ = $6A

high_score_HI = $6B
high_score_LO = $6C

status_oam_index = $6D


TEN_THOUSANDS_HI = $27
TEN_THOUSANDS_LO = $10

THOUSANDS_HI = $03
THOUSANDS_LO = $e8


HUNDRED = $64
TEN = $0a
ONE = $01
HIGH_SCORE_POS_Y = $20

SCORE_POS_X = $58
SCORE_POS_Y = $28

LEVEL_POS_X = $C8
LEVEL_POS_Y = $1F

LIVES_POS_X = $C0
LIVES_POS_Y = $28




Status_Bar_Init:
    lda #0 
    sta ones_place
    sta tens_place
    sta hundreds_place
    sta thousands_place
    sta ten_thousands_place
    
   ; jsr store_high_score
  
    lda #24;skip first 4 for aprite 0 
    sta status_oam_index

    ; lda #HIGH_SCORE_POS_Y
    ; sta score_pos_y_

    
    ; jsr Send_Score_To_OAM_Buff
    lda #SCORE_POS_Y
    sta score_pos_y_
    jsr Send_Score_To_OAM_Buff
    lda #44;skip first 4 for aprite 0 
    sta status_oam_index
    jsr Send_Level_To_OAM_Buff
    lda #48;skip first 4 for aprite 0 
    sta status_oam_index
    jsr Send_Lives_To_OAM_Buff


    lda #56
    sta status_oam_size
    
rts 

Update_Score:
    
    lda #0 
    sta ones_place
    sta tens_place
    sta hundreds_place
    sta thousands_place
    sta ten_thousands_place


    lda #24;skip first 4 for sprite 0 and next 20 for high score
    sta status_oam_index

    lda #SCORE_CHANGE
    and status_bar_flags
    beq @done_score_update 
       lda #<~SCORE_CHANGE
       and status_bar_flags
       sta status_bar_flags

        lda #SCORE_POS_Y
        sta score_pos_y_

        lda Game::score_LO
        sta temp_score_LO
        lda Game::score_HI
        sta temp_score_HI
        jsr convert_to_decimal
        jsr Send_Score_To_OAM_Buff
    @done_score_update:

    lda #44;skip first 4 for aprite 0 
    sta status_oam_index

    jsr Send_Level_To_OAM_Buff

    lda #48;skip first 4 for aprite 0 
    sta status_oam_index

    jsr Send_Lives_To_OAM_Buff

    @done_lives_update:
    lda Game::lives
    adc #13
    sta status_oam_size


    

    @done:
    lda Game::lives
    adc #12
    sta status_oam_size
     asl status_oam_size
     asl status_oam_size ;multiply by 4, eachsprite takes up  spots
 
rts

store_high_score:
    lda high_score_HI
    cmp Game::score_HI
    bcc @new_high_score ;branch if score is grreter tha high score
    bne @done 
        ;high ends of score are equal check low ends
        lda high_score_LO
        cmp Game::score_LO
        bcc @new_high_score
        jmp @done
    @new_high_score:


        lda Game::score_LO
        sta temp_score_LO
        sta high_score_LO
        lda Game::score_HI
        sta temp_score_HI
        sta high_score_HI

        lda #0 
        sta ones_place
        sta tens_place
        sta hundreds_place
        sta thousands_place
        sta ten_thousands_place
        jsr convert_to_decimal

        lda #4
        sta status_oam_index
        lda #HIGH_SCORE_POS_Y
        sta score_pos_y_
        jsr Send_Score_To_OAM_Buff
        lda #SCORE_POS_Y
        sta score_pos_y_

        lda #DISP_HIGH_SCORE
        ora status_bar_flags
        sta status_bar_flags
    @done:
    rts



convert_to_decimal:

    @check_ten_thousands:
        lda #TEN_THOUSANDS_HI
        cmp temp_score_HI
        bcc @ten_thousands ;branch if score_HI > TEN_THOUSANDS_HI
        bne  @check_thousands  ;branch if score_HI < TEN_THOUSANDS_HI
        lda temp_score_LO
        cmp #TEN_THOUSANDS_LO
        bcs @ten_thousands
    
       ;if score is greater than 1000 
    @check_thousands:
         lda #THOUSANDS_HI
        cmp temp_score_HI
        bcc @thousands ;branch if score_HI > TEN_THOUSANDS_HI
        bne  @check_hundreds  ;branch if score_HI < TEN_THOUSANDS_HI
        lda temp_score_LO
        cmp #THOUSANDS_LO
        bcs @thousands
   
    @check_hundreds:
        lda temp_score_HI
        cmp #$01
        bcs @hundreds
        lda temp_score_LO
        cmp #HUNDRED
        bcs @hundreds

    @check_tens:
        lda temp_score_LO
        cmp #TEN
        bcs @tens

    jmp @ones

    @ten_thousands:
        lda temp_score_LO
        sec
        sbc #TEN_THOUSANDS_LO
        
        sta temp_score_LO
        lda temp_score_HI
        sbc #TEN_THOUSANDS_HI
        sta temp_score_HI
        inc ten_thousands_place
        JMP @check_ten_thousands
    @thousands:
        lda temp_score_LO
        sec
        sbc #THOUSANDS_LO
        sta temp_score_LO
        lda temp_score_HI
        sbc #THOUSANDS_HI
        sta temp_score_HI
        inc thousands_place
        JMP @check_thousands
        ;subtract a thousand until score is less than 1000
        ;add 1 each time to thousands place
    @hundreds:
        lda temp_score_LO
        sec
        sbc #HUNDRED
        
        sta temp_score_LO
        lda temp_score_HI
        sbc #0
        sta temp_score_HI
        inc hundreds_place
        JMP @check_hundreds
         ;subtract a hundred until score is less than 100
        ;add 1 each time to thousands place
    @tens: 
        sec
        sbc #TEN
        sta temp_score_LO
        inc tens_place
        JMP @check_tens
        ;subtract ten until score is less than 10
        ;add 1 each time to thousands place
    @ones:
        lda temp_score_LO
        beq @done
        inc ones_place
        sec
        sbc #ONE
        sta temp_score_LO
        bne @ones; subtract 1 until score is 0
    @done:
        rts
        ;put remainder into ones place



    ;if score is greater than 1000 
      

    ;if score is greater than 100 
       

    ;if score is greater than 10 
       
 Send_Score_To_OAM_Buff:
        ;load frame pointer

    ;     ldx #1
    ; stx status_oam_size
    ldx #0
    
    stx score_pos_x_
    
    @loop:
       ; inc status_oam_index
        
        
        ldy ten_thousands_place, x
        tya
        asl
        tay

        lda EWL_StreetSkate_pointers_score, y
        sta main_pointer_LO
        
        iny
        lda EWL_StreetSkate_pointers_score, y
        sta main_pointer_HI

        stx main_temp ;stors score_pos_x_ temporarly
        ldx status_oam_index
        
        ldy #0

        lda score_pos_x_
        clc
        adc #8
        sta score_pos_x_
        adc #SCORE_POS_X
        adc (main_pointer_LO),Y
        sta OAM_DMA_X, X

        iny
        lda score_pos_y_  
        clc   
        adc (main_pointer_LO),Y
        sta OAM_DMA_Y ,X

        iny
        lda (main_pointer_LO),Y
        sta OAM_DMA_TILE,X
    
        iny
        lda (main_pointer_LO),Y
        sta OAM_DMA_ATTR, X 

        lda status_oam_index
        clc
        adc #4
        sta status_oam_index
        ldx main_temp
        INX
            
        cpx #5
        bcc @loop
    
    @done:
     
    rts


Send_Level_To_OAM_Buff:
  
        
    
    lda Game::level
    clc
    adc #1
    asl
    tay

    lda EWL_StreetSkate_pointers_score, y
    sta main_pointer_LO
    
    iny
    lda EWL_StreetSkate_pointers_score, y
    sta main_pointer_HI

 
    ldx status_oam_index
    
    ldy #0

    lda #LEVEL_POS_X
   adc (main_pointer_LO),Y
    sta OAM_DMA_X, X

    iny
    lda #LEVEL_POS_Y
    adc (main_pointer_LO),Y
    sta OAM_DMA_Y ,X

    iny

    lda (main_pointer_LO),Y
    sta OAM_DMA_TILE,X

    iny
    lda (main_pointer_LO),Y
    sta OAM_DMA_ATTR, X 

    lda status_oam_index
    clc
    adc #4
    sta status_oam_index

    
    @done:
     
    rts
    
 Send_Lives_To_OAM_Buff:
        ;load frame pointer
        ; lda <EWL_StreetSkate_pointers_eggLife

        ; sta main_pointer_LO
        ; lda >EWL_StreetSkate_pointers_eggLife

        ; sta main_pointer_HI
        ldx Game::lives
        stx main_temp
        ldx #0
        
        stx score_pos_x_
       
        @loop:
             
            lda main_temp
            beq @done    
          
            ldx status_oam_index
          
            ldy #0

            lda score_pos_x_
            clc
            adc #8
            sta score_pos_x_
            adc #LIVES_POS_X
            adc EWL_StreetSkate_Egg_life_data,Y
            sta OAM_DMA_X, X
   
            iny
            lda #LIVES_POS_Y   
            clc   
            adc EWL_StreetSkate_Egg_life_data,Y
            sta OAM_DMA_Y ,X
   
            iny
            lda EWL_StreetSkate_Egg_life_data,Y
            sta OAM_DMA_TILE,X
      
            iny
            lda EWL_StreetSkate_Egg_life_data,Y
            sta OAM_DMA_ATTR, X 

            lda status_oam_index
            clc
            adc #4
            sta status_oam_index
            dec main_temp
            jmp @loop
        
        @done:
     
    rts

