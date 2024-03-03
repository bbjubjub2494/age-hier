package impl

import (
	"log"

	slip10 "github.com/anytypeio/go-slip10"
	bip39 "github.com/tyler-smith/go-bip39"
	"eagain.net/go/bech32"
)

// Node represents a node in the SLIP10-ed25519 key derivation tree.
type Node interface {
	// Derive computes the i-th child node of the current node under hardened derivation.
	Derive(i uint32) Node
	// PrivateKey returns the raw private key of the current node.
	PrivateKey() []byte
	// EncodedPrivateKey returns the Age-conformant bech32-encoded form of the private key of the current node.
	EncodedPrivateKey() string
}

type nodeImpl struct {
	slip10.Node
}

func FromMnemonic(mnemonic string, passphrase string) (Node, error) {
	seed, err := bip39.NewSeedWithErrorChecking(mnemonic, passphrase)
	if err != nil {
		return nil, err
	}
	n, err := slip10.NewMasterNode(seed)
	if err != nil {
		// NewMasterNode only errors if
		// - hmac errors which is not business logic relevant
		log.Panic(err)
	}
	return &nodeImpl{n}, nil
}

func (self *nodeImpl) Derive(i uint32) Node {
	n, err := self.Node.Derive(i | slip10.FirstHardenedIndex)
	if err != nil {
		// Derive only errors if
		// - public derivation is requested which is unreachable
		// - hmac errors which is not business logic relevant
		log.Panic(err)
	}
	return &nodeImpl{n}
}

func (self *nodeImpl) EncodedPrivateKey() string {
	enc, err := bech32.Encode("AGE-SECRET-KEY-", self.PrivateKey())
	if err != nil {
		// Encode only errors if
		// - bad lengths are requested which is unreachable
		// - mixed case HRP is passed which is unreachable
		log.Panic(err)
	}
	return enc
}
