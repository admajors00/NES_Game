; adress space is $20$2F
; .ifndef ANIMATIONS_INC
; ANIMATIONS_INC =1
; ;animation flags 

 .include "animations.inc"
 .include "../graphics/Frames.inc"

;.include "player.inc"
; BUTTON_A      = 1 << 7
; BUTTON_B      = 1 << 6
; BUTTON_SELECT = 1 << 5
; BUTTON_START  = 1 << 4


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
        lda #$FE
        ldx oam_size
        @loop2:
            sta $200, X
            dex
            bne @loop2
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



Push_Ani_Header:
      .byte 4
      .byte 4
      .addr EWL_StreetSkate_pointers_push
      .addr push_frame_timers
      .byte %0001000

push_frame_timers:
    .byte 8,8,8,8

Jump_Ani_Header:
      .byte 4
      .byte 4
      .addr EWL_StreetSkate_pointers_jump
      .addr jump_frame_timers
      .byte %0001000

jump_frame_timers:
    .byte 2,8,8,8
;.export Animation
; .endif