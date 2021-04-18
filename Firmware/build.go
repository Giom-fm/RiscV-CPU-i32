package main

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func Build(srcPath string, bootPath string, linkerPath string) string {

	createOutputDir()

	srcDest := getDestination(srcPath, "elf")
	bootDest := getDestination(bootPath, "o")

	argBootLoader := []string{"-march=rv32i", "-mabi=ilp32", bootPath, "-o", bootDest}
	argCompiler := []string{"-ffunction-sections", "-nostdlib", "-march=rv32i", "-mabi=ilp32", "-I", "/usr/include/", "-T", linkerPath, bootDest, srcPath, "-o", srcDest}

	// Assemble Bootloader
	execute("riscv64-unknown-elf-as", argBootLoader)
	// Compile and Link
	execute("riscv64-unknown-elf-gcc", argCompiler)
	return srcDest
}

func PrintElfInfos(path string) {
	argReadElf := []string{"-x", ".text", "-x", ".rodata", "-x", ".data", path}
	argObjDump := []string{"-M", "no-aliases", "-d", path}
	out := execute("riscv64-unknown-elf-readelf", argReadElf)
	fmt.Print(out)
	out = execute("riscv64-unknown-elf-objdump", argObjDump)
	fmt.Print(out)
}

func execute(command string, args []string) string {
	cmd := exec.Command(command, args...)
	var stderr bytes.Buffer
	var stdout bytes.Buffer
	cmd.Stderr = &stderr
	cmd.Stdout = &stdout
	err := cmd.Run()
	HandleError(err, stderr.String())
	return stdout.String()
}

func getDestination(path string, extention string) string {
	srcFile := filepath.Base(path)
	srcName := strings.Split(srcFile, ".")
	return filepath.Join("out", srcName[0]+"."+extention)
}

func createOutputDir() {

	_, err := os.Stat("out")
	if os.IsNotExist(err) {
		err = os.Mkdir("out", 0755)
		HandleError(err)
	} else {
		HandleError(err)
	}

}
