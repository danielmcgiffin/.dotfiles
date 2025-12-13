{ config, pkgs, ... }:

{
  # Set a consistent state version for Home Manager
  home.stateVersion = "23.11"; # You can update this later if needed

  # Define common bash settings
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -lh";
      la = "ls -lha";
      update = "sudo nixos-rebuild switch --flake ~/.dotfiles#$(hostname)";
    };
    initExtra = ''
      # Your custom bash initializations here
      # For example:
      # export EDITOR=nvim
    '';
  };

  # Link common dotfiles
  home.file.".bashrc".source = ./bashrc-content;
  home.file.".profile".source = ./profile-content;

  # Define common packages
  home.packages = with pkgs; [
    git
    vim # or neovim, helix, etc.
    htop
    # Add other common utilities here
  ];

  # You can add more shared configurations here (e.g., git config, direnv, etc.)
}
