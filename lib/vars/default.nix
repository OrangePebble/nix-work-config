_:
let
  default = {
    username = "pedro";
  };
  secrets = import ./secrets.nix default;
in
default // secrets
