# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "epicus";
    homeDirectory = "/home/epicus";
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
    packages = with pkgs; [
      inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
      brave
      steam
      signal-desktop
      gemini-cli
      marksman
      nil
      nodePackages.vscode-langservers-extracted
      taplo
      alejandra
      hypridle
      hyprlock
      grim
      slurp
      swappy
      xfce.thunar
      yazi
      imv
      mpv
      zathura
      spotify
      pavucontrol
      xfce.thunar-archive-plugin
      file-roller
      discord
      networkmanagerapplet
      v4l-utils
    ];
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;

    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    settings = {
      user.name = "Daniel McGiffin";
      user.email = "danielmcgiffin@gmail.com";
      init.defaultBranch = "master";
      pull.rebase = true;
      push.autoSetupRemote = true;
      gpg.format = "ssh";
      core.autocrlf = "input";
      core.editor = "hx";
      delta = {
        navigate = true;
        line-numbers = true;
      };
      interactive.diffFilter = "delta --color-only";
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };

  programs.bash = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      git_branch = {
        symbol = " ";
        format = "on [$symbol$branch(:$remote_branch)]($style) ";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = "🏳 ";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?\${count}";
        stashed = "$\${count}";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };

  programs.dankMaterialShell = {
    enable = true;
    enableSystemd = true;
  };

  programs.niri.settings = {
    input = {
      keyboard.xkb.layout = "us";
    };

    outputs."DP-7".position.x = 0;
    outputs."DP-7".position.y = 0;

    outputs."DP-8".position.x = 1920;
    outputs."DP-8".position.y = 0;

    spawn-at-startup = [
      {argv = ["bash" "-c" "wl-paste --watch cliphist store &"];}
      {argv = ["hypridle"];}
    ];

    binds = with config.lib.niri.actions; {
      "Mod+Return" = {
        action.spawn = "ghostty";
        hotkey-overlay.title = "Terminal";
      };

      "Mod+Space" = {
        action.spawn = ["dms" "ipc" "call" "spotlight" "toggle"];
        hotkey-overlay.title = "Application Launcher";
      };

      "Mod+V" = {
        action.spawn = ["dms" "ipc" "call" "clipboard" "toggle"];
        hotkey-overlay.title = "Clipboard Manager";
      };

      "Mod+Alt+N" = {
        action.spawn = ["dms" "ipc" "call" "notifications" "toggle"];
        hotkey-overlay.title = "Notification Center";
      };

      "Mod+X" = {
        action.spawn = ["dms" "ipc" "call" "powermenu" "toggle"];
        hotkey-overlay.title = "Power Menu";
      };

      "XF86AudioRaiseVolume".action.spawn = ["dms" "ipc" "call" "audio" "increment" "3"];
      "XF86AudioLowerVolume".action.spawn = ["dms" "ipc" "call" "audio" "decrement" "3"];
      "XF86AudioMute".action.spawn = ["dms" "ipc" "call" "audio" "mute"];
      "XF86MonBrightnessUp".action.spawn = ["dms" "ipc" "call" "brightness" "increment" "5" ""];
      "XF86MonBrightnessDown".action.spawn = ["dms" "ipc" "call" "brightness" "decrement" "5" ""];

      "Mod+Shift+S" = {
        action.spawn = ["bash" "-c" "grim -g \"$(slurp)\" - | swappy -f -"];
        hotkey-overlay.title = "Screenshot Region";
      };

      "Print" = {
        action.spawn = ["bash" "-c" "grim - | swappy -f -"];
        hotkey-overlay.title = "Screenshot Full Screen";
      };

      "Mod+Print" = {
        action.spawn = ["bash" "-c" "grim -g \"$(slurp)\" - | wl-copy"];
        hotkey-overlay.title = "Screenshot Region to Clipboard";
      };

      "Mod+Q".action = close-window;

      "Mod+Left".action = focus-column-left;
      "Mod+Down".action = focus-window-down;
      "Mod+Up".action = focus-window-up;
      "Mod+Right".action = focus-column-right;
      "Mod+N".action = focus-column-left;
      "Mod+E".action = focus-window-down;
      "Mod+I".action = focus-window-up;
      "Mod+O".action = focus-column-right;

      "Mod+Shift+Left".action = focus-monitor-left;
      "Mod+Shift+Down".action = focus-monitor-down;
      "Mod+Shift+Up".action = focus-monitor-up;
      "Mod+Shift+Right".action = focus-monitor-right;
      "Mod+Shift+N".action = focus-monitor-left;
      "Mod+Shift+E".action = focus-monitor-down;
      "Mod+Shift+I".action = focus-monitor-up;
      "Mod+Shift+O".action = focus-monitor-right;

      "Mod+Ctrl+Left".action = move-column-left;
      "Mod+Ctrl+Down".action = move-window-down;
      "Mod+Ctrl+Up".action = move-window-up;
      "Mod+Ctrl+Right".action = move-column-right;
      "Mod+Ctrl+N".action = move-column-left;
      "Mod+Ctrl+E".action = move-window-down;
      "Mod+Ctrl+I".action = move-window-up;
      "Mod+Ctrl+O".action = move-column-right;

      "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
      "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
      "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
      "Mod+Shift+Ctrl+N".action = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+E".action = move-column-to-monitor-down;
      "Mod+Shift+Ctrl+I".action = move-column-to-monitor-up;
      "Mod+Shift+Ctrl+O".action = move-column-to-monitor-right;

      "Mod+H".action = focus-column-first;
      "Mod+Shift+H".action = move-column-to-first;
      "Mod+K".action = focus-column-last;
      "Mod+Shift+K".action = move-column-to-last;

      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;
      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;

      "Mod+Comma".action = consume-window-into-column;
      "Mod+Period".action = expel-window-from-column;

      "Mod+F".action = maximize-column;
      "Mod+Shift+F".action = fullscreen-window;

      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Plus".action.set-column-width = "+10%";
      "Mod+Shift+Minus".action.set-window-width = "-10%";
      "Mod+Shift+Plus".action.set-window-width = "+10%";

      "Mod+Alt+Shift+E".action = quit;
      "Mod+Shift+Slash".action = show-hotkey-overlay;
    };
  };

  # xdg.configFile."DankMaterialShell/settings.json".text = builtins.toJSON {
  # weather.units = "imperial";
  # date.format   = "MM/dd/yyyy";
  # };

  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = niri msg action power-on-monitors
    }

    listener {
        timeout = 600
        on-timeout = loginctl lock-session
    }

    listener {
        timeout = 630
        on-timeout = niri msg action power-off-monitors
        on-resume = niri msg action power-on-monitors
    }

    listener {
        timeout = 1800
        on-timeout = systemctl suspend
    }
  '';

  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        disable_loading_bar = true
        hide_cursor = true
        grace = 0
        no_fade_in = false
    }

    background {
        monitor =
        path = ${config.stylix.image}
        blur_passes = 3
        blur_size = 7
        noise = 0.0117
        contrast = 0.8916
        brightness = 0.8172
        vibrancy = 0.1696
        vibrancy_darkness = 0.0
    }

    input-field {
        monitor =
        size = 250, 50
        outline_thickness = 3
        dots_size = 0.33
        dots_spacing = 0.15
        dots_center = true
        outer_color = rgb(24, 25, 38)
        inner_color = rgb(91, 96, 120)
        font_color = rgb(202, 211, 245)
        fade_on_empty = true
        placeholder_text = <span foreground="##cad3f5">Password...</span>
        hide_input = false
        position = 0, -120
        halign = center
        valign = center
    }

    label {
        monitor =
        text = cmd[update:1000] echo "$(date +"%H:%M")"
        color = rgb(202, 211, 245)
        font_size = 120
        font_family = JetBrains Mono
        position = 0, 80
        halign = center
        valign = center
    }

    label {
        monitor =
        text = cmd[update:1000] echo "$(date +"%A, %B %d")"
        color = rgb(202, 211, 245)
        font_size = 25
        font_family = JetBrains Mono
        position = 0, -40
        halign = center
        valign = center
    }
  '';

  xdg.configFile."helix/languages.toml".text = ''
    [[language]]
    name = "markdown"
    language-servers = ["marksman"]

    [language-server.marksman]
    command = "marksman"

    [[language]]
    name = "nix"
    language-servers = ["nil"]
    formatter = { command = "alejandra" }
    auto-format = true

    [language-server.nil]
    command = "nil"

    [[language]]
    name = "json"
    language-servers = ["vscode-json-language-server"]

    [language-server.vscode-json-language-server]
    command = "vscode-json-language-server"
    args = ["--stdio"]

    [[language]]
    name = "toml"
    language-servers = ["taplo"]

    [language-server.taplo]
    command = "taplo"
    args = ["lsp", "stdin"]

    # No packaged KDL language server in nixpkgs right now; tree-sitter handles syntax.
  '';

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
