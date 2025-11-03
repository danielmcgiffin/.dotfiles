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
      format = lib.concatStrings [
        "[░▒▓](#a3aed2)"
        "[  ](bg:#a3aed2 fg:#090c0c)"
        "[](bg:#769ff0 fg:#a3aed2)"
        "$directory"
        "[](fg:#769ff0 bg:#394260)"
        "$git_branch"
        "$git_status"
        "[](fg:#394260 bg:#212736)"
        "$nodejs"
        "$rust"
        "$golang"
        "$php"
        "[](fg:#212736 bg:#1d2230)"
        "$time"
        "[ ](fg:#1d2230)"
        "\n$character"
      ];

      directory = {
        style = "fg:#e3e5e5 bg:#769ff0";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };

      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };
    };
  };

  programs.dankMaterialShell = {
    enable = true;
    enableSystemd = true;
  };

  # Ghostty terminal theming with Cairo Station UNSC aesthetic
  xdg.configFile."ghostty/config".text = ''
    # Cairo Station UNSC Terminal theme
    background = 1c2128
    foreground = c5d0dc

    # Normal colors
    palette = 0=1c2128
    palette = 1=e65c5c
    palette = 2=6bc991
    palette = 3=f5c66d
    palette = 4=5b9fdb
    palette = 5=b48ead
    palette = 6=4ec9e6
    palette = 7=c5d0dc

    # Bright colors
    palette = 8=4a5463
    palette = 9=e65c5c
    palette = 10=6bc991
    palette = 11=f5c66d
    palette = 12=5b9fdb
    palette = 13=b48ead
    palette = 14=4ec9e6
    palette = 15=f0f6ff

    # Font configuration
    font-family = ${config.stylix.fonts.monospace.name}
    font-size = 12

    # Cursor
    cursor-color = 4ec9e6

    # Window
    window-padding-x = 8
    window-padding-y = 8
  '';

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

    # Disabled: Let monitors handle their own power saving
    # Monitor power-off was causing wake issues with Niri
    # listener {
    #     timeout = 630
    #     on-timeout = niri msg action power-off-monitors
    #     on-resume = niri msg action power-on-monitors
    # }

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
        brightness = 0.6
        vibrancy = 0.1696
        vibrancy_darkness = 0.0
    }

    # UNSC Authentication Terminal
    input-field {
        monitor =
        size = 300, 60
        outline_thickness = 2
        dots_size = 0.25
        dots_spacing = 0.3
        dots_center = true
        outer_color = rgb(4ec9e6)      # cyan - holographic border
        inner_color = rgb(262d36)      # dark panel background
        font_color = rgb(c5d0dc)       # cool white text
        fade_on_empty = true
        fade_timeout = 1000
        placeholder_text = <span foreground="##71808f">BIOMETRIC SCAN REQUIRED...</span>
        hide_input = false
        position = 0, -120
        halign = center
        valign = center
        check_color = rgb(6bc991)      # green - auth success
        fail_color = rgb(e65c5c)       # red - auth failed
        fail_text = <span foreground="##e65c5c">ACCESS DENIED</span>
        capslock_color = rgb(ff8c42)   # orange - warning
    }

    # System Time Display
    label {
        monitor =
        text = cmd[update:1000] echo "$(date +"%H%M")"
        color = rgb(4ec9e6)            # cyan - holographic readout
        font_size = 140
        font_family = JetBrains Mono
        position = 0, 120
        halign = center
        valign = center
    }

    # Date Stamp
    label {
        monitor =
        text = cmd[update:1000] echo "$(date +"STARDATE: %Y.%m.%d")"
        color = rgb(71808f)            # muted - secondary info
        font_size = 16
        font_family = JetBrains Mono
        position = 0, 40
        halign = center
        valign = center
    }

    # Status Indicator
    label {
        monitor =
        text = CAIRO STATION // AUTHENTICATION REQUIRED
        color = rgb(ff8c42)            # orange - alert status
        font_size = 14
        font_family = JetBrains Mono
        position = 0, -200
        halign = center
        valign = center
    }

    # Bottom Status Bar
    label {
        monitor =
        text = UNSC DEFENSE GRID ACTIVE // ALL SYSTEMS NOMINAL
        color = rgb(6bc991)            # green - systems operational
        font_size = 11
        font_family = JetBrains Mono
        position = 0, 30
        halign = center
        valign = bottom
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
