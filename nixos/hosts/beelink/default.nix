{inputs, ...}: {
  imports = [
    ./hardware-configuration-desktop.nix
    ../../common.nix
    ../../modules/gaming.nix
    ../../modules/niri.nix
    ../../modules/stylix.nix
    ../../modules/homelab.nix
  ];

  # Hostname
  networking.hostName = "beelink";

  # Console keymap
  console.keyMap = "us";

  # Boot configuration
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelParams = [
    "amdgpu.dc=1"
    # Don't force deep sleep - this system only supports s2idle
  ];

  # Use niri-unstable
  niri.useUnstable = true;

  # Add niri overlay for unstable
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  # Host-specific niri output configuration
  home-manager.users.epicus.programs.niri.settings = {
    outputs = {
      "DP-10".position = {
        # ASUS VS238
        x = 1920;
        y = 0;
      };
      "DP-9".position = {
        # VG248
        x = 0;
        y = 0;
      };
    };

    # Named workspaces
    workspaces = {
      "chat" = {
        open-on-output = "DP-9"; # Left monitor
      };
      "games" = {
        open-on-output = "DP-10"; # Right monitor
      };
      "code" = {
        open-on-output = "DP-9"; # Left monitor
      };
    };
  };

  # Home-manager backup extension
  home-manager.backupFileExtension = "hm-bak";

  # Fix wake from suspend - force displays to wake immediately
  systemd.services.niri-resume = {
    description = "Wake up Niri displays after suspend";
    after = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
    wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
    serviceConfig = {
      Type = "oneshot";
      User = "epicus";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
      # Use full path to niri and dynamically find socket
      ExecStart = "/run/current-system/sw/bin/bash -c 'NIRI_SOCKET=$(ls /run/user/1000/niri*.sock | head -1) /run/current-system/sw/bin/niri msg action power-on-monitors'";
    };
  };

  # Additional workaround: Force TTY switch to wake displays
  systemd.services.niri-tty-wake = {
    description = "Force TTY switch to wake displays";
    after = ["suspend.target"];
    wantedBy = ["suspend.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/bash -c 'chvt 2; sleep 0.2; chvt 1'";
    };
  };
}
