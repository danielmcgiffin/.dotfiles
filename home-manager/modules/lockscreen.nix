{config, ...}: {
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
}
