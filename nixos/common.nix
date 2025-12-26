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
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${config.programs.niri.package}/bin/niri-session";
          user = "greeter";
        };
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

    # Syncthing for Obsidian vault sync
    syncthing = {
      enable = true;
      user = "epicus";
      group = "users";
      dataDir = "/home/epicus/.config/syncthing";
      configDir = "/home/epicus/.config/syncthing";
      openDefaultPorts = true;
    };
  };

  # Ensure Syncthing directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /srv/obsidian 0755 epicus users -"
  ];

  # Security & Hardware
  security.rtkit.enable = true;
  security.polkit.enable = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Programs
  programs.dconf.enable = true;

  # Enable nix-ld to run unpatched dynamic binaries (like Arduino IDE)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Core
    stdenv.cc.cc.lib
    zlib
    fuse3
    # Electron/Chrome dependencies
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libGL
    libappindicator-gtk3
    libdrm
    libnotify
    libpulseaudio
    libsecret
    libuuid
    libxkbcommon
    mesa
    libgbm
    nspr
    nss
    pango
    pipewire
    systemd
    # X11
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxkbfile
    xorg.libxshmfence
  ];

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
  users.users = {
    # Admin user
    epicus = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDE1cfusRXHG5+r+G4/HmO42wjrFIrahD6uXgsDTITp= danielmcgiffin@gmail.com"
      ];
      extraGroups = ["wheel" "networkmanager"];
    };

    # Kids users (no sudo access)
    brendan = {
      isNormalUser = true;
      extraGroups = ["networkmanager"];
    };

    david = {
      isNormalUser = true;
      extraGroups = ["networkmanager"];
    };

    james = {
      isNormalUser = true;
      extraGroups = ["networkmanager"];
    };

    matthew = {
      isNormalUser = true;
      extraGroups = ["networkmanager"];
    };
  };

  # Home Manager
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users = {
      epicus = import ../home-manager/users/epicus.nix;
      brendan = import ../home-manager/users/kids/brendan.nix;
      david = import ../home-manager/users/kids/david.nix;
      james = import ../home-manager/users/kids/james.nix;
      matthew = import ../home-manager/users/kids/matthew.nix;
    };
  };

  # State version
  system.stateVersion = "25.05";
}
