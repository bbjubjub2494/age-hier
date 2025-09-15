{ pkgs }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    go
    cargo

    # To update hashes in nix files
    nix-update

    # To compile curl under Rust
    openssl.dev
    pkg-config
  ];
}
