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
      description = "Make scripts autostart using .desktop files.";
    };
    autostartSymlinks = mkOption {
      default = { };
      type = with types; attrsOf path;
      description = "Make .desktop files autostart.";
    };
  };

  config = {
    hm.home.file =
      (listToAttrs (
        mapAttrsToList (name: script: {
          name = ".config/autostart/${name}.script.desktop";
          value.text = ''
            [Desktop Entry]
            Exec=${pkgs.writeShellScript name script}
            Name=${name}
            Type=Application
            X-KDE-AutostartScript=true
          '';
        }) config.opts.autostartScripts
      ))
      // (listToAttrs (
        mapAttrsToList (name: path: {
          name = ".config/autostart/${name}.symlink.desktop";
          value.source = funcs.mkOutOfStoreSymlink path;
        }) config.opts.autostartSymlinks
      ));
  };
}
