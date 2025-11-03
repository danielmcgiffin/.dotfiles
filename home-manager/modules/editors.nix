{...}: {
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
}
