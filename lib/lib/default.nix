lib: prev: with lib; {
  modulesIn =
    dir:
    pipe dir [
      builtins.readDir
      (mapAttrsToList (
        name: type:
        if type == "regular" && hasSuffix ".nix" name && name != "default.nix" then
          [
            {
              name = removeSuffix ".nix" name;
              value = dir + "/${name}";
            }
          ]
        else if type == "directory" && pathExists (dir + "/${name}/default.nix") then
          [
            {
              inherit name;
              value = dir + "/${name}";
            }
          ]
        else
          [ ]
      ))
      concatLists
      listToAttrs
    ];
  exprsIn = dir: mapAttrs (_: f: import f) (modulesIn dir);
  catAttrs' =
    key: set:
    listToAttrs (
      concatMap (
        name:
        let
          v = set.${name};
        in
        if v ? ${key} then [ (nameValuePair name v.${key}) ] else [ ]
      ) (attrNames set)
    );
  mkEnableModule = name: cfg: {
    options = setAttrByPath name { enable = mkEnableOption (last name); };
    imports = cfg.imports or [ ] ++ [
      (
        { config, ... }:
        {
          config = mkIf (getAttrFromPath name config).enable (removeAttrs cfg [ "imports" ]);
        }
      )
    ];
  };
}
