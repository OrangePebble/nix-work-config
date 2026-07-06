{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-index-database.url = "github:nix-community/nix-index-database";
  };
  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      vars = import ./lib/vars inputs;
      lib = (nixpkgs.lib.extend (_: _: home-manager.lib)).extend (import ./lib/lib);
    in
    {
      inherit lib;
      homeConfigurations."${vars.username}" = home-manager.lib.homeManagerConfiguration {
        inherit lib;
        pkgs = nixpkgs.legacyPackages."${vars.hostPlatform}";
        extraSpecialArgs = {
          inherit inputs;
          inherit vars;
        };
        modules = (lib.attrValues (lib.modulesIn ./modules)) ++ [
          ./lib/funcs
          ./lib/opts
        ];
      };
    };
}
