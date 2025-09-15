{ flake, pkgs }:

pkgs.buildGoModule {
  name = "age-hier-integration";
  src = "${flake}/integration";

  vendorHash = "sha256-OEXvKQ/dBxhz6/pbQNDYIjBf3O0x36ZE3Se/FqEgYRg=";
  doCheck = false; # checks are run in nix/checks
}
