# As this is my work config I shouldn't commit some things and I don't feel like setting up sops.
# This file has been added to '.gitignore' so to ignore new changes run:
#  `git update-index --assume-unchanged lib/vars/secrets.nix`
# And if you need to change it later run:
#  `git update-index --no-assume-unchanged lib/vars/secrets.nix`
vars:
let
  allNonEmpty =
    attrs:
    builtins.all (
      v:
      if builtins.isAttrs v then
        allNonEmpty v
      else if builtins.isString v then
        v != ""
      else
        true
    ) (builtins.attrValues attrs);

  secret-vars = {
    windows-user = "";
    git = {
      name = "";
      email = "";
    };
  };
in
assert allNonEmpty secret-vars;
secret-vars
