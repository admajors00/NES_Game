; adress space is $20$2F
; .ifndef ANIMATIONS_INC
; ANIMATIONS_INC =1
; ;animation flags 

; .include "player."
.autoimport +
;.include "player.inc"
; BUTTON_A      = 1 << 7
; BUTTON_B      = 1 << 6
; BUTTON_SELECT = 1 << 5
; BUTTON_START  = 1 << 4
IDLE     = 1 << 3
LOOP   = 1 << 2
PAUSE   = 1 << 1
STARTED  = 1 << 0

OAM_DMA_ADDR = $200
OAM_DMA_Y    = $200
OAM_DMA_TILE = $201
OAM_DMA_ATTR = $202
OAM_DMA_X    = $203

; 
.scope Animation
    .export Load_Animation
    .export flags
    pt_pointer_LO = $20
    pt_pointer_HI = $21

    frame_pointer_LO = $22
    frame_pointer_HI = $23
    
    animation_timer = $24
    num_frames = $25
    frame_counter = $26
    oam_size = $27
    flags = $28
    temp = $29

    oam_dma_addr_LO = $2A
    oam_dma_addr_HI = $2B

    Init:
        lda #$0F
        sta animation_timer

        lda #IDLE
        sta flags

        lda #0 
        sta oam_size
        sta oam_dma_addr_LO

        lda #2
        sta oam_dma_addr_HI

    rts
  
    
    Load_Animation: ;store animation pt addr hi in x and lo in y before calling
        lda flags
        and #STARTED

        bne @done ;do nothing if in the middle of an animation

        lda #STARTED
        sta flags
   
        sty pt_pointer_LO
        stx pt_pointer_HI

        ldy #0
        lda (pt_pointer_LO), y
        sta num_frames
        sta frame_counter

        iny
        lda (pt_pointer_LO), y
        sta frame_pointer_LO

        iny
        lda (pt_pointer_LO), y
        sta frame_pointer_HI

        lda pt_pointer_LO
        clc
        adc #1
        sta pt_pointer_LO
        lda pt_pointer_HI
        adc #0
        sta pt_pointer_HI

        ;jsr Update
       ; jsr Store_frame
        @done:

    rts

    Update:
        lda flags
        and #STARTED
        bne @started
        jmp @done
        ; lda flags
        ; eor #STARTED
        ; sta flags
        ;load number of updates for this frame into frame timer

        @started:
            dec  animation_timer
            ;if animation timer == 0 
            bne @done
                ;dec numframes
                lda #$0f
                sta animation_timer
                dec frame_counter
                ;if numframes == 0
                bne @next_frame
                    lda #IDLE
                    sta flags
                    lda #Player::PlayerStates::coasting
		            sta Player::player_state
                    jmp @done
                    ;eor #STARTED
                    ;set idle flag
                    ;reset started flag
                ;else
                @next_frame:
                ;   get next frame pointer
                    
                    lda pt_pointer_LO
                    clc
                    adc #2 
                    sta pt_pointer_LO
                    lda pt_pointer_HI
                    adc #0
                    sta pt_pointer_HI
                    ldy #0
                    
                    lda (pt_pointer_LO), y
                    sta frame_pointer_LO

                    iny
                    lda (pt_pointer_LO), y
                    sta frame_pointer_HI
                ;   call store frame
                    ;jsr Store_frame
                    jmp @done
            ;else
                ;return
        @done:
        jsr Store_frame
    rts

    .proc Store_frame
        ;load frame pointer
       ; jsr reset_oam_dma
    ;    lda #$FE
    ;         ldx 0
    ;         @loop2:
    ;             sta $200, X
    ;             inx
    ;             bcc @loop2
        ldx #0
        stx oam_size
        ;load oam address plus offset   
        ldy #0
        @loop:
            ldx oam_size
          
            lda Player::player_pos_x_HIGH
            
            sec
            sbc (frame_pointer_LO),Y
            sta OAM_DMA_X, X
   


            iny
            lda Player::player_pos_y_HIGH    
            sec    
            sbc (frame_pointer_LO),Y
            sta OAM_DMA_Y ,X
   

            iny
            lda (frame_pointer_LO),Y
            sta OAM_DMA_TILE,X
      

            iny
            lda (frame_pointer_LO),Y
            sta OAM_DMA_ATTR, X 
            

            txa 
            clc
            adc #$04
            sta oam_size
            iny
            lda (frame_pointer_LO),Y
    
            cmp #$80
            bne @loop

            
     

    rts
    .endproc





.endscope


EWL_StreetSkate_Walk_1_data:


	.byte 16,24,$24,0
	.byte  8,24,$25,0
	.byte 16,16,$26,0
	.byte  8,16,$27,0

	.byte 16, 8,$4d,0
	.byte  8, 8,$50,0
	.byte $80


