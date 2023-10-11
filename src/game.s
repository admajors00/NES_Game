
; .IFNDEF GAME_INC
; GAME_INC =1
.include "/inc/game.inc"
.scope Game
    ;some game constants
   
    hit_flag = $60
    Update:
        lda active_flag
        beq @done
        lda Obsticles::pos_x
        clc
        cmp Player::pos_x_HI
        bcc @done
        sec
        sbc Obsticles::length
        clc
        cmp Player::pos_x_HI
        bcc @check_hit


        lda #0
        sta hit_flag
        jmp @done



        @check_hit:
            lda Obsticles::pos_y
            sec
            sbc Obsticles::height
            clc
            cmp Player::pos_y_HI
            bcs @done

            lda hit_flag
            bne @done

            adc #1
            sta hit_flag
            lda #0
            sta Player::velocity_x_HI
            sta Player::velocity_x_LO
            ; lda #Player::PlayerActionStates::crash
            ; sta Player::player_action_state
        
        @done:
    rts

.endscope

; .ENDIF