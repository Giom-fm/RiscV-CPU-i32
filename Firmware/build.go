/*
 * A tool that takes an ELF and creates MIFs from it for the softcore.
 *
 * Author: Guillaume Fournier-Mayer (tinf101922)
 * Date: 09.05.2021
 */

package main

import (
	"debug/elf"
	"flag"
	"log"
	"os"
)

/*
 * Main routine. Sets the flags to be loaded and checks them.
 */
func main() {

	// Flags
	srcPath := flag.String("source", "", "Path to source code")
	bootPath := flag.String("bootloader", "crt0.s", "Path to Bootloader code")
	linkerPath := flag.String("linker", "linker.lds", "Path to linker Script File")
	wordSize := *flag.Int("wordsize", 32, "Size of word in bit")
	byteSize := *flag.Int("bytesize", 8, "Size of byte in bit")
	memorySize := *flag.Int("memorySize", 16384, "Memory Size in Words")
	print := *flag.Bool("print", true, "Print ELF infos")
	bytesInWord := wordSize / byteSize

	flag.Parse()
	handleFlags(srcPath, bootPath, linkerPath)
	elfPath := Build(*srcPath, *bootPath, *linkerPath)
	_elf, err := elf.Open(elfPath)
	HandleError(err)

	// Creates the partitions
	memory := CreateMemory(_elf.Sections)
	memoryPartitions := make([][]byte, bytesInWord)
	CreatePartitions(memory, memoryPartitions[:], bytesInWord)
	WritePartitions(memoryPartitions, wordSize, byteSize, memorySize)

	// If the flag "print" is set, the partitions will be printed.
	if print {
		PrintPartitions(memoryPartitions[:])
		PrintElfInfos(elfPath)
	}

}

/*
 * Checks the flags and verifies if the necessary ones are set
 *
 * @param srcPath The path to the source file
 * @param bootPath The path to the bootloader
 * @param linkerPath The path to the linkersrcipt
 */
func handleFlags(srcPath *string, bootPath *string, linkerPath *string) {
	var err error

	if *srcPath == "" || *bootPath == "" || *linkerPath == "" {
		flag.PrintDefaults()
		os.Exit(0)
	}

	_, err = os.Stat(*srcPath)
	if os.IsNotExist(err) {
		log.Fatal("Source does not exist.")
		os.Exit(1)
	}

	_, err = os.Stat(*bootPath)
	if os.IsNotExist(err) {
		log.Fatal("Bootloader does not exist.")
		os.Exit(1)
	}

	_, err = os.Stat(*linkerPath)
	if os.IsNotExist(err) {
		log.Fatal("Linker Script does not exist.")
		os.Exit(1)
	}

}

/*
 * Checks whether the error object contains an error and stops the program if
 * this is the case
 */
func HandleError(err error, msg ...string) {
	if err != nil {
		log.Fatal(msg)
		panic(err.Error())
	}
}
