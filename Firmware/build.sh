#!/bin/sh

file=$1
path=$(dirname $file)
fileext=$(basename $file)
name=${fileext%.*}
newfile="$path/$name.elf"

riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -c $file -o $newfile
go run ./memory/main.go --file $newfile
mv ./*.mif ../CPU/Design/src/
riscv64-unknown-elf-objdump -M no-aliases,numeric -d $newfile
