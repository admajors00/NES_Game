
; .IFNDEF GAME_INC
; GAME_INC =1
.include "/inc/game.inc"
.scope Game
    ;some game constants
    score_HI = $71
    score_LO = $70
    hit_flag = $72
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



        @check_hit:;the players x value is inside the obstical
            lda Obsticles::pos_y
            sec
            sbc Obsticles::height
            clc
            cmp Player::pos_y_HI
            bcs @not_hit ;jump if the player is above the obstical

            lda hit_flag
            bne @done ;jump i the player has already hit the obsticle

            adc #1
            sta hit_flag
            lda #0
            sta Player::velocity_x_HI
            sta Player::velocity_x_LO
            jmp @done

            @not_hit:
                
                lda score_LO
                clc
                adc #101
                sta score_LO
                lda score_HI
                adc#0
                sta score_HI
            

            ; lda #Player::PlayerActionStates::crash
            ; sta Player::player_action_state
        
        @done:
    rts

.endscope

; .ENDIF