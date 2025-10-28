# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

let
  mkOOS = config.lib.file.mkOutOfStoreSymlink;
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    outputs.homeManagerModules.niri

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  xdg.configFile."niri/config.kdl".source =
    mkOOS "/home/epicus/.dotfiles/niri/config.kdl";

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "epicus";
    homeDirectory = "/home/epicus";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    quickshell
    qt6Packages.qt5compat
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      command_timeout = 1000;
      palette = "tokyo-night";

      format = "$username$hostname$directory$git_branch$git_status$cmd_duration$fill$line_break$character";

      right_format = "$time";

      character = {
        success_symbol = "[>](fg:accent) ";
        error_symbol = "[x](fg:warn) ";
        vicmd_symbol = "[<](fg:info) ";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = false;
        style = "fg:accent bold";
        format = "[ $path ]($style)";
      };

      git_branch = {
        format = "[ git:$branch ](fg:info)";
        only_attached = true;
      };

      git_status = {
        style = "fg:warn";
        format = " [$all_status$ahead_behind]($style)";
        conflicted = "!";
        ahead = "^";
        behind = "v";
        diverged = "<>";
        staged = "+";
        modified = "~";
        deleted = "x";
        stashed = "$";
        untracked = "?";
        renamed = ">";
      };

      cmd_duration = {
        min_time = 750;
        format = " [took $duration](fg:warn)";
      };

      time = {
        disabled = false;
        format = "[ $time ](fg:muted)";
      };

      hostname = {
        ssh_only = true;
        format = "[ @$hostname ](fg:muted)";
      };

      username = {
        show_always = false;
        style_user = "fg:muted";
        format = "[ $user ]($style_user)";
      };

      palettes."tokyo-night" = {
        accent = "#7aa2f7";
        info = "#9ece6a";
        warn = "#f7768e";
        muted = "#565f89";
        text = "#c0caf5";
      };
    };
  };
  programs.nushell = {
    enable = true;
    configFile.source = ./files/nushell/config.nu;
  };

  profiles.niri.enable = true;

  xdg.configFile."walker/config.toml".source = ./files/walker/config.toml;
  xdg.configFile."quickshell/shell.qml".source = ./files/quickshell/shell.qml;
  home.file."Pictures/wallpapers/steel-battleship.jpg".source = ./files/wallpapers/steel_battleship.jpg;

  home.sessionVariablesExtra = ''
    export QML2_IMPORT_PATH=${pkgs.qt6Packages.qt5compat}/lib/qt-6/qml''${QML2_IMPORT_PATH:+:$QML2_IMPORT_PATH}
    export QML_IMPORT_PATH=${pkgs.qt6Packages.qt5compat}/lib/qt-6/qml''${QML_IMPORT_PATH:+:$QML_IMPORT_PATH}
  '';

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
