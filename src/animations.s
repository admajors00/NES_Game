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
.segment "RAM"
.org $400
animation_headers_table:
    .addr 0,0,0,0

player_header_table:
    .tag Animation_Header_t

chaser_header_table:
    .tag Animation_Header_t
.reloc



.segment "CODE"

HEADER_TABLE_MAX_SIZE = 1

OAM_DMA_ADDR = $200
OAM_DMA_Y    = $200
OAM_DMA_TILE = $201
OAM_DMA_ATTR = $202
OAM_DMA_X    = $203





.scope Animation
    .export Load_Animation
    .export flags

    pointer_1_LO = $20
    pointer_1_HI = $21

    pointer_2_LO = $22
    pointer_2_HI = $23

    oam_size = $24
    flags = $25

    header_table_index = $26
    temp1 = $27
    temp2 = $28

    pointer_3_LO = $29
    pointer_3_HI = $2A

    Init:
        ; lda #$0F
        ; sta animation_timer

        lda #0
        sta flags

        lda #0 
        sta oam_size
        lda #>animation_headers_table
        sta pointer_1_HI
        lda #<animation_headers_table
        sta pointer_1_LO

        ldy #0
        lda #<player_header_table
        sta (pointer_1_LO),Y
        iny 
        lda #>player_header_table
        sta (pointer_1_LO),Y

        iny
        lda #<chaser_header_table
        sta (pointer_1_LO),Y
        iny 
        lda #>chaser_header_table
        sta (pointer_1_LO),Y

        


        

    rts
  
    
    Load_Animation: ;add animation header to the list of headers

        sty pointer_1_LO
        stx pointer_1_HI ;load new header addr
        ldy #Animation_Header_t::flags
        lda (pointer_1_LO), Y
        and #ANI_OBJECTS_MASK ; get object number whic is equal to index in header table
        tay
        tax
        
        lda #>animation_headers_table
        sta pointer_3_HI
    
        lda #<animation_headers_table
        sta pointer_3_LO
        

        ldy#0
        lda (pointer_3_LO), Y
        sta pointer_2_LO
        
        
        iny 
        lda (pointer_3_LO), Y
        sta pointer_2_HI
        
        ; ldy #Animation_Header_t::flags
        ; lda (pointer_2_LO), Y
        ; and #ACTIVE
        ; beq @store_header ; jump if the corresponding animation spot is not active
     
        ; ldy #Animation_Header_t::flags
        ; lda (pointer_2_LO), Y
        jmp @store_header
        and #INTERUPTABLE
        beq @done ;if not interruptable quit
        jmp @store_header;if interruptable store header




        @store_header:;pointer 1 is new header, pointer 2 is local storage
            inc temp1
            ldy #Animation_Header_t::num_frames
            lda (pointer_1_LO), Y
            sta (pointer_2_LO), Y
         
            ldy #Animation_Header_t::frame_index
            lda (pointer_1_LO), Y
            sta (pointer_2_LO), Y

            ldy #Animation_Header_t::frames_pt
            lda (pointer_1_LO), Y
            sta (pointer_2_LO), Y

            ldy #Animation_Header_t::frames_pt +1
            lda (pointer_1_LO), Y
            sta (pointer_2_LO), Y

            ldy #Animation_Header_t::frame
            lda (pointer_1_LO), Y
            sta (pointer_2_LO), Y

            ldy #Animation_Header_t::frame +1
            lda (pointer_1_LO), Y
            sta (pointer_2_LO), Y

            ldy #Animation_Header_t::frame_timers_pt
            lda (pointer_1_LO), Y
            sta (pointer_2_LO), Y

            ldy #Animation_Header_t::frame_timers_pt +1
            lda (pointer_1_LO), Y
            sta (pointer_2_LO), Y

            ldy #Animation_Header_t::frame_timer
            lda (pointer_1_LO), Y
            sta (pointer_2_LO), Y

            ldy #Animation_Header_t::flags
            lda (pointer_1_LO), Y
            sta (pointer_2_LO), Y

        @done:

    rts

    Update:
        ;for animation in list
            ;if started 
     
        
        jsr Clear_OAM_DMA
        lda #HEADER_TABLE_MAX_SIZE
        asl 
        sta header_table_index
        ldx #0
        @loop:
            ldy header_table_index         
            beq @done ; if index is 0 stop

            dey            
            ;load the next addres from the header table
            lda animation_headers_table ,y
            sta pointer_1_HI
            
           
            
            dey
            lda animation_headers_table ,y
            sta pointer_1_LO
          
  
            
            sty header_table_index  
            
            ;if this animation is not active skip it
            ldy #Animation_Header_t::flags
            lda (pointer_1_LO), y
           
           ; and #ACTIVE
            ; beq @loop 
            jsr  Update_Animation
            jmp @loop
        @done:
        jsr Update_player_sprite_pos
    rts



            
    Update_Animation: 
        
        ;pointer 1 should already be loaded with the current header location
        ;decrement the frame timer
        

    

        ldy #Animation_Header_t::frame_timer 
        lda (pointer_1_LO), y

        sec
        sbc #$01
        
        sta (pointer_1_LO), y
        
       ; inc temp2
        ;if the frame timer is 0
        bne @done
            ;lda #$69
           ; sta temp1
            ;decrement the frame index
            ldy #Animation_Header_t::frame_index
            lda (pointer_1_LO), y
            ;if the frame index is 0  
            bne @next_frame
                
           
            
                ;if the animation is a loop
                ldy #Animation_Header_t::flags
                lda (pointer_1_LO), y
                and #LOOP
                beq @not_a_loop
                    ;reset the index to num_frames
                    ldy #Animation_Header_t::num_frames
                    lda (pointer_1_LO), y
                    ldy #Animation_Header_t::frame_index
                    sta (pointer_1_LO), y

                     ldy #Animation_Header_t::frame_timers_pt
                     
                    lda (pointer_1_LO), y
                    sta pointer_2_LO
                    iny 
                    lda (pointer_1_LO), y
                    sta pointer_2_HI

                    ;put the current frame index into y
                    LDY #0
                    ;get the frame timer from the table at current frame index 
                    lda (pointer_2_LO), y

                    ;store it in the frame timer
                    ldy #Animation_Header_t::frame_timer
                    sta (pointer_1_LO), y
                    jmp @done
                ;else 
                @not_a_loop:  
                    lda #0
                    sta Player::player_animation_flag
                    jmp @done
                    ;set the animation done flag
                
            ;else
            @next_frame:
            sec
                sbc #01

                sta (pointer_1_LO), y
                ;load the corresponding frame timer value from the table 

                ;load the timer table addr into pointer 2
                ldy #Animation_Header_t::frame_timers_pt 
                lda (pointer_1_LO), y
                sta pointer_2_LO
                iny 
                lda (pointer_1_LO), y
                sta pointer_2_HI

                ;put the current frame index into y
                ldy #Animation_Header_t::frame_index
                lda (pointer_1_LO), y
                tay
                ;get the frame timer from the table at current frame index 
                lda (pointer_2_LO), y

                ;store it in the frame timer
                ldy #Animation_Header_t::frame_timer
                sta (pointer_1_LO), y


                ;update the frame pointer
                ; load the frame table addr into pointer 2
                ldy #Animation_Header_t::frames_pt 
                lda (pointer_1_LO), y
                sta pointer_2_LO
                iny 
                lda (pointer_1_LO), y
                sta pointer_2_HI


                ;put the current frame index into y
                ldy #Animation_Header_t::frame_index
                lda (pointer_1_LO), y
                asl ;mutiply by 2 bc address takes up 2 bytes
                tay
                tax
                ;get the frame addr from the table at current frame index 
                lda (pointer_2_LO), y
                ldy #Animation_Header_t::frame
                sta (pointer_1_LO), Y

                inx 
                txa
                tay
                lda (pointer_2_LO), y
                ldy #Animation_Header_t::frame+1
                sta (pointer_1_LO), Y
                jmp @done

        ;else continue
        @done:
    rts

    .proc Update_player_sprite_pos
        ;load frame pointer
       ; jsr reset_oam_dma

        ldy #0
        lda animation_headers_table,y
        sta pointer_1_LO
        iny
        lda animation_headers_table,y
        sta pointer_1_HI

        
        ldy #Animation_Header_t::frame
        lda (pointer_1_LO), y
        sta pointer_2_LO
        
        iny
        lda (pointer_1_LO), y
        sta pointer_2_HI


        ; ldy #0
        ; lda (pointer_2_LO), y
        ; sta pointer_1_LO

        ; iny
        ; lda (pointer_2_LO), y
        ; sta pointer_1_HI
        ;load oam address plus offset   
        ldy #0
        sty oam_size
       
        @loop:
            ldx oam_size
          
            lda Player::player_pos_x_HIGH 
            sec
            sbc (pointer_2_LO),Y
            sta OAM_DMA_X, X
   
            iny
            lda Player::player_pos_y_HIGH    
            sec    
            sbc (pointer_2_LO),Y
            sta OAM_DMA_Y ,X
   
            iny
            lda (pointer_2_LO),Y
            sta OAM_DMA_TILE,X
      
            iny
            lda (pointer_2_LO),Y
            sta OAM_DMA_ATTR, X 
        
            txa 
            clc
            adc #$04
            sta oam_size
            ; lda oam_size
            ; cmp #$24
            ; bcs @done
           
            
            iny
            lda (pointer_2_LO),Y
    
            cmp #$80
            bne @loop
            jmp @done

            
     
        @done:
    rts
    .endproc

    Clear_OAM_DMA:
        lda #$FE
        ldx oam_size
        @loop:
            sta $200, X
            dex
            bne @loop
        stx oam_size

    rts



