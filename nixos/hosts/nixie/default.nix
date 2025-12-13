{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../modules/niri.nix
    ../../modules/stylix.nix
  ];

  networking.hostName = "nixie";

  # Basic tools for learning
  environment.systemPackages = with pkgs; [
    vscode
    git
  ];

  nix.buildMachines = [{
    hostName = "noxbox";
    systems = [ "x86_64-linux" ];
    maxJobs = 8;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  }]; 
  nix.distributedBuilds = true;
  nix.extraOptions = '' builders-use-substitutes = true '';

  # Niri configuration
  niri.useUnstable = true;
  nix.settings.substituters = ["https://niri.cachix.org"];
  nix.settings.trusted-public-keys = [
    "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
  ];
}
