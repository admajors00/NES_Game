sprites:
;vert tile attr horiz
.byte $C0, $20, $00, $80 ;sprite 0
.byte $C0, $21, $00, $88 ;sprite 1
.byte $C8, $22, $00, $80 ;sprite 2
.byte $C8, $23, $00, $88 ;sprite 3

.byte $B0, $40, $01, $B0 ;sprite 0
.byte $B0, $41, $01, $B8 ;sprite 1
.byte $B8, $42, $01, $B0 ;sprite 2
.byte $B8, $43, $01, $B8 ;sprite 3

.byte $B0, $60, $01, $A0 ;sprite 0
.byte $B0, $61, $01, $A8 ;sprite 1
.byte $B8, $62, $01, $A0 ;sprite 2
.byte $B8, $63, $01, $A8 ;sprite 3

sprite_pos_x = $10
sprite_pos_y = $11
sprite_direction = $12


moveCharacter:
    lda #BUTTON_LEFT
	and Port_1_Pressed_Buttons
	bne @right

	lda #BUTTON_RIGHT
	and Port_1_Pressed_Buttons
	bne @left

	jmp @end

	@left:
		lda sprite_pos_x
		cmp #$E0
		bne @moveSpriteLeft
		INC scroll
		jsr Scroll
		jmp @end
		@moveSpriteLeft:
		ldx sprite_pos_x
		inx
		beq @end ;if position is 0 do not move 
		stx sprite_pos_x
		lda sprite_pos_x
		adc #$07
		stx	$0203		; store sprite position
		sta $0207   ; add offset for other sprites
		stx	$020B
		sta $020F

		lda $0202
		and #%10111111 ;reset mirror bit for sprite
		sta $0202
		lda $0206
		and #%10111111
		sta $0206
		lda $020A
		and #%10111111
		sta $020A
		lda $020E
		and #%10111111
		sta $020E
		jmp @end


	@right:
		lda sprite_pos_x
		cmp #$10
		bne @moveSpriteRight
		DEC scroll
		jsr Scroll
		jmp @end
	@moveSpriteRight:
		ldx sprite_pos_x
		dex
		beq @end
		stx sprite_pos_x
		lda sprite_pos_x
		adc #$07
		sta	$0203		
		stx $0207
		sta	$020B
		stx $020F

		lda $0202
		ora #%01000000
		sta $0202
		lda $0206
		ora #%01000000
		sta $0206
		lda $020A
		ora #%01000000
		sta $020A
		lda $020E
		ora #%01000000
		sta $020E
		jmp @end

    @end:

    rts