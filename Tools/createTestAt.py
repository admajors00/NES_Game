import numpy as np
import os
import math

def main():
    fileName1 = "TestAT1.bin"
    fileName2 = "TestAT2.bin"
    attributeTable = np.zeros((2,32 ), dtype=np.uint8)
    
    attributeTable_T = np.zeros((8,8 ), dtype=np.uint8)


    
    for i in range(0,64):
        attributeTable[math.floor(i/32), i%32] = i

    for i in range(0,64):
        attributeTable_T[i%8, math.floor(i/8)] = attributeTable[math.floor(i/32), i%32]

    with open(fileName1, 'wb') as file:
        for i in range(0,64):
            val =attributeTable[math.floor(i/32), i%32]
            file.write(val)
    with open(fileName2, 'wb') as file:
        for i in range(0,64):
            val =attributeTable_T[math.floor(i/8), i%8]
            file.write(val)

if __name__ == "__main__":
    main()
