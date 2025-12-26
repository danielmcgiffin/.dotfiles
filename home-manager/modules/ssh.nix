{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      PubkeyAcceptedKeyTypes ssh-ed25519
    '';
    addKeysToAgent = "yes";
    forwardAgent = false;
  };

  services.ssh-agent = {
    enable = true;
  };
}
