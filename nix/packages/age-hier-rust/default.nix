{
  flake,
  pkgs,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "age-hier-rust";
  version = "unstable";
  src = builtins.path { path = "${flake}/rust"; };
  cargoHash = "sha256-5If3Ikw+w6iIKJj1hv2bACkZ5s6rwGCXmSqyDcbjGIA=";
}
