; adress space is $20$2F
; .ifndef ANIMATIONS_INC
; ANIMATIONS_INC =1
; ;animation flags 

 .include "/inc/animations.inc"
 .include "../graphics/Frames.inc"
.include "/inc/game.inc"
;.include "player.inc"
; BUTTON_A      = 1 << 7
; BUTTON_B      = 1 << 6
; BUTTON_SELECT = 1 << 5
; BUTTON_START  = 1 << 4
.segment "RAM"
.org $400
animation_headers_table:
    .addr 0,0,0,0

obs0_header_table:
    .tag Animation_Header_t
player_header_table:
    .tag Animation_Header_t

chaser_header_table:
    .tag Animation_Header_t

obs1_header_table:
    .tag Animation_Header_t

Sprite_positions_table:
    .byte 0,0,0,0,0,0,0,0

Alt_frametimer_table:
    .byte 0, 0, 0 ,0
.reloc


SPRITE_0_X = $FA
SPRITE_0_Y = $2D


.segment "CODE"

HEADER_TABLE_MAX_SIZE = 4

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
  

    pointer_3_LO = $29
    pointer_3_HI = $2A

    sprite_pos_x = $2B
    sprite_pos_y = $2C

    temp_frame_index = $2D

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
        lda #<obs0_header_table
        sta (pointer_1_LO),Y
        iny 
        lda #>obs0_header_table
        sta (pointer_1_LO),Y

        iny
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

         iny
        lda #<obs1_header_table
        sta (pointer_1_LO),Y
        iny 
        lda #>obs1_header_table
        sta (pointer_1_LO),Y

        
        lda #SPRITE_0_X
            sta OAM_DMA_X
            lda #SPRITE_0_Y
            sta OAM_DMA_Y 

        

    rts
  
    
    Load_Animation: ;add animation header to the list of headers

        stx pointer_1_LO
        sty pointer_1_HI ;load new header addr
        ldy #Animation_Header_t::flags
        lda #ANI_OBJECTS_MASK
       
        and (pointer_1_LO), Y ; get object number whic is equal to index in header table
       
        asl
      
        tay
        
        lda animation_headers_table, Y
        sta pointer_2_LO
        iny
        lda animation_headers_table, Y
        sta pointer_2_HI
        

        
        jmp @store_header
 




        @store_header:;pointer 1 is new header, pointer 2 is local storage
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
        tay
        @loop:
    
            ldy header_table_index
            beq @done       
             ; if index is 0 stop

            dey          
            ;load the next addres from the header table
            lda animation_headers_table ,y
            sta pointer_1_HI
            lda Sprite_positions_table, Y
            sta sprite_pos_y
       
            
            dey
            lda animation_headers_table ,y
            sta pointer_1_LO
            lda Sprite_positions_table, Y
            sta sprite_pos_x
      

            sty header_table_index

            ldy #Animation_Header_t::flags
            lda #ANI_FLAGS_MASK 
            and (pointer_1_LO), y ; if flags are 0 do not update
            beq @loop
            ldy #Animation_Header_t::flags
            lda #PAUSE 
            and (pointer_1_LO), y ; if paused not update
            bne @no_update
            jsr Update_Animation
            @no_update:
            jsr Update_sprite_pos
            jmp @loop
        @done:           


    rts

            
    Update_Animation: 
        
        ;pointer 1 should already be loaded with the current header location
        ;decrement the frame timer
        
        ldy #Animation_Header_t::frame_timer 
        lda (pointer_1_LO), y
        sec
        sbc #$01
        sta (pointer_1_LO), y

        ;if the frame timer is not 0
        bne @done
            ;if the frame timer is 0
            ;decrement the frame index
            ldy #Animation_Header_t::frame_index
            lda (pointer_1_LO), y
           
            ;if the frame index is not 0  
            bne @next_frame
                ;if the frame index is 0 
                ;if the animation is a loop
                ldy #Animation_Header_t::flags
                lda #LOOP
                and (pointer_1_LO), y
                beq @not_a_loop
                    ;if animation is a loop
                    ;reset the index to num_frames
                    ldy #Animation_Header_t::num_frames
                    lda (pointer_1_LO), y
                    ldy #Animation_Header_t::frame_index
                    sta (pointer_1_LO), y
                    sta temp_frame_index

                 
                        ;dec temp_frame_index
                        ;put frame timer table address into pointer 2
                        ldy #Animation_Header_t::frame_timers_pt
                        lda (pointer_1_LO), y
                        sta pointer_2_LO
                        iny 
                        lda (pointer_1_LO), y
                        sta pointer_2_HI

                        ;put the current frame index into y
                        LDY temp_frame_index
                        ;get the frame timer from the table at current frame index 
                        lda (pointer_2_LO), y

                        ;store it in the frame timer
                        ldy #Animation_Header_t::frame_timer
                        sta (pointer_1_LO), y
                        ; lda #0
                        ; sta Player::player_animation_flag                   

                        jmp @done
                    

                ;else 
                @not_a_loop:  
                    lda header_table_index
                    lsr
                    cmp #objects_e::player
                    bne @done ;if headertable index is 0 then set PLAYER_ANI_DONE_f 
                        lda #PLAYER_ANI_DONE_f
                        ora player_input_flags_g
                        sta player_input_flags_g
                    
                    jmp @done
                    ;set the animation done flag
                
            ;else
            @next_frame:
                ;frame index is in register a, decrement it
                sec
                sbc #$01
                sta (pointer_1_LO), y
                sta temp_frame_index
                
                ;load the corresponding frame timer value from the table 
                ldy #Animation_Header_t::flags
                lda #ALT_FRAME_TIMER_F
                and (pointer_1_LO), y

                bne @set_alt_frame_timer
                    ;load the timer table addr into pointer 2
                    ldy #Animation_Header_t::frame_timers_pt 
                    lda (pointer_1_LO), y
                    sta pointer_2_LO
                    iny 
                    lda (pointer_1_LO), y
                    sta pointer_2_HI

                    ;put the current frame index into y
                    ldy temp_frame_index
                    ;get the frame timer from the table at current frame index 
                    lda (pointer_2_LO), y

                    ;store it in the frame timer
                    ldy #Animation_Header_t::frame_timer
                    sta (pointer_1_LO), y


                    ;update the frame pointer
                    jsr Update_Frame_Pointer
                    jmp @done
                @set_alt_frame_timer:
                        lda #16
                        sec
                        sbc Player::frame_speed
                       
                        ;asl
                        ldy #Animation_Header_t::frame_timer
                        sta (pointer_1_LO), y
                        jsr Update_Frame_Pointer
                        jmp @done
        ;else continue
        @done:
    rts

    Update_Frame_Pointer:
        ; load the frame table addr into pointer 2
        ldy #Animation_Header_t::frames_pt 
        lda (pointer_1_LO), y
        sta pointer_2_LO
        iny 
        lda (pointer_1_LO), y
        sta pointer_2_HI


        ;put the current frame index into y
        lda temp_frame_index
        asl ;mutiply by 2 bc address takes up 2 bytes
        tay
        tax
        ;get the frame addr from the table at current frame index 
        lda (pointer_2_LO), y;frame pointer lo for new frame
        ldy #Animation_Header_t::frame
        sta (pointer_1_LO), Y

        inx 
        txa
        tay
        lda (pointer_2_LO), y ;frame pointer hi for new frame
        ldy #Animation_Header_t::frame+1
        sta (pointer_1_LO), Y
    rts
    .proc Update_sprite_pos
        ;load frame pointer


        
        ldy #Animation_Header_t::frame
        lda (pointer_1_LO), y
        sta pointer_2_LO
        
        iny
        lda (pointer_1_LO), y
        sta pointer_2_HI

        ldy #0
        @loop:

            ldx oam_size
          
            lda sprite_pos_x
            clc
            adc (pointer_2_LO),Y
            sta OAM_DMA_X, X
   
            iny
            lda sprite_pos_y   
            clc   
            adc (pointer_2_LO),Y
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
            cmp #$F0
            bcs @done
           
            
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
            cpx status_oam_size
            bcs @loop
            ldx status_oam_size
            stx oam_size
            lda #SPRITE_0_X
            sta OAM_DMA_X
            lda #SPRITE_0_Y
            sta OAM_DMA_Y 
            lda #0
            sta OAM_DMA_TILE
            sta OAM_DMA_ATTR

    rts



.endscope



;.export Animation
; .endif