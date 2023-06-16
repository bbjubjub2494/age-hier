{
  description = "Description for the project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";

  inputs.go.url = "github:bbjubjub2494/age-hier-go";
  inputs.go.flake = false;

  inputs.rust.url = "github:bbjubjub2494/age-hier-rust";
  inputs.rust.flake = false;

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
          src = inputs.go;

          vendorHash = "sha256-hs8DG/czjV0Cj9NYpknvOSmYO0FYwzj1B12sI4C1g7w=";
        };

        implementations.age-hier-rust = pkgs.rustPlatform.buildRustPackage {
          pname = "age-hier-rust";
          version = "unstable";
          src = inputs.rust;
          cargoHash = "sha256-Jp7pnbQNcsg30TgU4u3Zy00E1YDmTrAQVBzYlTwkae4=";
        };
      in {
        packages = implementations;

        checks = builtins.mapAttrs (_: impl:
          pkgs.buildGoModule {
            name = "age-hier-go-check";
            src = self;

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
