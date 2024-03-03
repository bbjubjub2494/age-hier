{
  description = "Description for the project";

  inputs.crate2nix.url = "github:nix-community/crate2nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";

  nixConfig.extra-substituters = "https://age-hier.cachix.org";
  nixConfig.extra-trusted-public-keys = "age-hier.cachix.org-1:8l0mOCbUxA1HGRXpYfphkNnmchO77eD4UQjef+wfPsM=";

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
        inputs.hercules-ci-effects.flakeModule
      ];
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      herculesCI.ciSystems = ["x86_64-linux" "aarch64-linux"];

      hercules-ci.flake-update.enable = true;
      hercules-ci.flake-update.when.dayOfWeek = "Sat";

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }:
      # Per-system attributes can be defined here. The self' and inputs'
      # module parameters provide easy access to attributes of the same
      # system.
      let
        implementations.age-hier-go = pkgs.buildGoModule {
          pname = "age-hier-go";
          version = "unstable";
          src = builtins.path {
            path = ./go;
            # workaround: a source called go is confused with GOPATH
            name = "src";
          };

          vendorHash = "sha256-RYkc6z/GmW9EY2077xyxJzcDQt0SUlmjfc5pLUUsz4M=";
        };
        cargoNix = inputs.crate2nix.tools.${pkgs.system}.appliedCargoNix {
          name = "age-hier-rust";
          src = ./rust;
        };
        implementations.age-hier-rust = cargoNix.rootCrate.build.override {runTests = true;};
      in {
        packages = implementations;

        checks = builtins.mapAttrs (_: impl:
          pkgs.buildGoModule {
            name = "${impl.name}-check";
            src = ./integration;

            vendorHash = "sha256-GDw5dPGPv7TGKWiEH2YjtQLKw/jel1V1JWjQAGjfWVw=";
            nativeCheckInputs = [impl];
          })
        implementations;

        formatter = pkgs.alejandra;
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
