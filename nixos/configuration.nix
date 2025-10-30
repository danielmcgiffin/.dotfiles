{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.niri.nixosModules.niri
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ inputs.niri.overlays.niri ];
  };
  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      settings = {
        experimental-features = "nix-command flakes";
        flake-registry = "";
        nix-path = config.nix.nixPath;
        substituters = [
          "https://cache.nixos.org"
          "https://niri.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        ];
      };
      channel.enable = false;
      registry = lib.mkForce (lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs);
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "noxbox";
  networking.networkmanager.enable = true;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  users.users.epicus = {
    isNormalUser = true;
    description = "Epicus";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs = {
    seahorse.enable = true; 
    firefox.enable = true;
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };
  

  environment.systemPackages = with pkgs; [
    helix
    git
    zellij
    ghostty
    wget
    nodejs
    syncthing
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  services.syncthing = {
    enable = true;
    user = "epicus";
  };

  services.tailscale.enable = true;
  
  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "epicus";
      # niri-flake ships niri-session; falls back to niri if needed
      command = "${pkgs.niri}/bin/niri";  # or "${pkgs.niri}/bin/niri-session"
    };
  };

  system.stateVersion = "25.05";
}
