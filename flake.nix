{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
  };

  outputs = inputs@{
    self
  , nixpkgs
  }:
  let
    systems = [
      "x86_64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
  {
    getnix = forAllSystems (system: import ./get.nix {
      inherit system;
      inherit (nixpkgs) lib;
      nixpkgs = nixpkgs.legacyPackages.${system};
    });
  };
}
