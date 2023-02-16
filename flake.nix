{
  description = "Description for the project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.go.url = "github:lourkeur/age-hier-go";
  inputs.go.flake = false;

  inputs.rust.url = "github:lourkeur/age-hier-rust";
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
      ];
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
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

        let implementations.age-hier-go = pkgs.buildGoModule {
          pname = "age-hier-go";
          version = "unstable";
          src = inputs.go;

          vendorHash = "sha256-agMM7GArpOukKsgOsmX7FQoUdfrFR/73IRCTGnjRlqc=";
        };

        implementations.age-hier-rust = pkgs.rustPlatform.buildRustPackage {
          pname = "age-hier-rust";
          version = "unstable";
          src = inputs.rust;
          cargoHash = "sha256-6ZfcKqcc8rfyuh+1VTjvOwGsRo17KLMbkirkImngs5A=";
        };
         in {
           packages = implementations;

        checks = builtins.mapAttrs (_: impl: pkgs.buildGoModule {
          name = "age-hier-go-check";
          src = self;

          vendorHash = "sha256-GDw5dPGPv7TGKWiEH2YjtQLKw/jel1V1JWjQAGjfWVw=";
          nativeCheckInputs = [ impl ];
        }) implementations;

        formatter = pkgs.alejandra;
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

        herculesCI.ciSystems = ["x86_64-linux" "aarch64-linux"];
      };
    };
}
