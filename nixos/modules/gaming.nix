{pkgs, ...}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true; # LAN game transfers
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # Steam LAN discovery and Civ 6 multiplayer
  networking.firewall = {
    allowedTCPPorts = [
      27036 # Steam LAN discovery
      27037 # Steam LAN discovery
    ];
    allowedUDPPorts = [
      27015 # Steam game server discovery (SRCDS)
      27016 # Steam game server discovery
      27036 # Steam LAN discovery/broadcasts
      4380  # Steam client service
    ];
  };
}
