{ pkgs ? import <nixpkgs> {
    config.permittedInsecurePackages = [
      "python3.12-ecdsa-0.19.1"
    ];
  }
}:
pkgs.mkShell {
  packages = [ pkgs.renpy ];
}
