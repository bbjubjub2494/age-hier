{
  flake,
  system,
  ...
}:
with flake.packages.${system};
  internal-integration.overrideAttrs (_: {
    nativeCheckInputs = [age-hier-go];

    doCheck = true;
  })
