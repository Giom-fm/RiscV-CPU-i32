#!/bin/sh

 riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -c ./src/main.c -o ./src/main.elf
 go run ./memory/main.go --file ./src/main.elf
 mv ./*.mif ../CPU/Design/src/
 riscv64-unknown-elf-objdump -M no-aliases,numeric -d ./src/main.elf