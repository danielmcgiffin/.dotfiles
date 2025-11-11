{config, osConfig, ...}: let
  # Use Colemak on noxbox, US on beelink
  keyboardLayout = if osConfig.networking.hostName == "noxbox" then "us(colemak)" else "us";
in {
  programs.niri.settings = {
    input = {
      keyboard.xkb.layout = keyboardLayout;
      focus-follows-mouse.enable = true;
    };

    window-rules = [
      {
        matches = [{app-id = "^steam$";}];
        default-column-width = {};
      }
      {
        matches = [{title = "^Steam - ";}];
        open-floating = true;
      }
      {
        matches = [{title = "^Steam Guard";}];
        open-floating = true;
      }
      {
        matches = [{title = ".* - Steam";}];
        open-floating = true;
      }
    ];

    # Monitor positions moved to per-host configs
    # See nixos/hosts/beelink/default.nix for DP-7/DP-8 configuration

    spawn-at-startup = [
      {argv = ["bash" "-c" "wl-paste --watch cliphist store &"];}
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

      "Mod+L" = {
        action.spawn = ["swaylock" "-f"];
        hotkey-overlay.title = "Lock Screen";
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
}
