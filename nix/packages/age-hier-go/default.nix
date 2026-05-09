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

  vendorHash = "sha256-eeIwfhPSUC/ic0zJd3mCZ4HdvysJNS32g8GG3oqI/wA=";
}
