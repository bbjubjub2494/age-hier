{
  flake,
  pkgs,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "age-hier-rust";
  version = "unstable";
  src = builtins.path { path = "${flake}/rust"; };
  cargoHash = "sha256-XLqbPw5+5DZOoAU9zhWWYpBlVLLb2dsitVDAIrFCtVI=";
}
