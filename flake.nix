{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-index-database.url = "github:nix-community/nix-index-database";
  };
  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      lib = (nixpkgs.lib.extend (_: _: home-manager.lib)).extend (import ./lib/lib);
    in
    {
      inherit lib;
      homeConfigurations.pedro = home-manager.lib.homeManagerConfiguration {
        inherit lib;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = (lib.attrValues (lib.modulesIn ./modules)) ++ [
          ./lib/funcs
          ./lib/opts
        ];
      };
    };
}
