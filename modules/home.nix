{ ... }:
{
  home = {
    username = "pedro";
    homeDirectory = "/home/pedro";
    stateVersion = "26.05"; # Please research before changing.
  };
  programs = {
    home-manager.enable = true; # Let Home Manager install and manage itself.
  };
}
