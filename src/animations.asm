;adress space is $20-$2F

.scope animation
    .scope skateboard_cruising
        info:
            .byte $03,frames_LT, $00

        frames_LT:
            .byte frame_1, frame_2
        frame_1:
            .byte $08, $02, frame_1_tiles, $00

        frame_1_tiles:
            .byte $D0, $D1 

        frame_2:
            .byte $08, $02, frame_2_tiles, $00

        frame_2_tiles:
            .byte $D4, $D5 
    .endscope

.endscope



Metasprite0:


	.byte - 8,- 8,$24,0
	.byte   0,- 8,$25,0
	.byte - 8,  0,$26,0
	.byte   0,  0,$27,0

	.byte $80


