{ inputs, vars, ... }:
{
  home = {
    username = vars.username;
    homeDirectory = vars.homeDirectory;
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
  systemd.user.tmpfiles.rules = [
    "d /tmp/E2E-Highway-Artifacts/tools/env_simulator/ExampleData - - - - -"
    "d /tmp/E2EOpTestArtifacts - - - - -"
    "L /tmp/E2E-Highway-Artifacts/tools/env_simulator/ExampleData/E2EOpTestArtifacts - - - - /tmp/E2EOpTestArtifacts"
  ];

}
