package main

import (
	"debug/elf"
	"encoding/hex"
	"fmt"
	"io/ioutil"
	"path/filepath"
	"strings"
)

func WritePartitions(partitions [][]byte, wordSize int, byteSize int, memorySize int) {

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
		fileName := filepath.Join("out", fmt.Sprintf("intel_mem_%d.mif", i))
		ioutil.WriteFile(fileName, []byte(stringBuilder.String()), 0644)
	}
}

func PrintPartitions(partitions [][]byte) {
	for i, partition := range partitions {
		fmt.Printf("Partition: %d: ", i+1)
		for j := range partition {
			fmt.Printf("%s ", hex.EncodeToString(partition[j:j+1]))
		}
		fmt.Printf("\n")
	}
}

func CreateMemory(sections []*elf.Section) []byte {
	var memory []byte
	text_section, rodata_section, data_section := getSections(sections)

	if text_section != nil {
		elf_bytes, err := text_section.Data()
		HandleError(err)
		memory = append(memory, elf_bytes...)
	}

	if rodata_section != nil {
		elf_bytes, err := rodata_section.Data()
		HandleError(err)
		memory = append(memory, elf_bytes...)
	}

	if data_section != nil {
		elf_bytes, err := data_section.Data()
		HandleError(err)
		memory = append(memory, elf_bytes...)
	}

	return memory
}

func CreatePartitions(memory []byte, memoryPartitions [][]byte, bytesInWord int) {
	for i := 0; i < len(memory); i += bytesInWord {
		bytes := memory[i : i+bytesInWord]
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
