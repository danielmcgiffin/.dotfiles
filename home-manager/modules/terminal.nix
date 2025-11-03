{config, ...}: {
  # Ghostty terminal theming with Cairo Station UNSC aesthetic
  xdg.configFile."ghostty/config".text = ''
    # Cairo Station UNSC Terminal theme
    background = 1c2128
    foreground = c5d0dc

    # Normal colors
    palette = 0=1c2128
    palette = 1=e65c5c
    palette = 2=6bc991
    palette = 3=f5c66d
    palette = 4=5b9fdb
    palette = 5=b48ead
    palette = 6=4ec9e6
    palette = 7=c5d0dc

    # Bright colors
    palette = 8=4a5463
    palette = 9=e65c5c
    palette = 10=6bc991
    palette = 11=f5c66d
    palette = 12=5b9fdb
    palette = 13=b48ead
    palette = 14=4ec9e6
    palette = 15=f0f6ff

    # Font configuration
    font-family = ${config.stylix.fonts.monospace.name}
    font-size = 12

    # Cursor
    cursor-color = 4ec9e6

    # Window
    window-padding-x = 8
    window-padding-y = 8
  '';
}
