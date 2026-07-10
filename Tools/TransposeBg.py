import numpy as np
import os

rows = 30
cols = 32
def main():
    cwd = os.getcwd()
    cwd = cwd + "\\graphics\\Backgrounds"
    files  = os.listdir(cwd)
    for file in files:
        if "_T.bin" not in file and ".bin" in file:
            input_file = cwd + "\\" + file
            output_file = input_file.replace(".bin", "_T.bin")
 

 
    
            i = 0
            j = 0
            bg_data = np.zeros((32, 32), dtype=np.uint8)
            bg_data_T = np.zeros((32, 32), dtype=np.uint8)
            with open(input_file, 'rb') as f:
                
                while (byte := f.read(1)):
                    bg_data[j,i] = byte[0]
                    bg_data_T[i,j] = byte[0]
                    i += 1
                    if i >= 32:
                        i = 0
                        j += 1
                    if j >= 30:
                        break

        

            with open(output_file, 'wb') as file:
                
                for i in range(0, 32):
                    for j in range(0, 32):
                        val = bg_data[j,i]
                        file.write(val)

        # input_file_num_bytes = os.stat(input_file).st_size
        # output_file_num_bytes = os.stat(output_file).st_size
        # print('Input total file size (bytes):', input_file_num_bytes)
        # print('Output total file size (bytes):', output_file_num_bytes)

if __name__ == "__main__":
    main()