{ lib, pkgs, config, ... }:
let
  cfg = config.profiles.niri;

  sessionScript = pkgs.writeShellScriptBin "niri-session" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=niri
    export XDG_DESKTOP_PORTAL_DIR=$XDG_RUNTIME_DIR/xdg-desktop-portal
    exec dbus-run-session -- ${cfg.package}/bin/niri ${lib.strings.concatStringsSep " " cfg.extraArgs}
  '';
in {
  options.profiles.niri = {
    enable = lib.mkEnableOption "Run the Niri Wayland compositor as the main system session via greetd.";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.niri;
      description = "Niri package to execute for the session.";
    };

    tuigreetPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.tuigreet;
      description = "tuigreet package used by greetd for the login prompt.";
    };


    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = [ "--config" "/etc/niri/config.kdl" ];
      description = "Extra arguments appended to the Niri invocation.";
    };

    tuigreetArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "--remember" "--time" ];
      description = "Additional arguments passed to tuigreet.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      cfg.tuigreetPackage
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session.command = lib.concatStringsSep " " (
          [ "${cfg.tuigreetPackage}/bin/tuigreet" "--cmd" "${sessionScript}/bin/niri-session" ]
          ++ cfg.tuigreetArgs
        );
      };
    };

    # Turn off the Plasma/Sddm stack when Niri drives the session.
    services.xserver.enable = lib.mkDefault false;
    services.displayManager.sddm.enable = lib.mkDefault false;
    services.desktopManager.plasma6.enable = lib.mkDefault false;
  };
}
