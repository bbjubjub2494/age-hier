use bech32::{self, ToBase32};
use bip39;
use slip10_ed25519;

/// Node represents the root node in the SLIP10-ed25519 key derivation tree.
/// ```
/// use age_hier::Node;
/// let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about";
/// let passphrase = "super secret";
/// let n = Node::from_mnemonic(mnemonic, passphrase).unwrap();
/// assert_eq!(n.derive_private_key_bech32(&vec!(44, 753, 0,0,0)),
/// "AGE-SECRET-KEY-14PQFXZXHY03LFQ32KVWP3ES5Y5E9UTS8JCP4LAXKP7P8UPY6JQHSAU7X0W");
/// assert_eq!(n.derive_private_key_bech32(&vec!(44, 753, 0,0,1)),
/// "AGE-SECRET-KEY-14GTF3J6MJTHCQ3DJRA3E6GYNRRH6LJ9L5ZA0Q6ZY67GJAX90Y6JQ3WP33C");
/// ```
pub struct Node {
    bytes: [u8; 64],
}

impl Node {
    pub fn from_mnemonic(mnemonic: &str, passphrase: &str) -> Result<Node, bip39::Error> {
        Ok(Node {
            bytes: bip39::Mnemonic::parse(mnemonic)?.to_seed(passphrase),
        })
    }
    pub fn derive_private_key_bech32(&self, path: &[u32]) -> String {
        let sk = slip10_ed25519::derive_ed25519_private_key(&self.bytes, path);
        bech32::encode(
            "AGE-SECRET-KEY-",
            sk.as_slice().to_base32(),
            bech32::Variant::Bech32,
        )
        .unwrap() // failures here are not business logic
        .to_uppercase()
    }
}
