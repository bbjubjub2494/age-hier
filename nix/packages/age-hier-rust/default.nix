{
  flake,
  pkgs,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "age-hier-rust";
  version = "unstable";
  src = builtins.path { path = "${flake}/rust"; };
  cargoHash = "sha256-Q3jQcFx2AOWecmjfaqq80iiAQN8O/3NjiwM3sD6I7JE=";
}
