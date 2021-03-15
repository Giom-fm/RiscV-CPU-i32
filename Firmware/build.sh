#!/bin/sh

file=$1
path=$(dirname $file)
fileext=$(basename $file)
name=${fileext%.*}
newfile="$path/$name.elf"

riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 crt0.s -o crt0.o
riscv64-unknown-elf-gcc -ffunction-sections -nostdlib -march=rv32i -mabi=ilp32 -I /usr/include/ -T linker.lds crt0.o $file -o $newfile
#riscv64-unknown-elf-gcc -ffunction-sections -nostdlib -march=rv32i -mabi=ilp32 -O1 -I /usr/include/ -T linker.lds  $file -o $newfile
go run ./memory/main.go --file $newfile
cp ./*.mif ../CPU/Design-Test/src/
mv ./*.mif ../CPU/Design/src/memory/
riscv64-unknown-elf-objdump -M no-aliases -d $newfile
