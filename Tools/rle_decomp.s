;;;;;;;;;;;;;;;;

.segment "CODE"
.scope RLE


column = $80
bytesWritten = $81
temp = $82
temp2 = $83
index = $84
buffOffset = $85
bytes_to_write = $86
temp_bg_pointer_LO = $87
temp_bg_pointer_HI = $88


LoadRLEScreen:
  lda #0
  sta column
  sta temp
  ; set output address
  lda #%00000100
  sta PpuCtrl
  LDA PpuStatus
  
  LDA #$20
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
    cpx #30
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
  sta temp
  sta bytesWritten
  LDA PpuStatus
  LDA #$20
  STA PpuAddr
  LDA #$00
  STA PpuAddr
  
  RTS







DecodeRLEScreenIntoBuffer:
  ; Load bytes Written with the number of times we want to write to buffer
  ; buffer needs to be filled bottom up
  ldx #$1E
  stx bytesWritten

  lda #NEW_BG_FLAG
	and scroll_flags
  beq @do_not_update_bg_pointer
    lda #$00
    sta index
    sta bytes_to_write
    sta column
    ldx bg_data_pt_LO
    stx temp_bg_pointer_LO
    ldx bg_data_pt_HI
    stx temp_bg_pointer_HI

  @do_not_update_bg_pointer:

  ; check if we need to add an offset for status bar
  lda #STATUS_BAR_FLAG
  and scroll_flags
  bne @add_status_bar_offset
    ; No offset
    ldx #$1f
    stx buffOffset
    
    jmp @add_status_bar_offset_done
	@add_status_bar_offset:
    ; skip status bar
		ldx #$1f
    stx buffOffset
	@add_status_bar_offset_done:
  


  ldy index
  ldx bytes_to_write
  beq @big
    ; some bytes were left over from last loop,
    ; index is currently on the byte that should be written to buffer
    LDA (temp_bg_pointer_LO),y
    jmp @loop
  
  @big:
    ; get count and byte
    ; get count (has to be LDA rather than LDX)
    LDA (temp_bg_pointer_LO),y
    TAX
    BEQ @last_column
      INY
      ; get byte
      LDA (temp_bg_pointer_LO), y
      

  @loop:
    
    stx bytes_to_write
    
    ; buffer is filled backwards, skip first buffOffset bytes
    ; While bytes written is greater than buffer offset 
    ; do not write to the buffer
    
    ldx bytesWritten
    cpx buffOffset
    BCS @do_not_write_to_buffer
      STA Scroll_Buffer, x
    @do_not_write_to_buffer:

    ;if we have written 32 bytes the column is complete
    dec bytes_to_write
    dec bytesWritten
    BEQ @done
    ldx bytes_to_write
    
    BNE @loop
      INY
      BNE @big
      INC temp_bg_pointer_LO+1
      JMP @big
    
  

   @done:
    sty index
    inc column
    ldx bytes_to_write
    BNE @dont_inc_index
      inc index
      BNE @dont_inc_index
        INC temp_bg_pointer_LO+1
    
    @dont_inc_index:
    RTS

    @last_column:
      lda #$00
      sta index
      sta bytes_to_write
      sta column
    RTS

Reset_RLE_Variables:

  lda #0
  sta index
  sta bytes_to_write
  sta column
  rts


DecodeRLEAttributeTableIntoBuffer:
    
  lda #$00
  sta bytesWritten
  
  lda #%00000000
  sta PpuCtrl
  LDA PpuStatus

  cpx #00
  Bne @loadOne
    LDA #$23
    JMP @cont
  @loadOne:
    LDA #$27
  @cont:
    STA PpuAddr
    LDA #$C0
    STA PpuAddr
    LDY #$00
  @big:
    ; get count and byte
    ; get count (has to be LDA rather than LDX)
    LDA (at_data_pt_LO),y
    TAX
    CPX #$00
    BEQ @done
    INY
    ; get byte
    LDA (at_data_pt_LO), y
  @loop:   
    STA PpuData
    DEX
    BNE @loop
      INY
      BNE @big
        INC at_data_pt_LO+1
        JMP @big


  @done:

  
  RTS

.endscope