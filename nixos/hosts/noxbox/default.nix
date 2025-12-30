{inputs, ...}: {
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

  # Fix Asus laptop Super key not working
  # Many Asus laptops have the Super key disabled by default
  services.udev.extraHwdb = ''
    # Asus laptop keyboard - enable Super/Meta keys
    evdev:input:b0003v0B05p1866*
     KEYBOARD_KEY_700e3=leftmeta
     KEYBOARD_KEY_700e7=rightmeta
  '';

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

  # Add niri overlay for unstable
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  # Host-specific niri output configuration
  home-manager.users.epicus.programs.niri.settings = {
    outputs = {
      "Najing CEC Panda FPD Technology CO. ltd 0x0050 Unknown".position = {
        # Laptop screen (left)
        x = 0;
        y = 0;
      };
      "HP Inc. HP M24f FHD 3CM2231QJ4   ".position = {
        # HP monitor (right)
        x = 1536;
        y = 0;
      };
    };
  };
}
