import numpy as np
import os
import math

rows = 30
cols = 32
def main():
    cwd = os.getcwd()
    cwd = cwd + "\\graphics\\Backgrounds"
    files  = os.listdir(cwd)
    for file in files:
        if "_T.bin" not in file and ".bin" in file and "_at.bin" not in file:
            input_file = cwd + "\\" + file
            output_file = input_file.replace(".bin", "_T.bin")
            output_at_file = input_file.replace(".bin", "_at_T.bin")
 

 
    
            i = 0
            j = 0
            bg_data = np.zeros((30, 32), dtype=np.uint8)
            attributeTable = np.zeros((2,32 ), dtype=np.uint8)
            attributeTable_T = np.zeros((8,8 ), dtype=np.uint8)
            with open(input_file, 'rb') as f:
                
                while (byte := f.read(1)):
                    if j >= 30:
                        attributeTable[j-30, i]  = byte[0]
                    else:
                        bg_data[j,i] = byte[0]
                    i += 1
                    if i >= 32:
                        i = 0
                        j += 1
                    
            for i in range(0,64):
                    attributeTable_T[i%8, math.floor(i/8)] = attributeTable[math.floor(i/32), i%32]
        

            with open(output_file, 'wb') as file:
                
                for i in range(0, 32):
                    for j in range(0, 30):
                        val = bg_data[j,i]
                        file.write(val)
            with open(output_at_file, 'wb') as file:
                for i in range(0,64):
                    val =attributeTable_T[math.floor(i/8), i%8]
                    file.write(val)

    input_file_num_bytes = os.stat(input_file).st_size
    output_file_num_bytes = os.stat(output_file).st_size
    print('Input total file size (bytes):', input_file_num_bytes)
    print('Output total file size (bytes):', output_file_num_bytes)




if __name__ == "__main__":
    main()