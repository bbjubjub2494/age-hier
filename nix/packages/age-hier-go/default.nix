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

  vendorHash = "sha256-5KC2OOplARNoq+NlqT/96ljCImYgGnhB9Io6mZ2m7eo=";
}
