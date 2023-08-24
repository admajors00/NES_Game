BUTTON_A      = 1 << 7
BUTTON_B      = 1 << 6
BUTTON_SELECT = 1 << 5
BUTTON_START  = 1 << 4
BUTTON_UP     = 1 << 3
BUTTON_DOWN   = 1 << 2
BUTTON_LEFT   = 1 << 1
BUTTON_RIGHT  = 1 << 0

Port_1 = $4016

Port_1_Pressed_Buttons = $20


UpdateButtons:
    lda #$01
    sta Port_1
    sta Port_1_Pressed_Buttons
    lda #$00
    sta Port_1

    @loop:
    lda Port_1
    lsr
    rol Port_1_Pressed_Buttons
    bcc @loop

    rts

