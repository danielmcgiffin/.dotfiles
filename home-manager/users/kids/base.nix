{
  inputs,
  pkgs,
  ...
}: {
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
  ];
}
