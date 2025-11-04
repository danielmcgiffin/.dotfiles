{pkgs, ...}: {
  # Set Thunar as default file manager
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "thunar.desktop";
      "x-directory/normal" = "thunar.desktop";
    };
  };

  # GTK theme settings for Thunar (UNSC dark aesthetic)
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
