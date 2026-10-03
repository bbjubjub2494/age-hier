pub mod slip10;

use bech32::{self, ToBase32};

/// Node represents the root node in the SLIP10-ed25519 key derivation tree.
/// ```
/// use age_hier::Node;
/// let mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about";
/// let passphrase = "super secret";
/// let n = Node::from_mnemonic(mnemonic, passphrase).unwrap();
/// assert_eq!(n.derive_private_key_bech32(&vec!(44, 753, 0,0,0), false),
/// "AGE-SECRET-KEY-1YJ337HA5T8RDD5F82EUNYDZYFZAD5NGDY4UXC4ZCPJYS694DKQCSASJ9D4");
/// assert_eq!(n.derive_private_key_bech32(&vec!(44, 753, 0,0,0), true),
/// "AGE-SECRET-KEY-14PQFXZXHY03LFQ32KVWP3ES5Y5E9UTS8JCP4LAXKP7P8UPY6JQHSAU7X0W");
/// assert_eq!(n.derive_private_key_bech32(&vec!(44, 753, 0,0,1), true),
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
    pub fn derive_private_key_bech32(&self, path: &[u32], legacy: bool) -> String {
        let curve = if legacy {
            slip10::Curve::Ed25519
        } else {
            slip10::Curve::Curve25519
        };
        let sk = slip10::derive_private_key(&self.bytes, curve, path).private_key;
        bech32::encode(
            "AGE-SECRET-KEY-",
            sk.as_slice().to_base32(),
            bech32::Variant::Bech32,
        )
        .unwrap() // failures here are not business logic
        .to_uppercase()
    }
}
