
import numpy as np


filePath = "C:/Users/AndrewMajors/Documents/HRstuff/NESg/NES_Game/Tools/RLE_Test_uncomp.asm"
filename = "RLE_Test_uncomp.asm" #"OTA_Updates_2.txt"
with open(filePath, 'r') as file:
    contents = file.read().splitlines()
i=0
tableName = contents[0]
contents.remove(tableName)
uncompData=[[]]*30

attributeTable = [None]*2

for i, line in enumerate(contents):
    if i%2 == 0:
        pass
    else:   
        row1 = line.replace("\t.byte ", "" )
        row2= contents[i-1].replace("\t.byte ", "" )
        row1 = row1.split(',')[:-1]
        row2 = row2.split(',')[:-1]
        if i/2 < 30:
            for j in row1:
                uncompData[int(i/2)].append(j)
            for j in row2:
                uncompData[int(i/2)].append(j)  
        else:
            for j in range(0,15,1):
                attributeTable[int(i/2)-30][j] = row1[j]
            for j in range(16,31,1):
                attributeTable[int(i/2)-30][j] = row2[j-16]    

for line in uncompData:
    print(line)