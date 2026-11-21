{
  flake,
  pkgs,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "age-hier-rust";
  version = "unstable";
  src = builtins.path { path = "${flake}/rust"; };
  cargoHash = "sha256-LxgNitHZate19kiUaJo7M5zKgp7ZU/mu6hQehUBs+GY=";
}
