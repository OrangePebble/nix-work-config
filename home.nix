{ config, pkgs, ... }:
{
  home.username = "pedro";
  home.homeDirectory = "/home/pedro";
  home.stateVersion = "26.05"; # Please research before changing.
  programs.home-manager.enable = true; # Let Home Manager install and manage itself.
  programs.bash.enable = true;
  programs.zsh.enable = true;
  home.packages = [
    pkgs.hello
  ];
}
