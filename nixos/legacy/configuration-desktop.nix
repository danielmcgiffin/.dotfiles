# This is your system's configuration file.
# Test Generation
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration-desktop.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      inputs.niri.overlays.niri
      inputs.claude-code.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
      download-buffer-size = 524288000;

      substituters = [
        "https://cache.nixos.org"
        "https://nix-gaming.cachix.org"
        "https://claude-code.cachix.org"
      ];

      trusted-public-keys = [
        "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["mem_sleep_default=deep" "amdgpu.runpm=0" "amdgpu.dc=1"];

  networking = {
    hostName = "beelink";
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services = {
    xserver.enable = true;
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "epicus";
      };
    };

    printing.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh = {
      enable = true;
      settings = {
        # Opinionated: forbid root login through SSH.
        PermitRootLogin = "no";
        # Opinionated: use keys only.
        # Remove if you want to SSH using passwords
        PasswordAuthentication = false;
      };
    };
    tailscale.enable = true;

    # Power management
    upower.enable = true;

    # Bluetooth
    blueman.enable = true;
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs.dconf.enable = true;
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    jetbrains-mono
    fira-code
    fira-code-symbols
    font-awesome
  ];

  stylix = {
    enable = true;
    polarity = "dark";
    image = ../wallpapers/unsc_infinity.png;

    # Cairo Station UNSC Terminal Aesthetic
    # Based on Halo 2's orbital defense platform
    base16Scheme = {
      base00 = "1c2128"; # background - dark corridors, emergency lighting
      base01 = "262d36"; # lighter background - wall panels/consoles
      base02 = "313944"; # selection background - active terminals
      base03 = "4a5463"; # comments/disabled - inactive systems
      base04 = "71808f"; # dark foreground - secondary readouts
      base05 = "c5d0dc"; # default foreground - main readouts (cool white)
      base06 = "dbe4f0"; # light foreground - focused/important elements
      base07 = "f0f6ff"; # lightest foreground - critical alerts

      base08 = "e65c5c"; # red - hull breach/shields down
      base09 = "ff8c42"; # orange - warnings/ammunition low
      base0A = "f5c66d"; # yellow - nav markers/waypoints
      base0B = "6bc991"; # green - all systems normal/shield full
      base0C = "4ec9e6"; # cyan - holographic displays/cortana/AI
      base0D = "5b9fdb"; # blue - UNSC standard tech/objectives
      base0E = "b48ead"; # purple - covenant plasma/rarely used
      base0F = "c97c68"; # brown/rust - damage indicators/worn metal
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true; # Wayland backend for Niri
    extraPortals = with pkgs; [xdg-desktop-portal-gtk]; # File pickers, screenshots
    config.common.default = ["wlr" "gtk"];
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    wl-clipboard
    cliphist
    brightnessctl
    matugen
    quickshell
    pciutils
    usbutils
    lm_sensors
    tree
    ripgrep
    claude-code
  ];

  users.users = {
    epicus = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDE1cfusRXHG5+r+G4/HmO42wjrFIrahD6uXgsDTITp= danielmcgiffin@gmail.com"
      ];
      extraGroups = ["wheel" "networkmanager"];
    };
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.epicus = import ../home-manager/home.nix;
    backupFileExtension = "hm-bak";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
