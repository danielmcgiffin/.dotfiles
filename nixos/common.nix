{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/podman.nix
  ];
  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      inputs.claude-code.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Nix settings
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
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

    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Boot configuration (common parts)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.networkmanager.enable = true;

  # Localization
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

  # Services
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
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    tailscale.enable = true;
    upower.enable = true;
    blueman.enable = true;
  };

  # Security & Hardware
  security.rtkit.enable = true;
  security.polkit.enable = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Programs
  programs.dconf.enable = true;

  # Services for file managers
  services.gvfs.enable = true; # Virtual filesystems (trash, network, etc)

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    jetbrains-mono
    fira-code
    fira-code-symbols
    font-awesome
  ];

  # XDG Portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    config.common.default = ["wlr" "gtk"];
  };

  # System packages
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

  # User configuration
  users.users.epicus = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDE1cfusRXHG5+r+G4/HmO42wjrFIrahD6uXgsDTITp= danielmcgiffin@gmail.com"
    ];
    extraGroups = ["wheel" "networkmanager"];
  };

  # Home Manager
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.epicus = import ../home-manager/home.nix;
  };

  # State version
  system.stateVersion = "25.05";
}
