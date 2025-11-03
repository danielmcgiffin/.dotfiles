{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    niri.useUnstable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use niri-unstable package instead of stable";
    };
  };

  config = {
    programs.niri = {
      enable = true;
      package = lib.mkIf config.niri.useUnstable
        inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
    };
  };
}
