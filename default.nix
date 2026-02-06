args@{
  system ? builtins.currentSystem
, sources ? import ./nix/sources.nix
}:
let
  nixpkgs = import sources.nixpkgs {
    inherit system;
  };
in
import ./get.nix {
  inherit system;
  inherit nixpkgs;
  inherit (nixpkgs) lib;
}
