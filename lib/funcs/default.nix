{
  config,
  lib,
  funcs,
  pkgs,
  ...
}:
with lib;
{
  options.opts.funcs = mkOption {
    default = { };
    type = with types; attrsOf anything;
  };
  config = {
    _module.args.funcs = config.opts.funcs;
    opts.funcs = {
      mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
      relativeToAbsoluteConfigPath =
        path:
        ("${config.home.homeDirectory}/work-nix-config" + removePrefix (toString ./../..) (toString path));
      mkMutableConfigSymlink = path: funcs.mkOutOfStoreSymlink (funcs.relativeToAbsoluteConfigPath path);
      patchDesktop =
        pkg: appName: from: to:
        with pkgs;
        let
          zipped = lib.zipLists from to;
          sed-args = builtins.map ({ fst, snd }: "-e 's#${fst}#${snd}#g'") zipped;
          concat-args = builtins.concatStringsSep " " sed-args;
        in
        lib.hiPrio (
          pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
            ${coreutils}/bin/mkdir -p $out/share/applications
            ${gnused}/bin/sed ${concat-args} \
             ${pkg}/share/applications/${appName}.desktop \
             > $out/share/applications/${appName}.desktop
          ''
        );
    };
  };
}
