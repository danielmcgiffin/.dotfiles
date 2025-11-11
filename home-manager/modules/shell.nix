{
  lib,
  config,
  ...
}: {
  programs.bash = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = let
      # Cairo Station UNSC color mapping
      colors = config.lib.stylix.colors;
    in {
      format = lib.concatStrings [
        "[░▒▓](#${colors.base0D})" # UNSC blue gradient
        "[  ](bg:#${colors.base0D} fg:#${colors.base00})"
        "[](bg:#${colors.base0C} fg:#${colors.base0D})"
        "$directory"
        "[](fg:#${colors.base0C} bg:#${colors.base02})"
        "$git_branch"
        "$git_status"
        "[](fg:#${colors.base02} bg:#${colors.base01})"
        "$nodejs"
        "$rust"
        "$golang"
        "$php"
        "[](fg:#${colors.base01} bg:#${colors.base00})"
        "$time"
        "[ ](fg:#${colors.base00})"
        "\n$character"
      ];

      directory = {
        style = "fg:#${colors.base06} bg:#${colors.base0C}"; # Cyan holographic display
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
        style = "bg:#${colors.base02}";
        format = "[[ $symbol $branch ](fg:#${colors.base0C} bg:#${colors.base02})]($style)";
      };

      git_status = {
        style = "bg:#${colors.base02}";
        format = "[[($all_status$ahead_behind )](fg:#${colors.base0C} bg:#${colors.base02})]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#${colors.base01}";
        format = "[[ $symbol ($version) ](fg:#${colors.base0C} bg:#${colors.base01})]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#${colors.base01}";
        format = "[[ $symbol ($version) ](fg:#${colors.base0C} bg:#${colors.base01})]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#${colors.base01}";
        format = "[[ $symbol ($version) ](fg:#${colors.base0C} bg:#${colors.base01})]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#${colors.base01}";
        format = "[[ $symbol ($version) ](fg:#${colors.base0C} bg:#${colors.base01})]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#${colors.base00}";
        format = "[[  $time ](fg:#${colors.base0D} bg:#${colors.base00})]($style)"; # UNSC blue time
      };
    };
  };

  programs.dankMaterialShell = {
    enable = true;
    enableSystemd = true;

    # Fleet-wide default settings (local modal edits persist in settings.json)
    default.settings = {
      useFahrenheit = true;
      clockDateFormat = "MM/dd/yyyy";
      weatherEnabled = true;
      useAutoLocation = true;
      notificationsEnabled = true;
      brightnessEnabled = true;
      audioEnabled = true;
    };
  };
}
