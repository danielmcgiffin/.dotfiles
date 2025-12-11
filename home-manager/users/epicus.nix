{
  inputs,
  pkgs,
  ...
}: {
  # Admin user configuration (epicus)
  imports = [
    ./base.nix
    ../modules/git.nix
    ../modules/editors.nix
    ../modules/devtools.nix
  ];

  home = {
    username = "epicus";
    homeDirectory = "/home/epicus";

    packages = with pkgs; [
      # Terminal emulator
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Browsers
      brave

      # Gaming
      steam

      # Communication
      signal-desktop
      discord

      # Productivity
      obsidian

      # Development tools & language servers
      marksman
      nil
      nodejs
      nodePackages.vscode-langservers-extracted
      taplo
      alejandra

      # Screenshot tools
      grim
      slurp
      swappy

      # Media
      spotify
      qbittorrent

      # Utilities
      v4l-utils

      # Ebook management
      calibre

      # Screen recording & streaming (commented out in original)
      # obs-studio

      # Remote desktop (commented out in original)
      # rustdesk
    ];
  };
}
