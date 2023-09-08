;adress space is $20-$2F
.IFNDEF ANIMATIONS_
.DEFINE ANIMATIONS_
;animation flags 

; .include "player.asm"

; BUTTON_A      = 1 << 7
; BUTTON_B      = 1 << 6
; BUTTON_SELECT = 1 << 5
; BUTTON_START  = 1 << 4
IDLE     = 1 << 3
LOOP   = 1 << 2
PAUSE   = 1 << 1
STARTED  = 1 << 0

OAM_DMA_ADDR = $200
; OAM_Y    = 0
; OAM_TILE = 1
; OAM_ATTR = 2
; OAM_X    = 3

.scope Animation

    pt_pointer_LO = $20
    pt_pointer_HI = $21

    frame_pointer_LO = $22
    frame_pointer_HI = $24
    
    animation_timer = $25
    num_frames = $26
    frame_counter = $27
    oam_size = $27


    temp = $29
    Init:
        lda #8
        sta animation_timer

        lda #IDLE
        sta flags

        lda #0 
        sta oam_size
    rts
  
    
    Load_Animation: ;store animation pt addr hi in x and lo in y before calling
        lda flags
        and STARTED
        bne @done ;do nothing if in the middle of an animation

        sty pt_pointer_LO
        stx pt_pointer_HI

        ldy 0
        lda (pt_pointer_LO), y
        sta num_frames
        sta frame_counter

        iny
        lda (pt_pointer_LO), y
        sta frame_pointer_HI

        iny
        lda (pt_pointer_LO), y
        sta frame_pointer_LO


        @done:

    rts

    Update:
        lda flags
        and #STARTED
        bne @started
        lda flags
        eor #STARTED
        sta flags
        ;load number of updates for this frame into frame timer

        @started:
            dec  animation_timer
            ;if animation timer == 0 
            bne @done
                ;dec numframes
                dec frame_counter
                ;if numframes == 0
                bne @next_frame
                    lda flags
                    ora #IDLE
                    eor #STARTED
                    ;set idle flag
                    ;reset started flag
                ;else
                @next_frame:
                ;   get next frame pointer
                    
                    lda frame_pointer_LO
                    clc
                    adc #2
                    sta frame_pointer_LO
                    lda frame_pointer_HI
                    adc #0
                ;   call store frame
                    jsr Store_frame
            ;else
                ;return
        @done:

    rts

    Store_frame:
        ;load frame pointer
        
        ldx #0
        stx oam_size
        ;load oam address plus offset   
        @loop:
            ldy 0
            lda Player::player_pos_x_HIGH
            sec 
            sbc (frame_pointer_LO),y
            sta OAM_DMA_ADDR + oam_size + OAM_X

            iny

            lda Player::player_pos_y_HIGH
            sec 
            sbc (frame_pointer_LO),y
            sta OAM_DMA_ADDR +oam_size + OAM_Y

            iny
            lda (frame_pointer_LO),y
            sta OAM_DMA_ADDR +oam_size + OAM_TILE

            iny
            lda (frame_pointer_LO),y
            sta OAM_DMA_ADDR +oam_size + OAM_ATTR

            lda oam_size
            adc #4
            iny
            lda (frame_pointer_LO),y

            
            bpl @loop


    rts
.endscope






EWL_StreetSkate_Push_1_data:


	.byte  16,  4,$d1,0
	.byte   8,  4,$d4,0
	.byte  16, 24,$24,0
	.byte   8, 24,$25,0

	.byte  16, 16,$26,0
	.byte   8, 16,$27,0
	.byte  16,  8,$e0,0
	.byte   8,  8,$e1,0
	.byte $80


EWL_StreetSkate_Push_2_data:


	.byte   8,  4,$d8,0
	.byte  16,  4,$d5,0
	.byte  15, 23,$28,0
	.byte   7, 23,$29,0

	.byte  15, 15,$2a,0
	.byte   7, 15,$2b,0
	.byte  17,  8,$e4,0
	.byte   9,  8,$e5,0

	.byte   9,  0,$e7,0
	.byte $80



EWL_StreetSkate_Push_3_data:


	.byte  16,  4,$d9,0
	.byte   8,  4,$dc,0
	.byte  15, 23,$28,0
	.byte   7, 23,$29,0

	.byte  15, 15,$2a,0
	.byte   7, 15,$2b,0
	.byte   9,  8,$e9,0
	.byte  17,  8,$e8,0

	.byte  17,  0,$ea,0
	.byte $80


EWL_StreetSkate_Push_4_data:


	.byte  16,  4,$d1,0
	.byte   8,  4,$d4,0
	.byte  15, 23,$28,0
	.byte   7, 23,$29,0

	.byte  15, 15,$2a,0
	.byte   7, 15,$2b,0
	.byte   9,  8,$ed,0
	.byte  17,  8,$ec,0
	.byte $80


EWL_StreetSkate_pointers:
    .byte 4
	.word EWL_StreetSkate_Push_1_data
	.word EWL_StreetSkate_Push_2_data
	.word EWL_StreetSkate_Push_3_data
	.word EWL_StreetSkate_Push_4_data





.ENDIF