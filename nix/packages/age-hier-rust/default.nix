{
  flake,
  pkgs,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "age-hier-rust";
  version = "unstable";
  src = builtins.path { path = "${flake}/rust"; };
  cargoHash = "sha256-V+qkj3Vrpxb6D+GeOhEntTJVGJI+Zs2u8E9Anz4Jl44=";
}
