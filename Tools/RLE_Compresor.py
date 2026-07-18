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
    total_comp_unop_size = 0
    total_uncomp_size= 0

    for file in files:

        if ".bin" in file:
            input_file = cwd + "\\" + file
            bg_rle_file = input_file.replace(".bin", "_bg.rle")
            at_rle_file = input_file.replace(".bin", "_at.rle")

            bg_data, at_data = GetData(input_file)
            bg_data_ = RemoveStatusBar(bg_data)
            bg_data_T = TransposeBgData(bg_data_)      
            bg_data_comp = CompressData(bg_data_T)
            at_data_comp = CompressData( at_data)

            with open(bg_rle_file, 'wb') as f:
                for byte in bg_data_comp:
                    f.write(byte)

            with open(at_rle_file, 'wb') as f:
                for byte in at_data_comp:
                    f.write(byte)

  

            bg_compression_pct = 1 - (bg_data_comp.size / bg_data_.size)
            at_compression_pct = 1 - (at_data_comp.size / at_data.size)
            print(file)
            print( f"\t bg in: {bg_data_.size:>5} bg out: {bg_data_comp.size:>5}  {bg_compression_pct * 100:>6.1f}%")
            print( f"\t at in: {at_data.size:>5} at out: {at_data_comp.size:>5}  {at_compression_pct * 100:>6.1f}%")
            

            if bg_compression_pct < 0:
                total_comp_size += bg_data_.size
            else:
                total_comp_size += bg_data_comp.size
                
            if at_compression_pct < 0:
                total_comp_size += at_data.size
            else:
                total_comp_size += at_data_comp.size 

            total_comp_unop_size += bg_data_comp.size + at_data_comp.size
            total_uncomp_size += bg_data.size + at_data.size

    compression_pct = 1 - (total_comp_size / total_uncomp_size)
    print(f"Total size:      {total_uncomp_size}")
    print(f"Comp OP size:    {total_comp_size}")
    print(f"Comp unOP size:  {total_comp_unop_size}")
    print(f"space saved op:  {total_comp_unop_size - total_comp_size}")
    
    print(f"Comp size:  {compression_pct * 100:.1f}%")
    print(f"Bytes Saved:  {total_uncomp_size - total_comp_size}")
    return

def RemoveStatusBar(bg_data):
    col = 0
    row = 0
    statusBar = np.zeros((6, 32), dtype=np.uint8)
    cwd = os.getcwd()
    sb_fileName = cwd + "\graphics\Backgrounds\Statusbar.bin"
    with open(sb_fileName, 'rb') as f:
        while (byte := f.read(1)):      
            statusBar[row, col] = byte[0]
            col += 1
            if col >= 32:
                col = 0
                row += 1

    col = 0
    row = 0
    statusBar2 = np.zeros((6, 32), dtype=np.uint8)            
    sb2_fileName = cwd + "\graphics\Backgrounds\Statusbar2.bin"
    with open(sb2_fileName, 'rb') as f:
        while (byte := f.read(1)):      
            statusBar2[row, col] = byte[0]
            col += 1
            if col >= 32:
                col = 0
                row += 1            
    bg_data_sb = bg_data[0:6]
    bg_data_nsb = bg_data[6:]
    if(np.array_equal(statusBar,bg_data_sb ) or np.array_equal(statusBar2,bg_data_sb )):
        return bg_data_nsb
    else:
        return bg_data


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



def TransposeBgData( bg_data):
    if bg_data.size == 960:
        bg_data_T = np.zeros((32, 30), dtype=np.uint8)
        for i in range(0, 30):
            for j in range(0,32):
                bg_data_T[j, i] =  bg_data[ i, j]     
    elif bg_data.size == 768: 
        bg_data_T = np.zeros((32, 24), dtype=np.uint8)
        for i in range(0, 24):
            for j in range(0,32):
                bg_data_T[j, i] =  bg_data[ i, j]     
    return bg_data_T



def TransposeAtData(attribute_data):
    attribute_data_T = np.zeros((8,8), dtype=np.uint8)
    for i in range(0,64):
        attribute_data_T[i%8, math.floor(i/8)] = attribute_data[math.floor(i/32), i%32]
    return attribute_data_T
        


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