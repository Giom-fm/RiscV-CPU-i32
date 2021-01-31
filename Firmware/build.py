import subprocess
import os
import sys

TOOLPATH = 'compiler\\riscv64-unknown-elf-gcc-10.1.0-2020.08.2-x86_64-w64-mingw32\\bin\\'
FILE = 'src\\uart.c'

OUTPUTFILE = 'out\\out.elf'


def save_mif(filename: str, data: []):
    mif_file = "DEPTH = 16384;\nWIDTH = 8;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
    i = 0
    while i < len(data):
        mif_file += str(hex(i))[2:] + ': ' + data[i] + ';\n'
        i = i + 1
    mif_file += "[" + str(hex(i))[2:] + "..3fff]: 00;\n\nEND;"
    file = open(filename, 'w')
    file.write(mif_file)
    file.close()

def to_fpga_memory():
    res = subprocess.check_output(TOOLPATH + 'riscv64-unknown-elf-readelf.exe -x .text ' + OUTPUTFILE)

    obj = res.decode('utf8').split('\r\n')[3:-2]
    binary = ''.join([i[13:48] + ' ' for i in obj]).strip().split(' ')
    ordered_binary = []
    for word in binary:
        ordered_binary.append([word[i:i+2] for i in range(0, len(word), 2)])

    save_mif('out/memory_1.mif', [i[0] for i in ordered_binary])
    save_mif('out/memory_2.mif', [i[1] for i in ordered_binary])
    save_mif('out/memory_3.mif', [i[2] for i in ordered_binary])
    save_mif('out/memory_4.mif', [i[3] for i in ordered_binary])

if __name__ == "__main__":
    os.system(TOOLPATH + 'riscv64-unknown-elf-as.exe -march=rv32i -mabi=ilp32 crt0.s -o out/crt0.o')
    os.system(TOOLPATH + 'riscv64-unknown-elf-gcc.exe -ffunction-sections -nostdlib -march=rv32i -mabi=ilp32 -O1 -T linker.lds out/crt0.o ' + FILE + ' -o ' + OUTPUTFILE)
    os.system(TOOLPATH + 'riscv64-unknown-elf-objdump.exe -d ' + OUTPUTFILE + ' -M numeric -M no-aliases')
    
    #os.system(TOOLPATH + 'riscv64-unknown-elf-objcopy.exe --byte 0 -O ' + OUTPUTFILE + " out/out2.elf")
    to_fpga_memory()



