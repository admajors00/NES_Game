
import os


def main():
    fileName = "src/inc/BackgroundData.inc"

    fileText = ".ifndef _BACKGROUNDDATA_INC\r\n_BACKGROUNDSDATA_INC  =1\r\n\n\n\n"
    cwd = os.getcwd()
    cwd = cwd + "\\graphics\\Backgrounds"
    files  = os.listdir(cwd)

    for file in files:
        if ".rle" in file:

            
            path =  "../graphics/Backgrounds/" + os.path.basename(file)
            dataName =    os.path.basename(file).replace(".rle", "")

            fileText = fileText + "\n" + dataName + ":\n\t.incbin \"" + path + "\"\n"

    fileText = fileText+ "\r\n\n\n.endif"

    with open(fileName, 'w') as f:
        f.write(fileText) 
if __name__ == "__main__":
    main()