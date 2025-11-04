{
  config,
  pkgs,
  lib,
  ...
}: {
  # Jellyfin media server
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/srv/homelab/jellyfin";
    user = "epicus";
    group = "users";
  };

  # qBittorrent as a container
  virtualisation.oci-containers.containers.qbittorrent = {
    image = "lscr.io/linuxserver/qbittorrent:latest";
    ports = [
      "8081:8081" # Web UI
      "6881:6881" # Torrent port TCP
      "6881:6881/udp" # Torrent port UDP
    ];
    volumes = [
      "/srv/homelab/qbittorrent:/config"
      "/srv/media/downloads:/downloads"
    ];
    environment = {
      PUID = "1000"; # Your user ID
      PGID = "100"; # users group
      TZ = "America/New_York";
      WEBUI_PORT = "8081";
    };
  };

  # Karakeep - Self-hosted bookmark manager with AI
  # Meilisearch search engine
  virtualisation.oci-containers.containers.karakeep-meilisearch = {
    image = "getmeili/meilisearch:v1.13.3";
    volumes = [
      "/srv/homelab/karakeep/meilisearch:/meili_data"
    ];
    environment = {
      MEILI_ENV = "production";
      MEILI_MASTER_KEY = "fZU0IkXs3G81cRVFBpvUgakjhoJJmYigc9Mp";
    };
  };

  # Chrome headless browser for crawling
  virtualisation.oci-containers.containers.karakeep-chrome = {
    image = "gcr.io/zenika-hub/alpine-chrome:124";
    cmd = [
      "--no-sandbox"
      "--disable-gpu"
      "--disable-dev-shm-usage"
      "--remote-debugging-address=0.0.0.0"
      "--remote-debugging-port=9222"
      "--hide-scrollbars"
    ];
  };

  # Karakeep web application
  virtualisation.oci-containers.containers.karakeep-web = {
    image = "ghcr.io/karakeep-app/karakeep:release";
    dependsOn = ["karakeep-meilisearch" "karakeep-chrome"];
    ports = [
      "3000:3000"
    ];
    volumes = [
      "/srv/homelab/karakeep/data:/data"
    ];
    environment = {
      DATA_DIR = "/data";
      MEILI_ADDR = "http://karakeep-meilisearch:7700";
      MEILI_MASTER_KEY = "fZU0IkXs3G81cRVFBpvUgakjhoJJmYigc9Mp";
      BROWSER_WEB_URL = "http://karakeep-chrome:9222";
      NEXTAUTH_SECRET = "J3ps2Mycer1AsBF/ba94kpuGQCJ1wDB/BfMv";
      NEXTAUTH_URL = "http://localhost:3000";
      OPENAI_BASE_URL = "https://generativelanguage.googleapis.com/v1beta";
      OPENAI_API_KEY = "AIzaSyCzNFwy6EihOvNxTYCufGngXXtabalbX9c";
      INFERENCE_TEXT_MODEL = "gemini-2.5-flash";
      INFERENCE_IMAGE_MODEL = "gemini-2.5-flash";
    };
  };

  # Ensure directories exist with correct permissions
  systemd.tmpfiles.rules = [
    "d /srv/homelab 0755 epicus users -"
    "d /srv/homelab/jellyfin 0755 epicus users -"
    "d /srv/homelab/qbittorrent 0755 epicus users -"
    "d /srv/homelab/karakeep 0755 epicus users -"
    "d /srv/homelab/karakeep/data 0755 epicus users -"
    "d /srv/homelab/karakeep/meilisearch 0755 epicus users -"
    "d /srv/media 0755 epicus users -"
    "d /srv/media/downloads 0755 epicus users -"
  ];

  # Open firewall for services
  networking.firewall.allowedTCPPorts = [3000 8081 6881]; # Karakeep, qBit UI, qBit torrent
  networking.firewall.allowedUDPPorts = [6881]; # qBit torrent
}
