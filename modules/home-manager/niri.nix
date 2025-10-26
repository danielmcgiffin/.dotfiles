{ lib, pkgs, config, ... }:
let
  cfg = config.profiles.niri;

  mkConfigFile =
    if cfg.configSource != null then {
      source = cfg.configSource;
    } else {
      text = cfg.configText;
    };
in {
  options.profiles.niri = {
    enable = lib.mkEnableOption "Manage Niri user configuration via Home Manager.";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.niri;
      description = "Niri package to add to home packages.";
    };

    configSource = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to an existing config.kdl to link into ~/.config/niri/config.kdl.";
    };

    configText = lib.mkOption {
      type = lib.types.lines;
      default = ''
        // Minimal Niri config. Replace or extend via profiles.niri.configText.
        // Documentation: https://github.com/YaLTeR/niri/tree/main/docs
        input {
          keyboard {
            xkb {
              layout "us"
              variant "colemak"
            }
          }
        }

        binds {
          Mod+Return {
            spawn "ghostty";
          }

          Mod+Q {
            quit;
          }
        }
      '';
      description = ''
        Inline config.kdl content to write into ~/.config/niri/.
        Ignored when configSource is non-null.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."niri/config.kdl" = mkConfigFile;
  };
}
