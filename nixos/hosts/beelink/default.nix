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

  # Boot configuration
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelParams = ["mem_sleep_default=deep" "amdgpu.runpm=0" "amdgpu.dc=1"];

  # Use niri-unstable
  niri.useUnstable = true;

  # Add niri overlay for unstable
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  # Home-manager backup extension
  home-manager.backupFileExtension = "hm-bak";
}
