
UPPER_4 = %11110000
LOWER_4 = %00001111

ten_thousands_place = $60
thousands_place = $61
hundreds_place = $62
tens_place = $63
ones_place = $64



temp_score_HI = $65
temp_score_LO = $66

status_oam_size = $67
score_pos_x_ = $68
temp = $69
TEN_THOUSANDS_HI = $27
TEN_THOUSANDS_LO = $10

THOUSANDS_HI = $03
THOUSANDS_LO = $e8


HUNDRED = $64
TEN = $0a
ONE = $01

SCORE_POX_X = $58
SCORE_POS_Y = $10

Update_Score:
    lda #0 
    sta ones_place
    sta tens_place
    sta hundreds_place
    sta thousands_place
    sta ten_thousands_place

    lda Game::score_LO
    sta temp_score_LO
    lda Game::score_HI
    sta temp_score_HI
    jsr convert_to_decimal
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

        
        ldx #0
        stx status_oam_size
        stx score_pos_x_
        @loop:
            
            sta status_oam_size
            
            ldy ten_thousands_place, x
            tya
            asl
            tay

            lda EWL_StreetSkate_pointers_score, y
            sta main_pointer_LO
            
            iny
            lda EWL_StreetSkate_pointers_score, y
            sta main_pointer_HI

            stx temp
            ldx status_oam_size
          
            ldy #0

            lda score_pos_x_
            clc
            adc #8
            sta score_pos_x_
            adc #SCORE_POS_X
            adc (main_pointer_LO),Y
            sta OAM_DMA_X, X
   
            iny
            lda #SCORE_POS_Y   
            clc   
            adc (main_pointer_LO),Y
            sta OAM_DMA_Y ,X
   
            iny
            lda (main_pointer_LO),Y
            sta OAM_DMA_TILE,X
      
            iny
            lda (main_pointer_LO),Y
            sta OAM_DMA_ATTR, X 

            lda status_oam_size
            adc #4
            ldx temp
            INX
            txa 
            cmp #5
            bne @loop
        
        @done:
    rts
    
