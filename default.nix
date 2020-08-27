{ config ? { /*allowBroken = true;*/ }, ... }:
let
  elsewhere = import ../ref..liquidhaskell { inherit config; };
  nixpkgs = elsewhere.nixpkgs;
  haskellPackages = elsewhere.haskellPackages.override (
    old: {
      overrides = self: super: with nixpkgs.haskell.lib;
        (old.overrides self super) // {
          doctest = self.callHackage "doctest" "0.16.3" {};
        };
    }
  );

  # function to make sure a haskell package has z3 at build-time and test-time
  usingZ3 = pkg: nixpkgs.haskell.lib.overrideCabal pkg (old: { buildTools = old.buildTools or [] ++ [ nixpkgs.z3 ]; });
  # function to manually run doctest in the nix-build environment
  usingDoctest = pkg: nixpkgs.haskell.lib.overrideCabal pkg (old: { preCheck = "${nixpkgs.python3}/bin/python gen-ghc-env.py base"; });
  # function to bring devtools in to a package environment; ghc and hpack are automatically included
  usingDevtools = pkg: pkg.overrideAttrs (old: { nativeBuildInputs = old.nativeBuildInputs ++ [ nixpkgs.cabal-install nixpkgs.ghcid ]; });

  # ignore files specified by gitignore in nix-build
  source = nixpkgs.nix-gitignore.gitignoreSource [] ./.;
  # use overridden-haskellPackages to call gitignored-source
  drv =
    usingDoctest (
      usingZ3 (
        nixpkgs.haskell.lib.overrideCabal
          (haskellPackages.callCabal2nix "kosmikus-lh-tut" source {})
          (old: { doCheck = true; doHaddock = false; })
      )
    );
in
if nixpkgs.lib.inNixShell then usingDevtools drv.env else drv
