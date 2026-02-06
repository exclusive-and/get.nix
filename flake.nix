{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
  };

  outputs = inputs@{
    self
  , nixpkgs
  }:
  let
    inherit (nixpkgs) lib;

    systems = [
      "x86_64-linux"
    ];

    forAllSystems = lib.genAttrs systems;
  in
  {
    inherit lib;

    getnix = forAllSystems (system: import ./get.nix {
      inherit system;
      inherit lib;
      nixpkgs = nixpkgs.legacyPackages.${system};
    });
  };
}
