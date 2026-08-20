.ifndef _GAME_INC
_GAME_INC = 1

HIT_OBST_f = 1<< 0
HIT_CHASER_f = 1<<1

; game variables
score_HI = $71
score_LO = $70
hit_flag = $72
lives = $73
game_state = $74

timer = $75

;some game constants
.scope Game_Const
    gravity = $10
    ground = $B0
    friction = $02
    jump_speed_max_low = $80
    jump_speed_max_high = $01

    push_speed_low = $80
    push_speed_high = $00

    scroll_wall = $60
    max_speed_HI = $02
    max_speed_LO = $F0

    chaser_initial_speed_LO = $58
    chaser_initial_speed_HI = $02
    chaser_max_speed_LO = $D0
    chaser_max_speed_HI = $02

    chaser_speed_increase= $14
    number_of_lives = 3
.endscope

   

.enum Game_States_e
    start_screen =  0
    running = 1
    paused = 2
    game_over = 3
    level_restart = 4
    next_level = 5
    intro = 6
    win = 7

.endenum


.endif