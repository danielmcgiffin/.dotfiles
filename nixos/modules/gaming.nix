{pkgs, ...}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
}
