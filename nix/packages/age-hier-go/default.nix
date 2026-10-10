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

  vendorHash = "sha256-AfEQ9Gjm3Irg+iyGqY+BEe0093sGJXUjX0fvbrYJhBo=";
}
