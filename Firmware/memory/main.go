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

	memory := createMemory(_elf.Sections)
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

func createMemory(sections []*elf.Section) []byte {
	var memory []byte
	text_section, rodata_section, data_section := getSections(sections)

	if text_section != nil {
		elf_bytes, err := text_section.Data()
		handleError(err)
		memory = append(memory, elf_bytes...)
	}

	if rodata_section != nil {
		elf_bytes, err := rodata_section.Data()
		handleError(err)
		memory = append(memory, elf_bytes...)
	}

	if data_section != nil {
		elf_bytes, err := data_section.Data()
		handleError(err)
		memory = append(memory, elf_bytes...)
	}

	return memory
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

func getSections(sections []*elf.Section) (*elf.Section, *elf.Section, *elf.Section) {

	var text *elf.Section
	var data *elf.Section
	var rodata *elf.Section

	for _, section := range sections {
		if section.SectionHeader.Name == ".text" {
			text = section
		} else if section.SectionHeader.Name == ".rodata" {
			rodata = section
		} else if section.SectionHeader.Name == ".data" {
			data = section
		}
	}
	return text, rodata, data
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
