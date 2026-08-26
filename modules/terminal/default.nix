{
  pkgs,
  funcs,
  inputs,
  config,
  lib,
  vars,
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
    nixb = "home-manager build -b backup --flake ${vars.homeDirectory}/work-nix-config";
    nixl = "home-manager generations";
    nixu = "nix flake update --flake ${vars.homeDirectory}/work-nix-config";
    nixd = "nix develop -c $SHELL";
    nixp = "nix-shell --run $SHELL -p";
    nixr = "nix repl --file ${pkgs.writeText "replinit.nix" ''
      let
        self = builtins.getFlake "config";
      in rec {
        inherit self;
        inherit (self) inputs lib;
        inherit (self.homeConfigurations) ${vars.username};
        inherit (self.homeConfigurations.${vars.username}) pkgs;
        inherit (self.homeConfigurations.${vars.username}._module.args) funcs;
        inherit (self.homeConfigurations.${vars.username}._module.specialArgs) vars;
      }
    ''}";
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    WINDOWS_USER = vars.windows-user;
  };
  home.shell.enableZshIntegration = true;

  programs = {
    zsh = {
      enable = true;
      dotDir = "${vars.homeDirectory}/.config/zsh";
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
        user.name = vars.git.name;
        user.email = vars.git.email;
        gpg.format = "ssh";
        commit.gpgsign = true;
        user.signingkey = "${vars.homeDirectory}/.ssh/id_ed25519.pub";
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
    # Customize colors for terminal commands like ls
    # See `dircolors --print-database` for options
    dircolors = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        OTHER_WRITABLE = "30;42";
        STICKY_OTHER_WRITABLE = "30;44";
      };
    };
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
    ".config/lazygit/config.yml".source = funcs.mkMutableConfigSymlink ./lazygit.yml;
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

    # C/C++ debugger
    gdb

    # JSON processor
    jq

    # Used by some work projects.
    # Includes the Python packages needed by the optestrunner merge scripts.
    # A higher version of python is installed elsewhere so conflicts exist for the 'python' binary.
    # Making this lower priority so 'python' uses the other version and to use this we run the 'python3.12' binary.
    (lib.meta.lowPrio (
      python312.withPackages (
        ps: with ps; [
          filelock
          jsonschema
          junitparser
          lxml
          numpy
          pandas
          psutil
          pytest
          pytest-xdist
        ]
      )
    ))

    (writeShellScriptBin "bazel" ''
      # Launcher for the bazel build tool.
      # Not installing bazel directly because very specific versions are required and this automatically gets the correct version.
      ${lib.getExe bazelisk} $@
    '')

    (pkgs.stdenvNoCC.mkDerivation rec {
      pname = "bazel-compile-commands";
      version = "0.22.4";
      src = pkgs.fetchzip {
        url = "https://github.com/kiron1/bazel-compile-commands/releases/download/bazel-compile-commands-v${version}/bazel-compile-commands_${version}-linux_amd64.zip";
        hash = "sha256-6vco3XN7g87IymbC3HQRB0IAVYAVDyHV/+VvKEpOR44=";
      };
      installPhase = ''
        mkdir -p $out/bin $out/share
        cp -r $src/bin/* $out/bin/
        cp -r $src/share/* $out/share/
        chmod +x $out/bin/*
      '';
      meta.mainProgram = "bazel-compile-commands";
    })

    # Required by openPASS/stochastics-library
    (lib.meta.lowPrio clang)

  ];
}
