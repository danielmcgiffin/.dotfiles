{...}: {
  stylix = {
    enable = true;
    polarity = "dark";
    image = ../../wallpapers/unsc_infinity.png;

    # Cairo Station UNSC Terminal Aesthetic
    # Based on Halo 2's orbital defense platform
    base16Scheme = {
      base00 = "1c2128"; # background - dark corridors, emergency lighting
      base01 = "262d36"; # lighter background - wall panels/consoles
      base02 = "313944"; # selection background - active terminals
      base03 = "4a5463"; # comments/disabled - inactive systems
      base04 = "71808f"; # dark foreground - secondary readouts
      base05 = "c5d0dc"; # default foreground - main readouts (cool white)
      base06 = "dbe4f0"; # light foreground - focused/important elements
      base07 = "f0f6ff"; # lightest foreground - critical alerts

      base08 = "e65c5c"; # red - hull breach/shields down
      base09 = "ff8c42"; # orange - warnings/ammunition low
      base0A = "f5c66d"; # yellow - nav markers/waypoints
      base0B = "6bc991"; # green - all systems normal/shield full
      base0C = "4ec9e6"; # cyan - holographic displays/cortana/AI
      base0D = "5b9fdb"; # blue - UNSC standard tech/objectives
      base0E = "b48ead"; # purple - covenant plasma/rarely used
      base0F = "c97c68"; # brown/rust - damage indicators/worn metal
    };
  };
}
