{
  flake,
  pkgs,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "age-hier-rust";
  version = "unstable";
  src = builtins.path { path = "${flake}/rust"; };
  cargoHash = "sha256-x5k/EDYEbAaM2l7VCWrwh1QYr5JGZ2UMJkxNLid9iZA=";
}
