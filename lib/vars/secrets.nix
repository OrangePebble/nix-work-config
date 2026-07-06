# As this is my work config I shouldn't commit some things and I don't feel like setting up sops.
# WARN: Either be careful to not commit this file or add it to .gitignore
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
    rclone = {
      url = "";
      password = "";
    };
  };
in
assert allNonEmpty secret-vars;
secret-vars
