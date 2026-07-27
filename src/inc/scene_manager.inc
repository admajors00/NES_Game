.ifndef _SCENE_MANAGER_INC
_SCENE_MANAGER_INC = 1

scroll_HI_prev = $30
bg_data_pt_LO = $31
bg_data_pt_HI = $32
at_data_pt_LO = $60
at_data_pt_HI = $61

level_sc_array_pt_LO = $33
level_sc_array_pt_HI = $34



nametable = $35

column_LO = $36
column_HI = $37

new_background_LO = $38
new_background_HI = $39

column_number = $3A

scroll_flags = $3B
curr_sc_pt_LO = $3C
curr_sc_pt_HI = $3D

scroll = $3e
scroll_HI = $3f


NEW_COLUMN_FLAG = 1<<0
NEW_ATTRIBUTE_FLAG = 1<<1
STATUS_BAR_FLAG = 1<<2
USE_RANDOM_BACKGROUND = 1<<3
NEW_BG_FLAG= 1<<4

.endif