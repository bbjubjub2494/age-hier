use age_hier::Node;
use clap::{arg, command, value_parser};
use std::env;
use std::io::{self, Write};

fn main() -> Result<(), String> {
    let cmd = command!()
        .arg(
            arg!(-i --index [index] "index of private key to derive")
                .value_parser(value_parser!(u32))
                .default_value("0"),
        )
        .get_matches();
    let i = *cmd.get_one::<u32>("index").unwrap();
    if i >= 1 << 31 {
        return Err(format!("index out of range (maximum 2**31)"));
    }
    fn input(prompt: &str) -> Result<String, io::Error> {
        let mut stderr = io::stderr();
        let mut buffer = String::new();
        stderr.write(prompt.as_bytes())?;
        stderr.flush()?;
        io::stdin().read_line(&mut buffer)?;
        Ok(String::from(buffer.trim()))
    }
    let mnemonic = input("enter mnemonic: ").map_err(|e| format!("io error: {e}"))?;
    let passphrase = input("enter passphrase: ").map_err(|e| format!("io error: {e}"))?;
    let n = Node::from_mnemonic(&mnemonic, &passphrase)
        .map_err(|e| format!("invalid mnemonic: {e}"))?;
    println!("{}", n.derive_private_key_bech32(&vec! {44,753,0,0,i}));
    Ok(())
}
