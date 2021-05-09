/*
 * A helper module which does the ELF parsing.
 *
 * Author: Guillaume Fournier-Mayer (tinf101922)
 * Date: 09.05.2021
 */

package main

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

/*
 * Builds the program using the passed files and the predefined compiler
 * and returns the path of the ELF file.
 *
 * @param srcPath The path to the source file
 * @param bootPath The path to the bootloader
 * @param linkerPath The path to the linkersrcipt
 * @returns srcDest The path of the created ELF
 */
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

/*
 * Outputs info about an ELF.
 *
 * @param srcPath The path to the ELF
 */
func PrintElfInfos(path string) {
	argReadElf := []string{"-x", ".text", "-x", ".rodata", "-x", ".data", "-x", ".bss", path}
	argObjDump := []string{"-M", "no-aliases", "-d", path}
	out := execute("riscv64-unknown-elf-readelf", argReadElf)
	fmt.Print(out)
	out = execute("riscv64-unknown-elf-objdump", argObjDump)
	fmt.Print(out)
}

/*
 * Help routine that executes command line calls. Return stdout after
 * the call is finished.
 *
 * @param command The command to be executed
 * @param args The arguments with which the command should be called
 * @returns stdout
 */
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

/*
 * Assembles a path from the file and the extension
 *
 * @param path The basepath
 * @param extention The extention
 * @returns The assembled path
 */
func getDestination(path string, extention string) string {
	srcFile := filepath.Base(path)
	srcName := strings.Split(srcFile, ".")
	return filepath.Join("out", srcName[0]+"."+extention)
}

/*
 * Creates the output directory
 */
func createOutputDir() {
	_, err := os.Stat("out")
	if os.IsNotExist(err) {
		err = os.Mkdir("out", 0755)
		HandleError(err)
	} else {
		HandleError(err)
	}

}
