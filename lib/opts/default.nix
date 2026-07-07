{
  config,
  lib,
  pkgs,
  funcs,
  ...
}:
with lib;
{
  options.opts = {
    autostartScripts = mkOption {
      default = { };
      type = with types; attrsOf str;
      description = "Make scripts autostart using systemd.";
    };
  };

  config = {
    systemd.user.services = (
      listToAttrs (
        mapAttrsToList (name: script: {
          inherit name;
          value = {
            Service = {
              ExecStart = "${pkgs.writeShellScript name script}";
              RemainAfterExit = "yes";
              Type = "oneshot";
            };
            Install.WantedBy = [ "basic.target" ];
          };
        }) config.opts.autostartScripts
      )
    );
  };
}
