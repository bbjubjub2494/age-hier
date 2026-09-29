{
  flake,
  pkgs,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "age-hier-rust";
  version = "unstable";
  src = builtins.path { path = "${flake}/rust"; };
  cargoHash = "sha256-TDXSV1VOO5U9FCTGhS94gVc8UnVSxdp1mrB7ewP0Npg=";
}
