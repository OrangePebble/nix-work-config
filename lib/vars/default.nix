inputs:
let
  # Setting this in 'let in' so the values can be used easier in imports.
  default = rec {
    username = "pedro";
    homeDirectory = "/home/pedro";
    configDirectory = "${homeDirectory}/work-nix-config";
    hostPlatform = "x86_64-linux";
  };
  secrets = import ./secrets.nix default;
in
default // secrets
