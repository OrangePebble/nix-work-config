{ inputs, vars, ... }:
{
  home = {
    username = vars.username;
    homeDirectory = "/home/${vars.username}";
    stateVersion = "26.05"; # Please research before changing.
  };
  programs = {
    home-manager.enable = true; # Let Home Manager install and manage itself.
  };
  nix = {
    registry.config.flake = inputs.self;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
