# Desktop Installation Guide (Beelink SER-8)

## Overview
This guide walks through installing NixOS on your desktop using the flake configuration, migrating from Arch Linux while preserving all your data.

## Pre-Installation Checklist

### Current Setup (Arch Linux)
- **nvme0n1p2**: `/srv` (931.5GB) - homelab, media, karakeep data
- **nvme1n1p2**: `/` + `/home` (929.5GB encrypted) - Your files, Steam games, configs

### Target Setup (NixOS)
- **nvme1n1**: Fresh NixOS system (encrypted)
  - `p1`: `/boot` (2GB)
  - `p2`: `/` (929.5GB, LUKS encrypted)
- **nvme0n1p2**: `/srv` (931.5GB) - Keep as-is for data

## Step 1: Backup Your Data

**CRITICAL**: Back up `/home` to the data drive before wiping anything!

```bash
# On your current Arch system
sudo rsync -avP --delete /home/epicus /srv/backup-home/

# Verify backup
ls -lah /srv/backup-home/epicus
du -sh /srv/backup-home/epicus

# Optional: backup important configs
sudo rsync -avP /etc/nixos /srv/backup-etc/ || true
```

## Step 2: Create NixOS Installer USB

On another machine or before rebooting:
```bash
# Download NixOS ISO (latest unstable)
wget https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso

# Write to USB (replace /dev/sdX with your USB drive)
sudo dd if=latest-nixos-minimal-x86_64-linux.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## Step 3: Boot Installer & Partition

Boot from USB, then:

```bash
# Verify drives are detected
lsblk

# WIPE nvme1n1 (system drive) - THIS DESTROYS ALL DATA ON nvme1n1!
sudo wipefs -a /dev/nvme1n1

# Partition nvme1n1
sudo parted /dev/nvme1n1 -- mklabel gpt
sudo parted /dev/nvme1n1 -- mkpart ESP fat32 1MiB 2GiB
sudo parted /dev/nvme1n1 -- set 1 esp on
sudo parted /dev/nvme1n1 -- mkpart primary 2GiB 100%

# Format boot partition
sudo mkfs.vfat -F 32 -n BOOT /dev/nvme1n1p1

# Setup encryption on root partition
sudo cryptsetup luksFormat /dev/nvme1n1p2
# Enter a strong passphrase!

sudo cryptsetup open /dev/nvme1n1p2 root
# Enter passphrase again

# Format encrypted root
sudo mkfs.ext4 -L nixos /dev/mapper/root

# Mount filesystems
sudo mount /dev/mapper/root /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme1n1p1 /mnt/boot

# Mount data drive (nvme0n1p2 - UNTOUCHED)
sudo mkdir -p /mnt/srv
sudo mount /dev/nvme0n1p2 /mnt/srv
```

## Step 4: Generate Hardware Config

```bash
# Generate initial hardware config
sudo nixos-generate-config --root /mnt

# Get UUIDs for hardware-configuration-desktop.nix
lsblk -f

# Note these UUIDs:
# - /dev/nvme1n1p1 (boot partition)
# - /dev/nvme1n1p2 (LUKS partition)
# - /dev/nvme0n1p2 (data partition)
```

## Step 5: Clone Dotfiles & Update Hardware Config

```bash
# Setup git & clone dotfiles
nix-shell -p git

cd /mnt/etc/nixos
git clone https://github.com/YOUR-USERNAME/dotfiles.git
cd dotfiles

# Edit hardware-configuration-desktop.nix with the UUIDs from lsblk -f
nano nixos/hardware-configuration-desktop.nix

# Replace all "REPLACE-WITH-UUID-DURING-INSTALL" with actual UUIDs:
# - LUKS device UUID (from /dev/nvme1n1p2)
# - Boot partition UUID (from /dev/nvme1n1p1)
# - Data partition UUID (from /dev/nvme0n1p2)
```

## Step 6: Install NixOS

```bash
# Still in /mnt/etc/nixos/dotfiles
sudo nixos-install --flake .#beelink

# Set root password when prompted

# Installation will take a while (downloading packages, building)
```

## Step 7: First Boot

```bash
# Reboot
sudo reboot

# Remove USB drive
# Enter LUKS passphrase at boot

# Login as epicus (your user is already configured via home-manager)
```

## Step 8: Restore Home Directory

```bash
# After first login
sudo rsync -avP /srv/backup-home/epicus/ /home/epicus/
sudo chown -R epicus:users /home/epicus

# Verify Steam games are there
ls -lah ~/.local/share/Steam

# Verify SSH keys
ls -lah ~/.ssh

# Test that everything works!
```

## Step 9: Cleanup

```bash
# After verifying everything works, remove backup
sudo rm -rf /srv/backup-home
```

## Troubleshooting

### Can't boot after install
- Check BIOS boot order
- Verify Secure Boot is disabled
- Make sure you're entering the correct LUKS passphrase

### Missing UUIDs
```bash
# Boot from USB again and check:
sudo cryptsetup open /dev/nvme1n1p2 root
lsblk -f
blkid
```

### Desktop won't start
```bash
# Check niri status
systemctl --user status niri

# Check logs
journalctl -xe
```

### Data drive not mounting
```bash
# Check /srv mount
sudo mount -a
df -h

# Fix fstab if needed
sudo nano /etc/nixos/dotfiles/nixos/hardware-configuration-desktop.nix
sudo nixos-rebuild switch --flake /etc/nixos/dotfiles#beelink
```

## Post-Install

Once booted:
```bash
# Update flake
cd ~/.dotfiles
nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake ~/.dotfiles#beelink

# Configure any desktop-specific settings
# All your apps, configs, keybindings are already set from the flake!
```

## Notes

- Your `/srv` data is never touched during installation
- All NixOS configs are in your dotfiles repo
- Steam games location: `~/.local/share/Steam/steamapps/common/`
- To switch configs: `sudo nixos-rebuild switch --flake ~/.dotfiles#beelink`
- Both laptop (noxbox) and desktop (beelink) share the same home-manager config
