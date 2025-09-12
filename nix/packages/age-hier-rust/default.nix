{
  flake,
  inputs,
  pkgs,
}: let
  src = builtins.path {path = "${flake}/rust";};

  cargoNix = inputs.crate2nix.tools.${pkgs.system}.appliedCargoNix {
    name = "age-hier-rust";
    inherit src;
  };
in
  cargoNix.rootCrate.build.override {runTests = true;}
