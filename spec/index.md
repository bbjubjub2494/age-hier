# Age Hierarchical Deterministic Key Derivation

This scheme allows deriving X25519 [Age] private keys from existing [BIP-0039] style mnemonic phrases.

[Age]: https://age-encryption.org
[BIP-0039]: https://en.bitcoin.it/wiki/BIP_0039

## Design

Given a mnemonic phrase conformant to [BIP-0039],
given a passphrase with may be the empty string and must not have leading or trailing whitespace,
a 512-bit seed must be derived according to [BIP-0039] §5.
A master key must then be derived from the seed according to [SLIP-0010] prescriptions for ed25519.
Then derivation must be performed along the path `m/44'/753'`.

Then, derivation should be performed down the path `0'/0'/0'` relative to the previously defined node.
The resulting node contains the first X25519 keypair.
If more keypairs are required, siblings of that key should be used, starting with `0'/0'/1'` and incrementing the index sequentially.
For more advanced usecases, one may use cousin nodes such as `m/44'/753'/i'/j'/k'` for arbitrary `i`, `j`, and `k`.

Once a leaf node is computed and selected,
the X25519 private key must be computed by reading the 256-bit private key of the leaf node.
It should be presented in Bech32 with the conventional `AGE-SECRET-KEY-` prefix.

[SLIP-0010]: https://github.com/satoshilabs/slips/blob/master/slip-0010.md
[SLIP-0044]: https://github.com/satoshilabs/slips/blob/master/slip-0044.md

## Rationale

The design presented uses long-tested hierarchical deterministic derivation constructions in a straightforward way.
In doing so, it leverages the hardness assumption for discrete logarithms in ed25519, which every Age deployment relies on.
This also provides domain separation, both from one Age key to another, and with regards to other keys that might be derived from the same seed.

In the Age specification,
[the X25519 recipient type] private key
must be generated from a cryptographically-secure pseudo-random number generator.
Here, the node private key is derived from secret entropy through `HMAC-SHA512`,
which is a pseudo-random function.
Hence, the security assumption of Age holds.

[the X25519 recipient type]: https://github.com/C2SP/C2SP/blob/main/age.md#the-x25519-recipient-type

## Test vectors

Test vectors can be found in the form of testscripts in the `testdata/` directory.
