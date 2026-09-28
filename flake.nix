{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = "https://age-hier.cachix.org";
    extra-trusted-public-keys = "age-hier.cachix.org-1:8l0mOCbUxA1HGRXpYfphkNnmchO77eD4UQjef+wfPsM=";
  };

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      prefix = "nix";
    };
}
