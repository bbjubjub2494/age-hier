{ flake, pkgs }:

pkgs.buildGoModule {
  pname = "age-hier-integration";
  version = "unstable";
  src = "${flake}/integration";

  vendorHash = "sha256-OEXvKQ/dBxhz6/pbQNDYIjBf3O0x36ZE3Se/FqEgYRg=";
  doCheck = false; # checks are run in nix/checks
}
