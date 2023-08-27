sprites:
	;vert tile attr horiz
	.byte $C0, $20, $00, $80 ;sprite 0
	.byte $C0, $21, $00, $88 ;sprite 1
	.byte $C8, $22, $00, $80 ;sprite 2
	.byte $C8, $23, $00, $88 ;sprite 3

	; .byte $B0, $40, $01, $B0 ;sprite 0
	; .byte $B0, $41, $01, $B8 ;sprite 1
	; .byte $B8, $42, $01, $B0 ;sprite 2
	; .byte $B8, $43, $01, $B8 ;sprite 3

	; .byte $B0, $60, $01, $A0 ;sprite 0
	; .byte $B0, $61, $01, $A8 ;sprite 1
	; .byte $B8, $62, $01, $A0 ;sprite 2
	; .byte $B8, $63, $01, $A8 ;sprite 3

; OAM address ($2003) > write / OAM data ($2004) > write
; Set the "sprite" address using OAMADDR ($2003)
; Then write the following bytes via OAMDATA ($2004)
OAM_ADDR  = $2003
OAM_DATA	= $2004
OAM_DMA   = $4014

; - Byte 0 (Y Position)
OAM_Y    = 0

; - Byte 1 (Tile Index)
;
; 76543210
; ||||||||
; |||||||+- Bank ($0000 or $1000) of tiles
; +++++++-- Tile number of top of sprite (0 to 254; bottom half gets the next tile)
OAM_TILE = 1

; - Byte 2 (Attributes)
;
; 76543210
; ||||||||
; ||||||++- Palette (4 to 7) of sprite
; |||+++--- Unimplemented
; ||+------ Priority (0: in front of background; 1: behind background)
; |+------- Flip sprite horizontally
; +-------- Flip sprite vertically
OAM_ATTR = 2

; - Byte 3 (X Position)
OAM_X    = 3

.scope Sprite

	egg:
		.byte	$24, $25, $26, $27
	cat:
		.byte  	$A0, $A1, $A2, $A3
		.byte  	$A4, $A5, $A6, $A7
.endscope

.scope Player
	sprite_pos_x = $10
	sprite_pos_y = $11
	sprite_direction = $12
	character_velocity_x = $13
	character_velocity_y = $14
	sprite_animation_timer = $15
	sprite_animation_frame = $16


	init_character:
		ldx #$00
		stx character_velocity_x
		stx character_velocity_y
		stx sprite_direction

		ldx #$80
		stx sprite_pos_x
		ldx #$C0
		stx sprite_pos_y

		ldx #5
		stx sprite_animation_timer

		ldx Sprite::cat
		stx sprite_animation_frame
	rts
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
	
	update_sprite:
		dec sprite_animation_timer
		beq @changeSprite
		jmp	@put_in_OAM
		@changeSprite:
			ldx #10
			stx sprite_animation_timer
			lda sprite_animation_frame
			cmp Sprite::cat ;if frame 0
			beq @set_frame_2 ;set to fram 1
			@set_frame_1:  ;selse set to frame 0
				lda Sprite::cat
				sta sprite_animation_frame
				jmp	@put_in_OAM
			@set_frame_2:
				lda Sprite::cat
				adc #3 
				sta sprite_animation_frame
				jmp	@put_in_OAM

		@put_in_OAM:
			ldx sprite_animation_frame
			stx $200 + OAM_TILE
			inx
			stx $204 + OAM_TILE
			inx
			stx $208 + OAM_TILE
			inx
			stx $20C + OAM_TILE
		rts


.endscope

