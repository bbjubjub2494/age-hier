//! The necessary functions from https://github.com/satoshilabs/slips/blob/master/slip-0010.md

use hmac::{Hmac, KeyInit, Mac};
use sha2::{digest::FixedOutput, Sha512};

type HmacSha512 = Hmac<Sha512>;

const ED25519_CURVE_PARAM: &[u8] = b"ed25519 seed";
const CURVE25519_CURVE_PARAM: &[u8] = b"curve25519 seed";

/// The curves supported by SLIP-10.
#[derive(PartialEq, Eq, Debug, Clone, Copy)]
pub enum Curve {
    Ed25519,
    Curve25519,
}

#[derive(PartialEq, Eq, Debug, Clone, Copy)]
pub struct ExtendedPrivateKey {
    pub private_key: [u8; 32],
    pub chain_code: [u8; 32],
}

/// Perform key derivation for ed25519 or curve25519 according to SLIP-10.
/// ```
/// use age_hier::slip10::*;
/// use hex_literal::hex;
/// // Test Vector 1
/// let seed = hex!("000102030405060708090a0b0c0d0e0f");
/// assert_eq!(derive_private_key(&seed, Curve::Ed25519, &[]),
/// ExtendedPrivateKey{
/// private_key: hex!("2b4be7f19ee27bbf30c667b642d5f4aa69fd169872f8fc3059c08ebae2eb19e7"),
/// chain_code: hex!("90046a93de5380a72b5e45010748567d5ea02bbf6522f979e05c0d8d8ca9fffb"),
/// });
/// assert_eq!(derive_private_key(&seed, Curve::Ed25519, &[0]),
/// ExtendedPrivateKey{
/// private_key: hex!("68e0fe46dfb67e368c75379acec591dad19df3cde26e63b93a8e704f1dade7a3"),
/// chain_code: hex!("8b59aa11380b624e81507a27fedda59fea6d0b779a778918a2fd3590e16e9c69"),
/// });
/// assert_eq!(derive_private_key(&seed, Curve::Curve25519, &[]),
/// ExtendedPrivateKey{
/// private_key: hex!("d70a59c2e68b836cc4bbe8bcae425169b9e2384f3905091e3d60b890e90cd92c"),
/// chain_code: hex!("77997ca3588a1a34f3589279ea2962247abfe5277d52770a44c706378c710768"),
/// });
/// ```
pub fn derive_private_key(seed: &[u8], curve: Curve, path: &[u32]) -> ExtendedPrivateKey {
    let key = match curve {
        Curve::Ed25519 => ED25519_CURVE_PARAM,
        Curve::Curve25519 => CURVE25519_CURVE_PARAM,
    };
    let mut mac = HmacSha512::new_from_slice(key).unwrap();
    mac.update(seed);
    let mut buf = mac.finalize_fixed();
    for &i in path {
        let i_h = i | (1 << 31); // force hardened
        mac = HmacSha512::new_from_slice(&buf[32..]).unwrap();
        mac.update(&[0]);
        mac.update(&buf[..32]);
        mac.update(&i_h.to_be_bytes());
        mac.finalize_into(&mut buf);
    }
    ExtendedPrivateKey {
        private_key: buf[..32].try_into().unwrap(),
        chain_code: buf[32..].try_into().unwrap(),
    }
}
