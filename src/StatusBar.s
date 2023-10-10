
UPPER_4 = %11110000
LOWER_4 = %00001111

ones_tens = $60
hundreds_thousands = $61

score_HI = $62
score_LO = $63

convert_to_decimal:
    lda score_HI
    cmp #3

    bcc @check_hundreds
    lda score_LO
    cmp #$E8
    bcs @thousands 
    @check_hundreds:
        lda score_LO
        cmp #$64
        bcs @hundreds

    @check_tens:
        lda score_LO
        cmp #$0A
        bcs @tens
        jmp @ones

    @thousands:

    @hundreds:

    @tens: 

    @ones:




    ;if score is greater than 1000 
        ;subtract a thousand until score is less than 1000
        ;add 1 each time to thousands place

    ;if score is greater than 100 
        ;subtract a hundred until score is less than 100
        ;add 1 each time to thousands place

    ;if score is greater than 10 
        ;subtract ten until score is less than 10
        ;add 1 each time to thousands place

    ;put remainder into ones place
rts