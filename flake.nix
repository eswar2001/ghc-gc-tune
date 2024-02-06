{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    # `nixpkgs`, `haskell-flake` and `flake-parts` will be shared between all the euler repos.
    nixpkgs.url = "github:nixos/nixpkgs/43e3b6af08f29c4447a6073e3d5b86a4f45dd420";
    # This will be used for fetching latest utils like cachix
    # and other packages added to the docker image.
    # (Cachix from nixpkgs above expects a different config schema)
    nixpkgs-latest.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;
      imports = [inputs.haskell-flake.flakeModule];

      perSystem = {
        self',
        pkgs,
        lib,
        config,
        ...
      }: {
        haskellProjects.default = {
          basePackages = pkgs.haskell.packages.ghc8107;
          packages = {
          };
          settings = {
          };
        };
        packages.default = self.ghc-gc-tune;
      };
    };
}
