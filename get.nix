args@{
  system ? builtins.currentSystem
, lib
, nixpkgs
, bootghc ? "ghc912"
, useClang ? true
}:
let
  stdenv =
    if useClang then
      nixpkgs.clangdStdenv
    else
      nixpkgs.stdenv;

  hspkgs = nixpkgs.haskell.packages.${bootghc};

  buildHaskell = {
    name
  , version
  , depends ? _: []
  , isShell ? false
  , withIde ? true
  }:
  let
    depsSystem = [
      nixpkgs.file
      nixpkgs.git
      nixpkgs.less
      nixpkgs.which
      nixpkgs.python3
    ]
    ++ lib.optional withIde hspkgs.haskell-language-server
    ++ lib.optional withIde nixpkgs.clang-tools;

    depsTools = [
      hspkgs.cabal-install
    ];

    hsdrv = hspkgs.mkDerivation {
      inherit version;
      pname = name;
      libraryHaskellDepends = depends hspkgs;
      librarySystemDepends = depsSystem;
    };

    hsshell = hspkgs.shellFor {
      packages = _: [ hsdrv ];
      buildInputs = depsSystem;
      nativeBuildInputs = depsTools;

      passthru = {
        inherit hspkgs;
        inherit nixpkgs;
      };
    };
  in
  if isShell then hsshell else hsdrv;
in
{
  inherit lib nixpkgs;
  inherit hspkgs buildHaskell;
}
