package main

import (
	"debug/elf"
	"encoding/hex"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

// TODO Output path

/*
	fmt.Printf("File Header: ")
	fmt.Println(_elf.FileHeader)
	fmt.Printf("ELF Class: %s\n", _elf.Class.String())
	fmt.Printf("Machine: %s\n", _elf.Machine.String())
	fmt.Printf("ELF Type: %s\n", _elf.Type)
	fmt.Printf("ELF Data: %s\n", _elf.Data)
	fmt.Printf("Entry Point: %d\n", _elf.Entry)
	fmt.Printf("Section Addresses: %d\n", _elf.Sections)
	fmt.Printf("Section Addresses: %d\n", _elf.Sections)
*/

func main() {

	path := flag.String("file", "", "Path to binary")
	wordSize := *flag.Int("wordsize", 32, "Size of word in bit")
	byteSize := *flag.Int("bytesize", 8, "Size of byte in bit")
	memorySize := *flag.Int("memorySize", 16384, "Memory Size in Words")
	bytesInWord := wordSize / byteSize

	flag.Parse()
	handleFlags(path)

	_elf, err := elf.Open(*path)
	handleError(err)

	var memory []byte
	elf_text := getTextSection(_elf.Sections)
	elf_rodata := getRoDataSection(_elf.Sections)
	elf_data := getDataSection(_elf.Sections)

	if elf_text != nil {
		elf_bytes, err := elf_text.Data()
		handleError(err)
		memory = append(memory, elf_bytes...)
	}

	if elf_rodata != nil {
		elf_bytes, err := elf_rodata.Data()
		handleError(err)
		memory = append(memory, elf_bytes...)
	}

	if elf_data != nil {
		elf_bytes, err := elf_data.Data()
		handleError(err)
		memory = append(memory, elf_bytes...)
	}

	memoryPartitions := make([][]byte, bytesInWord)
	createPartitions(memory, memoryPartitions[:], bytesInWord)
	printPartitions(memoryPartitions[:])
	writePartitions(memoryPartitions, wordSize, byteSize, memorySize)
}

func writePartitions(partitions [][]byte, wordSize int, byteSize int, memorySize int) {

	for i, partition := range partitions {
		var stringBuilder strings.Builder

		stringBuilder.WriteString(fmt.Sprintf("DEPTH = %d;\n", memorySize))
		stringBuilder.WriteString(fmt.Sprintf("WIDTH = %d;\n", byteSize))
		stringBuilder.WriteString("ADDRESS_RADIX = HEX;\n")
		stringBuilder.WriteString("DATA_RADIX = HEX;\n")
		stringBuilder.WriteString("CONTENT\nBEGIN\n\n")

		for j := range partition {
			stringBuilder.WriteString(fmt.Sprintf("%x: ", j))
			stringBuilder.WriteString(hex.EncodeToString(partition[j : j+1]))
			stringBuilder.WriteString(";\n")
		}
		stringBuilder.WriteString(fmt.Sprintf("[%s..%s]: 00;\n\n", fmt.Sprintf("%x", len(partitions[0])), fmt.Sprintf("%x", memorySize-1)))
		stringBuilder.WriteString("END;")
		ioutil.WriteFile(fmt.Sprintf("intel_mem_%d.mif", i), []byte(stringBuilder.String()), 0644)
	}
}

func printPartitions(partitions [][]byte) {
	for i, partition := range partitions {
		fmt.Printf("Partition: %d: ", i+1)
		for j := range partition {
			fmt.Printf("%s ", hex.EncodeToString(partition[j:j+1]))
		}
		fmt.Printf("\n")
	}
}

func createPartitions(memory []byte, memoryPartitions [][]byte, bytesInWord int) {
	for i := 0; i < len(memory); i += bytesInWord {
		bytes := memory[i : i+bytesInWord]
		//reverseBytes(bytes)
		for j := 0; j < bytesInWord; j++ {
			memoryPartitions[j] = append(memoryPartitions[j], bytes[j])
		}
	}
}

func reverseBytes(bytes []byte) {
	for i, j := 0, len(bytes)-1; i < j; i, j = i+1, j-1 {
		bytes[i], bytes[j] = bytes[j], bytes[i]
	}
}

func getTextSection(sections []*elf.Section) *elf.Section {
	for _, section := range sections {
		if section.SectionHeader.Name == ".text" {
			return section
		}
	}
	return nil
}

func getDataSection(sections []*elf.Section) *elf.Section {
	for _, section := range sections {
		if section.SectionHeader.Name == ".data" {
			return section
		}
	}

	return nil
}

func getRoDataSection(sections []*elf.Section) *elf.Section {
	for _, section := range sections {
		if section.SectionHeader.Name == ".rodata" {
			return section
		}
	}
	return nil
}

func handleFlags(path *string) {
	if *path == "" {
		flag.PrintDefaults()
		os.Exit(0)
	}
}

func handleError(err error) {
	if err != nil {
		panic(err)
	}
}
