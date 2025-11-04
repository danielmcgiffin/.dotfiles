{pkgs, ...}: {
  # Enable rootless podman for containers
  virtualisation.podman = {
    enable = true;

    # Docker compatibility
    dockerCompat = true;
    dockerSocket.enable = true;

    # Recommended for better performance
    defaultNetwork.settings.dns_enabled = true;
  };

  # Use podman for OCI containers (used by services)
  virtualisation.oci-containers.backend = "podman";

  # Enable user namespaces for rootless containers
  users.users.epicus.extraGroups = ["podman"];

  # Useful container tools
  environment.systemPackages = with pkgs; [
    buildah # Build container images
    skopeo  # Work with container registries
  ];
}
