{
  config,
  pkgs,
  lib,
  ...
}: {
  # Swayidle for idle management - proper Wayland idle daemon
  services.swayidle = {
    enable = true;
    systemdTarget = "niri.service";

    timeouts = [
      {
        timeout = 300; # 5 minutes - turn off displays
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      {
        timeout = 900; # 15 minutes - lock screen
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
    ];

    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
    ];
  };

  # Swaylock UNSC theme - Stylix handles colors automatically
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # Display settings
      ignore-empty-password = true;
      show-failed-attempts = true;

      # Effects for UNSC aesthetic
      effect-blur = lib.mkForce "7x5";
      effect-vignette = lib.mkForce "0.5:0.5";
      fade-in = lib.mkForce 0.2;

      # Ring indicator (holographic authentication)
      indicator = lib.mkForce true;
      indicator-radius = lib.mkForce 100;
      indicator-thickness = lib.mkForce 7;

      # Clock - UNSC stardate format
      clock = lib.mkForce true;
      timestr = lib.mkForce "%H:%M";
      datestr = lib.mkForce "%Y.%m.%d";

      # Font
      font = lib.mkForce "JetBrains Mono";
      font-size = lib.mkForce 24;

      # Indicators
      indicator-idle-visible = lib.mkForce false;
      indicator-caps-lock = lib.mkForce true;
    };
  };
}
