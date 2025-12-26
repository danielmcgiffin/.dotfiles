{
  inputs,
  pkgs,
  ...
}: let
  # Extract Arduino IDE AppImage
  arduino-extracted = pkgs.appimageTools.extractType2 {
    pname = "arduino-ide";
    version = "2.3.6";
    src = pkgs.fetchurl {
      url = "https://github.com/arduino/arduino-ide/releases/download/2.3.6/arduino-ide_2.3.6_Linux_64bit.AppImage";
      hash = "sha256-3Zx6XRhkvAt1Erv13wF3p3lm3guRDYreh+ATBzoO6pk=";
    };
  };

  # Run extracted Arduino IDE directly (nix-ld provides libraries)
  arduino-ide-wayland = pkgs.writeShellScriptBin "arduino-ide" ''
    export NIXOS_OZONE_WL=1
    exec ${arduino-extracted}/arduino-ide --ozone-platform=x11 "$@"
  '';
in {
  # Base configuration for all kids
  imports = [
    ../base.nix
    ../../modules/git.nix
    ../../modules/editors.nix
    ../../modules/devtools.nix
  ];

  home.packages = with pkgs; [
    # Browser
    brave

    # Development tools & language servers
    nodejs
    nodePackages.vscode-langservers-extracted
    marksman
    nil
    taplo
    alejandra

    # Screenshot tools
    grim
    slurp
    swappy

    # Terminal emulator
    inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Reading & learning
    calibre

    # Hardware development
    arduino-ide-wayland
  ];
}
