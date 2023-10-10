.segment "CODE"

BUTTON_A      = 1 << 7
BUTTON_B      = 1 << 6
BUTTON_SELECT = 1 << 5
BUTTON_START  = 1 << 4
BUTTON_UP     = 1 << 3
BUTTON_DOWN   = 1 << 2
BUTTON_LEFT   = 1 << 1
BUTTON_RIGHT  = 1 << 0

Port_1 = $4016
Port_2 = $4017

Port_1_Pressed_Buttons = $F0 ;pressed this frame
Port_1_Down_Buttons = $F1;     = $31 ;held down
Port_1_Released_Buttons = $F2
UpdateButtons:
    lda Port_1_Down_Buttons
    tay
    lda #$01
    sta Port_1
    sta Port_1_Down_Buttons
    lsr
    ;lda #$00
    sta Port_1

    @loop:
        lda Port_1
        lsr
        rol Port_1_Down_Buttons
        bcc @loop
        tya
        eor Port_1_Down_Buttons
        and Port_1_Down_Buttons
        sta Port_1_Pressed_Buttons
    rts

