  - Lock screen & wallpaper (home-manager/home.nix:77-110): Niri’s spawn-at-startup doesn’t launch a
    locker or background tool. Add your picks (e.g., swaylock-effects, swaybg/wpaperd, hyprpaper) to
    home.packages and start them via spawn-at-startup so you can lock the session and set a wallpaper
    when Niri starts.
  - System trays & device helpers (nixos/configuration.nix:67-116, home-manager/home.nix:47-
    55): Networking and Bluetooth GUIs aren’t enabled. Turn on services like services.blueman for
    Bluetooth, services.upower for battery reporting, maybe programs.networkmanager-applet or a
    DankMaterialShell widget if you want tray controls.
  - Everyday apps (home-manager/home.nix:47-55, nixos/configuration.nix:128-137): Only Ghostty
    and Helix are installed. Add your browser, file manager, media viewers, screenshot tools, etc.
    Examples: firefox, thunar, grim, slurp, imv, zathura.
  - Fonts & theming (nixos/configuration.nix:128-137): No font packages or theme configs are set,
    so you’re missing emoji/symbol coverage and any consistent look. Populate fonts.packages (e.g.,
    noto-fonts, jetbrains-mono, noto-fonts-emoji) and configure GTK/Qt themes (e.g., add pkgs.adw-
    gtk3, export matching GTK_THEME, QT_QPA_PLATFORMTHEME).
  - Figure out how to setup my Beelink SER-8 with 2 1TB drives to handle all my aspiration homelab shit, data, games, etc
 regardless of what version of linux I'm using.
