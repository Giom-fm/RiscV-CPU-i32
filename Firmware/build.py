import subprocess
import os
import sys
import argparse


TOOLPATH = 'compiler\\riscv64-unknown-elf-gcc-10.1.0-2020.08.2-x86_64-w64-mingw32\\bin\\'

FILENAME_ASSEMBLER_COMPILED = 'crt0.o'
FILENAME_ELF = 'out.elf'
FILENAME_MIF = 'intel_mem_%.mif'
FILENAME_COE = 'xilinx_mem.coe'
OUTPUTPATH = 'out'



def format_readelf(input_readElf: str) -> list:
    # entfernen der Leerezilen
    resList = input_readElf.split("\r\n")[2:-2]
    # erzeugen einen zusammenhaengenden Strings ohne Adresse und Char-Representation
    hexStr = ''.join([i[13:48] + ' ' for i in resList])
    # erzeugen der Liste von jeweils 32-Bit Speicherzellen
    hexList = hexStr.strip().split(' ')
    # ueberfuehren in litte Endian
    hexList_littleEndian = [i[6:8] + i[4:6] + i[2:4] + i[0:2] for i in hexList]
    return hexList_littleEndian


def to_intel_mif(data: list, filename: str):
    for i in range(4):
        # mif-Headder
        mif_file = "DEPTH = 16384;\nWIDTH = 8;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
        for count, value in enumerate(data):
            # aufteilen auf Byte-Bloecke
            mif_file += '{c:x}: {data};\n'.format(c=count, data=value[i*2:i*2+2])
        # Restliche Felder besetzen
        mif_file += "[{c:x}..3fff]: 00;\n\nEND;".format(c=len(data))
        # Daten in File schreiben, im Filename wird das %-Zeichen ersetzt
        file = open(filename.replace('%', str(i)), 'w')
        file.write(mif_file)
        file.close()


def to_xilinx_coe(data: list, filename: str):
    coe_file = "memory_initialization_radix=16;\nmemory_initialization_vector=\n"
    coe_file += ',\n'.join(data)
    coe_file += ";"
    file = open(filename, 'w')
    file.write(coe_file)
    file.close()


if __name__ == "__main__":
    # Parser erstellen
    parser = argparse.ArgumentParser(description="rvi32 - compiler")
    parser.add_argument('-i', metavar='Filename', help='Input-File', required=True)
    parser.add_argument('--print', action="store_true", help='Output-Path')
    parser.add_argument('--mif', action="store_true", help='Output in Intel mif-File')
    parser.add_argument('--coe', action="store_true", help='Output in Xilinx coe-File')
    args = parser.parse_args()

    FILE = args.i

    # compilieren assembler
    try:
        subprocess.check_output(
            TOOLPATH + 'riscv64-unknown-elf-as.exe -march=rv32i -mabi=ilp32 crt0.s '
            + '-o ' + OUTPUTPATH + '/'+ FILENAME_ASSEMBLER_COMPILED)
    except subprocess.CalledProcessError:
        print("build failed!")
        exit(1)

    # compilieren c-file und linken
    try:
        subprocess.check_output(
            TOOLPATH + 'riscv64-unknown-elf-gcc.exe -ffunction-sections -nostdlib -march=rv32i -mabi=ilp32 -O1 -T linker.lds '
            #TOOLPATH + 'riscv64-unknown-elf-gcc.exe -march=rv32i -mabi=ilp32 -O1 -T linker.lds '
            + OUTPUTPATH + '/' + FILENAME_ASSEMBLER_COMPILED + ' '
            + FILE + ' '
            + '-o ' + OUTPUTPATH + '/' + FILENAME_ELF)
    except subprocess.CalledProcessError:
        print("build failed!")
        exit(1)

    # print objdump
    if args.print:
        os.system(
            TOOLPATH + 'riscv64-unknown-elf-objdump.exe -d '
            + OUTPUTPATH + '/' + FILENAME_ELF + ' '
            + '-M numeric -M no-aliases')

    # read elf section .text
    data_text = subprocess.check_output(
        TOOLPATH + 'riscv64-unknown-elf-readelf.exe -x .text '
        + OUTPUTPATH + '/' + FILENAME_ELF).decode('utf8')

    print(data_text)
    data_combined = format_readelf(data_text)

    # read elf section .rodata
    data_rodata = subprocess.check_output(
        TOOLPATH + 'riscv64-unknown-elf-readelf.exe -x .rodata '
        + OUTPUTPATH + '/' + FILENAME_ELF).decode('utf8')

    print(data_rodata)
    data_combined += format_readelf(data_rodata)

    # read elf section .data
    data_data = subprocess.check_output(
        TOOLPATH + 'riscv64-unknown-elf-readelf.exe -x .data '
        + OUTPUTPATH + '/' + FILENAME_ELF).decode('utf8')

    print(data_data)
    data_combined += format_readelf(data_data)

    # zusammenfuegen der elf-sections (filtert leere Bereiche)
    data = [i.ljust(8, '0') for i in data_combined if i]
    print(data)

    # Ausgabe in Intel-mif
    if args.mif:
        to_intel_mif(data, OUTPUTPATH + '/' + FILENAME_MIF)
    
    # Ausgabe in Xilinx-coe
    if args.coe:
        to_xilinx_coe(data, OUTPUTPATH + '/' + FILENAME_COE)

    exit(0)
