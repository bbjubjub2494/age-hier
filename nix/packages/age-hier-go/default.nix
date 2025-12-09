{
  flake,
  pkgs,
}:
let
  src = builtins.path {
    path = "${flake}/go";
    # workaround: a source called go is confused with GOPATH
    name = "src";
  };
in
pkgs.buildGoModule rec {
  pname = "age-hier-go";
  version = "unstable";

  inherit src;

  vendorHash = "sha256-6Z3c9tgghdQXqUxtPg9b2xzQoHsU5khHz1nC1MI4m0Y=";
}
