{
  pkgs,
  flake,
}:
pkgs.buildGoModule {
  name = "age-hier-integration";
  src = "${flake}/integration";

  vendorHash = "sha256-GDw5dPGPv7TGKWiEH2YjtQLKw/jel1V1JWjQAGjfWVw=";
  doCheck = false; # checks are run in nix/checks
}
