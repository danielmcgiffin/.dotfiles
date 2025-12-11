{
  inputs,
  pkgs,
  ...
}: {
  # Common configuration shared by all users

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    # Basic packages everyone gets
    packages = with pkgs; [
      # File managers
      xfce.thunar
      xfce.thunar-volman
      xfce.tumbler
      gvfs
      yazi

      # Basic utilities
      imv
      mpv
      zathura
      pavucontrol
      xfce.thunar-archive-plugin
      file-roller
      networkmanagerapplet

      # Icon theme
      papirus-icon-theme
    ];
  };

  # Common modules all users need
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
    ../modules/shell.nix
    ../modules/terminal.nix
    ../modules/niri.nix
    ../modules/lockscreen.nix
    ../modules/thunar.nix
  ];

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
