{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
    ./modules/git.nix
    ./modules/shell.nix
    ./modules/terminal.nix
    ./modules/editors.nix
    ./modules/niri.nix
    ./modules/lockscreen.nix
    ./modules/devtools.nix
    ./modules/thunar.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home = {
    username = "epicus";
    homeDirectory = "/home/epicus";
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
    packages = with pkgs; [
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
      brave
      steam
      signal-desktop
      obsidian
      gemini-cli
      marksman
      nil
      nodePackages.vscode-langservers-extracted
      taplo
      alejandra
      grim
      slurp
      swappy
      # File managers
      xfce.thunar
      xfce.thunar-volman # Volume management
      xfce.tumbler # Thumbnails
      gvfs # Virtual filesystems (trash, network, etc)
      yazi # Terminal file manager
      imv

      # Icon themes (dark, modern, fits UNSC aesthetic)
      papirus-icon-theme # Clean, modern icons with breeze fallback included
      mpv
      zathura
      spotify
      pavucontrol
      xfce.thunar-archive-plugin
      file-roller
      discord
      networkmanagerapplet
      v4l-utils
    ];
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.05";
}
