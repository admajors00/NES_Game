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
column = $80
bytesWritten = $81
temp = $82
temp2 = $83
index = $84


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
  lda #0
  sta column
  sta bytesWritten
    RTS




buffOffset = $85
temp3 = $86

DecodeRLEScreenIntoBuffer:
  ; check if we need to add an offset for status bar
  lda #STATUS_BAR_FLAG
  and scroll_flags
  ldx #$21
  stx bytesWritten
  bne @add_status_bar_offset
    ldx #$1e ; skip attribute table  
    stx buffOffset
    
    jmp @add_status_bar_offset_done
	@add_status_bar_offset:
		ldx #$16 ; skip attribute table and status bar
    stx buffOffset
	@add_status_bar_offset_done:
  
  
  ldx temp3
  beq @cont3
    ldy index
    LDA (bg_data_pt_LO),y
    jmp @loop
  @cont3:
    inc index
    ldy index
  @big:
    ; get count and byte
    ; get count (has to be LDA rather than LDX)
    LDA (bg_data_pt_LO),y
    TAX
    CPX #$00
    BEQ @done
      INY
      inc index
      ; get byte
      LDA (bg_data_pt_LO), y
      

  @loop:
  ; skip writing first number of bytes to the buffer
    dec bytesWritten 
    stx temp3
    ldx bytesWritten
    cpx buffOffset
    BCS @skip2
  
      STA Scroll_Buffer, x
    @skip2:
    ;if we have written 32 bytes the column is complete
    

   
    ldx bytesWritten
    BEQ @done
    
    ldx temp3
    DEX
    BNE @loop
      INY
      inc index
      BNE @big
      INC bg_data_pt_LO+1
      JMP @big
    
  

  @done:
    lda #$00
    inc column
    ldx column
    cpx #30
    bne @skip
      sta index
      sta temp3
      sta column
    @skip:
    sta bytesWritten
    RTS

  .endscope