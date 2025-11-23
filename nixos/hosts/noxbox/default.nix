{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../modules/gaming.nix
    ../../modules/niri.nix
    ../../modules/stylix.nix
  ];

  # Hostname
  networking.hostName = "noxbox";

  # Console keymap
  console.keyMap = "colemak";

  # Use niri-unstable
  niri.useUnstable = true;

  # Wireplumber for pipewire
  services.pipewire.wireplumber.enable = true;

  # Niri cachix
  nix.settings.substituters = ["https://niri.cachix.org"];
  nix.settings.trusted-public-keys = [
    "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
  ];

  # User in video group
  users.users.epicus.extraGroups = ["video"];
}