.endscope


push_frame_timers:
    .byte 1,8,8,8
Push_Ani_Header:
      .byte 4
      .byte 3
      .addr EWL_StreetSkate_pointers_push
      .addr EWL_StreetSkate_Push_1_data
      .addr push_frame_timers
      .byte 8
      .byte %10010000



jump_frame_timers:
    .byte 8,30,16,2

Jump_Ani_Header:
      .byte 4
      .byte 3
      .addr EWL_StreetSkate_pointers_jump
      .addr EWL_StreetSkate_Jump_1_data
      .addr jump_frame_timers
      .byte 2
      .byte %10010000



coast_frame_timers:
    .byte 4,8,8,8

Coast_Ani_Header:
      .byte 4
      .byte 3
      .addr EWL_StreetSkate_pointers_coasting
      .addr EWL_StreetSkate_Coasting_1_data
      .addr coast_frame_timers
      .byte 4
      .byte %11010000

idle_frame_timers:
    .byte 1

Idle_Ani_Header:
      .byte 1
      .byte 1
      .addr EWL_StreetSkate_pointers_idle
      .addr EWL_StreetSkate_Coasting_4_data
      .addr idle_frame_timers
      .byte 1
      .byte %11010000

kickFlip_frame_timers:
    .byte 2,3,3,3,3,3,3,3,2

KickFlip_Ani_Header:
      .byte 9
      .byte 8
      .addr EWL_StreetSkate_pointers_kickflip
      .addr EWL_StreetSkate_KickFlip_1_data
      .addr kickFlip_frame_timers
      .byte 2
      .byte %10010000


;.export Animation
; .endif