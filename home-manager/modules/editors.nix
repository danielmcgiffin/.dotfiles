{
  inputs,
  pkgs,
  ...
}: {
#  programs.helix = {
#    enable = true;
#    package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
#
#    languages = {
#      language-server = {
#        marksman = {
#          command = "marksman";
#        };
#        nil = {
#          command = "nil";
#        };
#        vscode-json-language-server = {
#          command = "vscode-json-language-server";
#          args = ["--stdio"];
#        };
#        taplo = {
#          command = "taplo";
#          args = ["lsp" "stdin"];
#        };
#      };
#
#      language = [
#        {
#          name = "markdown";
#          language-servers = ["marksman"];
#        }
#        {
#          name = "nix";
#          language-servers = ["nil"];
#          formatter = { command = "alejandra"; };
#          auto-format = true;
#        }
#        {
#          name = "json";
#          language-servers = ["vscode-json-language-server"];
#        }
#        {
#          name = "toml";
#          language-servers = ["taplo"];
#        }
#      ];
#    };
#  };
}
