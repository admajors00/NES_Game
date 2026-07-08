;;;;;;;;;;;;;;;;

.segment "CODE"
.scope RLE
LoadRLEScreen:
  ; Clobbers: A, X
;   LDA #bg_data_pt_LO
;   STA main_pointer_LO
;   LDA #bg_data_pt_HI
;   STA main_pointer_HI

 

  JSR DecodeRLEScreen
RTS
;;;;;;;;;;;;;;;;
;; DecodeRLEScreen
;;
;; Decodes an RLE-compressed screen and loads it into the background.
;;
;;
;; Sample usage:
;;
;;   LDA #<bg_title_screen
;;   STA pointer+0
;;   LDA #>bg_title_screen
;;   STA pointer+1
;;
;;   ; set which nametable to load (0 = nametable 0, 1 = nametable 1)
;;   LDX #$00
;;
;;   JSR DecodeRLEScreen
;;
;; Clobbers: A, X, Y
.export column = $84
.export bytesWritten = $81
.export temp = $82
.export temp2 = $83
DecodeRLEScreen:
    ; set output address
    lda #%00000100
	  sta PpuCtrl
    LDA PpuStatus
    CPX #$01
    BEQ @loadOne
    LDA #$20
    JMP @cont
  @loadOne:
    LDA #$24
  @cont:
    STA PpuAddr
    LDA #$00
    STA PpuAddr

    ; ; copy screen to VRAM
    ; Decode RLE
    LDY #$00
  @big:
    ; get count and byte
    ; get count (has to be LDA rather than LDX)
    LDA (bg_data_pt_LO),y
    TAX
    CPX #$00
    BEQ @done
    INY
    ; get byte
    LDA (bg_data_pt_LO), y
  @loop:
    STA PpuData
    
    ;if we have written 32 bytes the column is complete
    ;incriment the collumn number
    stx temp

    inc bytesWritten 
    ldx bytesWritten
    cpx #32
    BEQ @nextcol
    
  @return:
  ldx temp
    DEX
    BNE @loop
    INY
    BNE @big
    INC bg_data_pt_LO+1
    JMP @big
  @nextcol:
    
    inc column
    sta temp2
    lda PpuStatus
    lda #$20
    STA PpuAddr
    lda column
    STA PpuAddr
    lda #$00
    sta bytesWritten
    
    lda temp2
    jmp @return

  @done:
    RTS






DecodeRLEScreenIntoBuffer:
   ; set output address
    lda #%00000100
	  sta PpuCtrl
    LDA PpuStatus
    CPX #$01
    BEQ @loadOne
    LDA #$20
    JMP @cont
  @loadOne:
    LDA #$24
  @cont:
    STA PpuAddr
    LDA #$00
    STA PpuAddr

    ; ; copy screen to VRAM
    ; Decode RLE
    LDY #$00
  @big:
    ; get count and byte
    ; get count (has to be LDA rather than LDX)
    LDA (bg_data_pt_LO),y
    TAX
    CPX #$00
    BEQ @done
    INY
    ; get byte
    LDA (bg_data_pt_LO), y
  @loop:
    STA PpuData
    
    ;if we have written 32 bytes the column is complete
    ;incriment the collumn number
    stx temp

    inc bytesWritten 
    ldx bytesWritten
    cpx #32
    BEQ @nextcol
    
  @return:
  ldx temp
    DEX
    BNE @loop
    INY
    BNE @big
    INC bg_data_pt_LO+1
    JMP @big
  @nextcol:
    
    inc column
    sta temp2
    lda PpuStatus
    lda #$20
    STA PpuAddr
    lda column
    STA PpuAddr
    lda #$00
    sta bytesWritten
    
    lda temp2
    jmp @return

  @done:
    RTS

  .endscope