EWL_StreetSkate_Walk_2_data:


	.byte 16,24,$24,0
	.byte  8,24,$25,0
	.byte 16,16,$26,0
	.byte  8,16,$27,0

	.byte 16, 8,$51,0
	.byte  8, 8,$54,0
	.byte $80


EWL_StreetSkate_Walk_3_data:


	.byte 16,24,$24,0
	.byte  8,24,$25,0
	.byte 16,16,$26,0
	.byte  8,16,$27,0

	.byte 16, 8,$55,0
	.byte  8, 8,$58,0
	.byte $80


EWL_StreetSkate_Walk_4_data:


	.byte 16,24,$24,0
	.byte  8,24,$25,0
	.byte 16,16,$26,0
	.byte  8,16,$27,0

	.byte 16, 8,$59,0
	.byte  8, 8,$5c,0
	.byte $80


EWL_StreetSkate_Push_1_data:


	.byte 16, 4,$d1,0
	.byte  8, 4,$d4,0
	.byte 16,24,$24,0
	.byte  8,24,$25,0

	.byte 16,16,$26,0
	.byte  8,16,$27,0
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0
	.byte $80


EWL_StreetSkate_Push_2_data:


	.byte  8, 4,$d8,0
	.byte 16, 4,$d5,0
	.byte 15,23,$28,0
	.byte  7,23,$29,0

	.byte 15,15,$2a,0
	.byte  7,15,$2b,0
	.byte 17, 8,$e4,0
	.byte  9, 8,$e5,0

	.byte  9,  0,$e7,0
	.byte $80


EWL_StreetSkate_Push_3_data:


	.byte 16, 4,$d9,0
	.byte  8, 4,$dc,0
	.byte 15,23,$28,0
	.byte  7,23,$29,0

	.byte 15,15,$2a,0
	.byte  7,15,$2b,0
	.byte  9, 8,$e9,0
	.byte 17, 8,$e8,0

	.byte 17,  0,$ea,0
	.byte $80


EWL_StreetSkate_Push_4_data:


	.byte 16, 4,$d1,0
	.byte  8, 4,$d4,0
	.byte 15,23,$28,0
	.byte  7,23,$29,0

	.byte 15,15,$2a,0
	.byte  7,15,$2b,0
	.byte  9, 8,$ed,0
	.byte 17, 8,$ec,0
	.byte $80


EWL_StreetSkate_Jump_1_data:


	.byte 16, 4,$d1,0
	.byte  8, 4,$d4,0
	.byte 16,21,$24,0
	.byte  8,21,$25,0

	.byte 16,13,$26,0
	.byte  8,13,$27,0
	.byte  8, 7,$f1,0
	.byte 15, 7,$f4,0
	.byte $80


EWL_StreetSkate_Jump_2_data:


	.byte 16, 8,$fe,0
	.byte  8, 8,$ff,0
	.byte  8,16,$fd,0
	.byte 16,32,$24,0

	.byte  8,32,$25,0
	.byte 16,24,$26,0
	.byte  8,24,$27,0
	.byte 16,16,$e8,0

	.byte 16, 8,$ea,0
	.byte  8,16,$e9,0
	.byte $80


EWL_StreetSkate_Jump_3_data:


	.byte 16,16,$d1,0
	.byte  8,16,$d4,0
	.byte 16,32,$24,0
	.byte  8,32,$25,0

	.byte 16,24,$26,0
	.byte  8,24,$27,0
	.byte  8,16,$f1,0
	.byte 15,16,$f4,0
	.byte $80


EWL_StreetSkate_Jump_4_data:


	.byte 16, 4,$d1,0
	.byte  8, 4,$d4,0
	.byte 16,24,$24,0
	.byte  8,24,$25,0

	.byte 16,16,$26,0
	.byte  8,16,$27,0
	.byte 16, 8,$e0,0
	.byte  8, 8,$e1,0
	.byte $80


EWL_StreetSkate_pointers_walk:

	.word EWL_StreetSkate_Walk_1_data
	.word EWL_StreetSkate_Walk_2_data
	.word EWL_StreetSkate_Walk_3_data
	.word EWL_StreetSkate_Walk_4_data

	

EWL_StreetSkate_pointers_push:
    .byte 4
	.word EWL_StreetSkate_Push_1_data
	.word EWL_StreetSkate_Push_2_data
	.word EWL_StreetSkate_Push_3_data
	.word EWL_StreetSkate_Push_4_data

EWL_StreetSkate_pointers_jump:
    .byte 4
    .word EWL_StreetSkate_Jump_1_data
	.word EWL_StreetSkate_Jump_2_data
	.word EWL_StreetSkate_Jump_3_data
	.word EWL_StreetSkate_Jump_4_data
EWL_StreetSkate_pointers_IDLE:
    .byte 1
	.word EWL_StreetSkate_Push_1_data

;.export Animation
; .endif