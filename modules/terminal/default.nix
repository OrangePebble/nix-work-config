{
  pkgs,
  funcs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./neovim
    inputs.nix-index-database.homeModules.default
  ];

  home.shellAliases = {
    lg = "lazygit";
    gitr = "git reset --soft HEAD~1";
    nixs = toString (funcs.mkMutableConfigSymlink ./nixs.sh);
    nixb = "home-manager build -b backup --flake ${config.home.homeDirectory}/work-nix-config";
    nixl = "home-manager generations";
    nixu = "nix flake update --flake ${config.home.homeDirectory}/work-nix-config";
    nixd = "nix develop -c $SHELL";
    nixp = "nix-shell --run $SHELL -p";
    nixr = "nix repl --file ${pkgs.writeText "replinit.nix" ''
      let
        self = builtins.getFlake "config";
      in rec {
        inherit self;
        inherit (self) inputs lib;
        inherit (self.homeConfigurations) ${config.home.username};
        inherit (self.homeConfigurations.${config.home.username}) pkgs;
        inherit (self.homeConfigurations.${config.home.username}._module.args) funcs;
      }
    ''}";
  };

  programs = {
    zsh = {
      enable = true;
      dotDir = "${config.home.homeDirectory}/.config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh.enable = true;
      initContent = ''
        source "${funcs.mkMutableConfigSymlink ./prompt.zsh}"
        ZSH_VI_MODE_PLUGIN_FILE="${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
        source "${funcs.mkMutableConfigSymlink ./.zshrc}"
      '';
    };
    bash.enable = true;
    git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        credential.helper = [
          "cache --timeout 2629800"
          "oauth"
        ];
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta = {
          navigate = "true";
          dark = "true";
          line-numbers = "true";
          hyperlinks = "true";
        };
        merge.conflictStyle = "zdiff3";
      };
      lfs.enable = true;
    };
    zoxide.enable = true;
    nix-index-database.comma.enable = true;
    nix-index.enable = true;
  };

  home.file = {
    ".config/tmux/tmux.conf".source = funcs.mkMutableConfigSymlink ./tmux/tmux.conf;
    ".config/tmux/plugins/tpm".source = funcs.mkOutOfStoreSymlink (
      pkgs.fetchFromGitHub {
        owner = "tmux-plugins";
        repo = "tpm";
        rev = "master";
        hash = "sha256-oRKUZNyJYQXlkeQfbEYiltUEBpvdwn2SoEBWHVUNmrA=";
      }
    );
    ".config/tmux/plugins/tmux-which-key/config.yaml".source =
      funcs.mkMutableConfigSymlink ./tmux/which-key.yaml;
    ".config/tmux/scripts".source = funcs.mkMutableConfigSymlink ./tmux/scripts;
    ".config/opencode/opencode.jsonc".source = funcs.mkMutableConfigSymlink ./opencode.jsonc;
  };

  home.packages = with pkgs; [
    # Not using the program option so I can use my config files.
    tmux

    # Tool to remove large files from git history. Call with "bfg".
    bfg-repo-cleaner

    # TUI for git.
    lazygit

    # App to give quick examples of how to use most commands.
    tldr

    # Nix formatter.
    nixfmt
    # Formatter multiplexer
    treefmt
    # Nix package version diff tool.
    nvd

    # find replacement, used to update fetchgit references together with update-nix-fetchgit in nixr.
    fd
    update-nix-fetchgit

    # Library with a bunch of terminal inputs and outputs.
    gum

    # Tool to see file changes in real time.
    fswatch

    # Syntax highlighting pager.
    delta

    # 'cat' replacement with syntax highlighting.
    bat

    # Calculator used by my zsh prompt to calculate run times.
    bc

    # Adds the `git credential-oauth` command to authenticate to Forejo (and others) using OAuth.
    git-credential-oauth

    # AI coding agent with plugins for Neovim integration.
    opencode

    (writeShellScriptBin "bazel" ''
      # Launcher for the bazel build tool.
      # Not installing bazel directly because very specific versions are required and this automatically gets the correct version.
      ${lib.getExe bazelisk} $@
    '')
  ];
}
