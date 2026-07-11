import argparse
import os
import numpy as np
import math

MAX_BYTE_COUNT = 255




def main():
    cwd = os.getcwd()
    cwd = cwd + "\\graphics\\Backgrounds"
    files  = os.listdir(cwd)
    total_comp_size = 0
    total_uncomp_size= 0

    for file in files:

        if ".bin" in file:
            input_file = cwd + "\\" + file
            bg_rle_file = input_file.replace(".bin", "_bg.rle")
            at_rle_file = input_file.replace(".bin", "_at.rle")

            bg_data, at_data = GetData(input_file)
            bg_data_T, at_data_T = TransposeData(bg_data, at_data)      
            bg_data_comp = CompressData(bg_data_T)
            at_data_comp = CompressData( at_data)

            with open(bg_rle_file, 'wb') as f:
                for byte in bg_data_comp:
                    f.write(byte)

            with open(at_rle_file, 'wb') as f:
                for byte in at_data_comp:
                    f.write(byte)

            bg_input_size  = bg_data.size * bg_data.itemsize
            bg_output_size = bg_data_comp.size * bg_data_comp.itemsize

            at_input_size  = at_data.size * at_data.itemsize
            at_output_size = at_data_comp.size * at_data_comp.itemsize

            bg_compression_pct = 1 - (bg_output_size / bg_input_size)
            at_compression_pct = 1 - (at_output_size / at_input_size)
            print(file)
            print( f"\t bg in: {bg_input_size:>5} bg out: {bg_output_size:>5}  {bg_compression_pct * 100:>6.1f}%")
            print( f"\t at in: {at_input_size:>5} at out: {at_output_size:>5}  {at_compression_pct * 100:>6.1f}%")

            if bg_compression_pct < 0:
                total_comp_size += bg_input_size
            else:
                total_comp_size += bg_output_size
            if at_compression_pct < 0:
                total_comp_size += at_input_size
            else:
                total_comp_size += at_output_size

            total_uncomp_size += bg_input_size + at_input_size

    compression_pct = 1 - (total_comp_size / total_uncomp_size)
    print(f"Total size: {total_uncomp_size}")
    print(f"Comp size:  {total_comp_size}")
    
    print(f"Comp size:  {compression_pct * 100:.1f}%")
    print(f"Bytes Saved:  {total_uncomp_size - total_comp_size}")
    return




def GetData(input_file):
    col = 0
    row = 0
    bg_data = np.zeros((30, 32), dtype=np.uint8)
    attribute_data = np.zeros((2,32), dtype=np.uint8)
    with open(input_file, 'rb') as f:
        while (byte := f.read(1)):
            if row >= 30:
                attribute_data[row-30, col]  = byte[0]
            else:
                bg_data[row, col] = byte[0]
            col += 1
            if col >= 32:
                col = 0
                row += 1
    return bg_data, attribute_data                   



def TransposeData( bg_data, attribute_data):

    bg_data_T = np.zeros((32, 30), dtype=np.uint8)
    attribute_data_T = np.zeros((8,8), dtype=np.uint8)

    for i in range(0, 30):
        for j in range(0,32):
            bg_data_T[j, i] =  bg_data[ i, j]     
                    
    for i in range(0,64):
        attribute_data_T[i%8, math.floor(i/8)] = attribute_data[math.floor(i/32), i%32]

    return bg_data_T, attribute_data_T
        


def CompressData(input_data):

    input_data = input_data.flatten()
    compressed_data = np.zeros((1, 0), dtype=np.uint8)
    prev_byte = ''
    count = 0

    for byte in input_data:

        if prev_byte == '':
            prev_byte = byte
            count = 1

        elif byte == prev_byte:
            count += 1
        
        if count == MAX_BYTE_COUNT:
            compressed_data = np.append(compressed_data,np.uint8( [count, prev_byte]))
            prev_byte = byte
            count = 0
            
        if byte != prev_byte:
            compressed_data = np.append(compressed_data, np.uint8([count, prev_byte]))
            prev_byte = byte
            count = 1
            
    
    # write final byte to file
    compressed_data = np.append(compressed_data, np.uint8([count, prev_byte]))
    
    # tack on terminating #$00 bytes
    compressed_data = np.append(compressed_data, np.uint8([0, 0]))

    return compressed_data



if __name__ == "__main__":
    main()