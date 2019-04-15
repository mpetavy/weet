package main

import (
	"fmt"
	"log"
	"os/exec"
)

func scan() {
	out, err := exec.Command("d:\\gopath\\src\\github.com\\mpetavy\\weet\\client\\clscan.exe", "/SetScanner", "HP LJ M476 Scan Driver TWAIN", "/SetFilename", "d:\\gopath\\src\\github.com\\mpetavy\\weet\\client\\test.jpg").Output()
	//out, err := exec.Command("clscan.exe", os.Args[2:]...).Output()
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Output: %s\n", out)
}

func main() {
	scan()
}
