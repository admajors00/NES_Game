import argparse
import os
import numpy as np
import math

MAX_BYTE_COUNT = 255




def main():
    cwd = os.getcwd()
    binaryFileDirectory = cwd + "\\graphics\\Backgrounds"
    files = os.listdir(binaryFileDirectory)

    sb1_fileName = cwd + "\\graphics\\StatusBars\\Statusbar.bin"
    sb2_fileName = cwd + "\\graphics\\StatusBars\\Statusbar2.bin"
    sb1_data = GetStatusBarData(sb1_fileName)
    sb2_data = GetStatusBarData(sb2_fileName)

    
    total_comp_size = 0
    total_uncomp_size = 0
    print(f"{"Stats":-^100}")
    print( f"{"file":<20} BG: {"uncomp":^7}|{"sbRem":^7}|{"comp":^7}|{" comp% ":^7}| AT: {"uncomp":^7}|{"comp":^7}|{" comp%":^7}|")
    print(f"{"-":-^100}")
    for file in files:

        if ".bin" in file:
        
            input_file = binaryFileDirectory + "\\" + file
            bg_rle_file = input_file.replace(".bin", "_bg.rle")
            at_rle_file = input_file.replace(".bin", "_at.rle")

            didStatusBarGetRemoved = 0
            didBgDataGetSmaller = 0
            didAtDataGetSmaller = 0
            
            # pull binary data from file and store it in an array. Seperate attribute table from bg data
            bg_data, at_data = GetBgAndAtData(input_file) 
            # If the bg has a status bar, remove it. get bool status for if it wass removed
            bg_data_sb, didStatusBarGetRemoved  = CheckForAndRemoveStatusBar(bg_data, sb1_data)
            if not didStatusBarGetRemoved:
                bg_data_sb, didStatusBarGetRemoved  = CheckForAndRemoveStatusBar(bg_data, sb2_data)
            # transpose baground data so it can be read column by colum, for easy writing to the nametable with scroll
            bg_data_T = TransposeBgData(bg_data_sb)      
            # Compress the background data. If the size gets bigger return uncompresed. bool lets us know which happend to add to header
            bg_data_comp, didBgDataGetSmaller = CompressData(bg_data_T)
            # do the same for attribute data
            at_data_comp, didAtDataGetSmaller = CompressData(at_data)


            # append header as first byte so we know if this background contains a status bar and/or is compressed
            bgHeader = 0b00000000
            atHeader = 0b00000000
            if didBgDataGetSmaller:
                bgHeader = bgHeader & 0b00000001
            if didStatusBarGetRemoved:
                bgHeader = bgHeader & 0b00000010
            if didAtDataGetSmaller:
                atHeader = atHeader & 0b0000000
            bg_data_comp = np.insert(bg_data_comp, 0, bgHeader)
            at_data_comp = np.insert(at_data_comp, 0, atHeader)

            # write the bg file 
            with open(bg_rle_file, 'wb') as f:
                for byte in bg_data_comp:
                    f.write(byte)
            # write the attribute file
            with open(at_rle_file, 'wb') as f:
                for byte in at_data_comp:
                    f.write(byte)


            bg_compression_pct = 1 - (bg_data_comp.size / bg_data.size)
            at_compression_pct = 1 - (at_data_comp.size / at_data.size)
 
            total_comp_size += bg_data_comp.size + at_data_comp.size
            total_uncomp_size += bg_data.size + at_data.size

            print( f"{file:<20} {bg_data.size:>8}{bg_data_sb.size:>8} {bg_data_comp.size:>8}{bg_compression_pct * 100:>8.1f}% | {at_data.size:>8}{at_data_comp.size:>8}{at_compression_pct * 100:>8.1f}%")


    compression_pct = 1 - (total_comp_size / total_uncomp_size)

    print(f"{"-":-^100}")
    print(f"{"Total size:":<20}{total_uncomp_size}")
    print(f"{"Comp size:":<20}{total_comp_size}")
    print(f"{"Comp pct:":<20}{compression_pct * 100:.1f}%")
    print(f"{"Bytes Saved:":<20}{total_uncomp_size - total_comp_size}")
    print(f"{"-":-^100}")
    return




def GetStatusBarData(statusBarFileName):
    row = 0
    col = 0
    statusBarData = np.zeros((6,32), dtype=np.uint8)
    with open(statusBarFileName, 'rb') as f:
        while (byte := f.read(1)):      
            statusBarData[row, col] = byte[0]
            col += 1
            if col >= 32:
                col = 0
                row += 1  
    return statusBarData



def CheckForAndRemoveStatusBar(bg_data, sb_data):
    bg_data_sb = bg_data[0:6]
    bg_data_nsb = bg_data[6:]
    didStatusBarGetRemoved = 0
    if np.array_equal(sb_data,bg_data_sb ):
        didStatusBarGetRemoved = 1
        return bg_data_nsb, didStatusBarGetRemoved
    else:
        return bg_data, didStatusBarGetRemoved


def GetBgAndAtData(input_file):
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
    didFileGetSmaller = 0

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

    if( compressed_data.size < input_data.size):
        didFileGetSmaller = 1
        return compressed_data, didFileGetSmaller

    return input_data, didFileGetSmaller



if __name__ == "__main__":
    main()