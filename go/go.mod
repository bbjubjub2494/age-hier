module github.com/bbjubjub2494/age-hier/go

go 1.26.0

require (
	eagain.net/go/bech32 v0.0.1
	github.com/anyproto/go-slip10 v1.0.1
	github.com/spf13/pflag v1.0.10
	github.com/tyler-smith/go-bip39 v1.1.0
)

require golang.org/x/crypto v0.57.0 // indirect

replace github.com/anyproto/go-slip10 => github.com/bbjubjub2494/go-slip10 v0.0.0-20260928184756-427b592f82b5
