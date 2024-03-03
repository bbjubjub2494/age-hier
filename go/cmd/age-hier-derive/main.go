package main

import (
	"bufio"
	flag "github.com/spf13/pflag"
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/bbjubjub2494/age-hier-go/impl"
)

func main() {
	var i uint
	flag.UintVarP(&i, "index", "i", 0, "index of private key to derive")
	flag.Parse()

	if flag.NArg() > 0 {
		flag.Usage()
		os.Exit(2)
	}

	if i >= 1<<31 {
		log.Fatalln("index out of range (maximum 2**31)")
	}

	var path = []uint32{44, 753, 0, 0, uint32(i)}

	stdinbuf := bufio.NewReader(os.Stdin)
	input := func(prompt string) string {
		os.Stderr.WriteString(prompt)
		line, err := stdinbuf.ReadString('\n')
		if err != nil {
			log.Fatal("error reading", err)
		}
		return strings.TrimSpace(line)
	}

	mnemonic := input("enter mnemonic: ")
	passphrase := input("enter passphrase: ")

	n, err := impl.FromMnemonic(mnemonic, passphrase)
	if err != nil {
		log.Fatalln("invalid mnemonic:", err)
	}

	for _, d := range path {
		n = n.Derive(d)
	}

	enc_sk := n.EncodedPrivateKey()
	fmt.Println(enc_sk)
}
