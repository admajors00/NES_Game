import argparse
import os

MAX_BYTE_COUNT = 255

def main():
    cwd = os.getcwd()
    cwd = cwd + "\\graphics\\Backgrounds"
    files  = os.listdir(cwd)
    total_uncomp_size = 0
    total_comp_size = 0
    for file in files:
        if "_T.bin" in file:
            input_file = cwd + "\\" + file
            output_file = input_file.replace("_T.bin", ".rle")
            

            if os.path.isfile(output_file):
                os.remove(output_file)

            with open(input_file, 'rb') as f:
                bytes_read = f.read()
                
                prev_byte = ''
                count = 0
                for byte in bytes_read:
                    if prev_byte == '':
                        prev_byte = byte
                        count = 1
                    elif byte == prev_byte:
                        count += 1
                    
                    # I may modify this at some point to use negative
                    # numbers to represent a list of bytes which should
                    # be copied as-is. For example, a count of -6 would mean
                    # that the next six bytes should be copied as-is.
                    #
                    # I could convert a negative number n to an 8-bit two's complement
                    # number for conversion to hex by doing the following per the Wikipedia
                    # article:
                    #
                    # = 2^8 - n
                    #
                    # For n = -5
                    # = 2^8 - 5
                    # = 251
                    #
                    # This means I would need to limit the following count to 127
                    if count == MAX_BYTE_COUNT:
                        write_byte(output_file, count, prev_byte)
                        prev_byte = byte
                        count = 0
                        
                    if byte != prev_byte:
                        write_byte(output_file, count, prev_byte)
                        
                        #print('setting prev_byte to',byte)
                        prev_byte = byte
                        count = 1
                        
                
                # write final byte to file
                write_byte(output_file, count, prev_byte)
                
                # tack on terminating #$00 bytes
                write_byte(output_file, 0, 0)
            
            # print file compression info
            input_file_num_bytes = os.stat(input_file).st_size
            output_file_num_bytes = os.stat(output_file).st_size

            compression_pct = 1 - (output_file_num_bytes / input_file_num_bytes)
            print( f"{file:<30} Compression (%): {compression_pct * 100:>12.1f}")
            if compression_pct < 0:
                total_comp_size += input_file_num_bytes
            else:
                total_comp_size += output_file_num_bytes
            total_uncomp_size += input_file_num_bytes
        
    print('Input total file size (bytes):', total_uncomp_size)
    print('Output total file size (bytes):', total_comp_size)
    compression_pct = 1 - (total_comp_size / total_uncomp_size)
    print(f"Compression (%): {compression_pct * 100:.1f}")
    print( "Bytes Saved : ",total_uncomp_size - total_comp_size )
    print()

def write_byte(output, count, byte):
    #print('writing',count,'of',bytes([byte]))
    with open(output, 'ab') as g:
        g.write(bytes([count]))
        g.write(bytes([byte]))

if __name__ == "__main__":
    main()