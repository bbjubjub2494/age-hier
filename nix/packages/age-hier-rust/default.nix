{
  flake,
  pkgs,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "age-hier-rust";
  version = "unstable";
  src = builtins.path { path = "${flake}/rust"; };
  cargoHash = "sha256-gc4oRd2Jst7rav4VQGFk/BCWPQN203GP3cfrNDr4zX8=";
}
