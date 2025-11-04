{pkgs, ...}: {
  home.packages = with pkgs; [
    # Container TUI (no programs option available)
    lazydocker

    # Podman compose (podman itself is system-level)
    podman-compose
  ];

  # Jujutsu (jj) configuration - using programs option
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Daniel McGiffin";
        email = "danielmcgiffin@gmail.com";
      };

      ui = {
        default-command = "log";
        pager = "less -FRX";
      };

      # Git interop
      git = {
        auto-local-bookmark = true;
      };
    };
  };

  # jjui - TUI for jujutsu (using programs option)
  programs.jjui = {
    enable = true;
  };

  # Configure lazydocker to use podman
  xdg.configFile."lazydocker/config.yml".text = ''
    commandTemplates:
      dockerCompose: podman-compose

    os:
      openCommand: xdg-open

    # Use podman socket
    docker:
      command: podman
  '';

  # Set up podman socket for rootless containers
  home.sessionVariables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
  };
}
