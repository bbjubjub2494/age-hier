{
  flake,
  pkgs,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "age-hier-rust";
  version = "unstable";
  src = builtins.path { path = "${flake}/rust"; };
  cargoHash = "sha256-VDU2LUNlpTaRzgzxXqH/zuKAl0UwWPD3slp7E9FLvyQ=";
}
