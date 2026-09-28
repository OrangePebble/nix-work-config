{
  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pi = {
      url = "github:lukasl-dev/pi.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      vars = import ./lib/vars inputs;
      system = "x86_64-linux";
      lib = (nixpkgs.lib.extend (_: _: home-manager.lib)).extend (import ./lib/lib);
    in
    {
      inherit lib;
      homeConfigurations."${vars.username}" = home-manager.lib.homeManagerConfiguration {
        inherit lib;
        pkgs = nixpkgs.legacyPackages.${system};
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
