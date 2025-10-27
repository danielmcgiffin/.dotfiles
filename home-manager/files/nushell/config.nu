# config.nu
#
# Installed by:
# version = "0.106.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R
alias hx  = ^hx
alias helix = ^hx
alias hxs = sudoedit

$env.STARSHIP_SHELL = "nu"
$env.PROMPT_COMMAND = { || starship prompt --cmd-duration $env.CMD_DURATION_MS $"--status=($env.LAST_EXIT_CODE)" }

# Tokyo Night color scheme
$env.config = {
    color_config: {
        separator: "#565f89"
        leading_trailing_space_bg: { attr: "n" }
        header: { fg: "#9ece6a" attr: "b" }
        empty: "#7aa2f7"
        bool: {
            true: "#9ece6a"
            false: "#f7768e"
        }
        int: "#bb9af7"
        filesize: {
            metric: "#7dcfff"
            binary: "#bb9af7"
        }
        duration: "#e0af68"
        date: {
            normal: "#7aa2f7"
            table: "#7aa2f7"
        }
        range: "#e0af68"
        float: "#bb9af7"
        string: "#9ece6a"
        nothing: "#f7768e"
        binary: "#bb9af7"
        cell-path: "#c0caf5"
        row_index: { fg: "#9ece6a" attr: "b" }
        record: "#c0caf5"
        list: "#c0caf5"
        block: "#c0caf5"
        hints: "#565f89"
        search_result: { fg: "#f7768e" bg: "#e0af68" }
        shape_and: { fg: "#bb9af7" attr: "b" }
        shape_binary: { fg: "#bb9af7" attr: "b" }
        shape_block: { fg: "#7aa2f7" attr: "b" }
        shape_bool: "#7dcfff"
        shape_closure: { fg: "#7dcfff" attr: "b" }
        shape_custom: "#9ece6a"
        shape_datetime: { fg: "#7dcfff" attr: "b" }
        shape_directory: "#7dcfff"
        shape_external: "#7dcfff"
        shape_externalarg: { fg: "#9ece6a" attr: "b" }
        shape_filepath: "#7dcfff"
        shape_flag: { fg: "#7aa2f7" attr: "b" }
        shape_float: { fg: "#bb9af7" attr: "b" }
        shape_garbage: { fg: "#ffffff" bg: "#f7768e" attr: "b" }
        shape_globpattern: { fg: "#7dcfff" attr: "b" }
        shape_int: { fg: "#bb9af7" attr: "b" }
        shape_internalcall: { fg: "#7dcfff" attr: "b" }
        shape_list: { fg: "#7dcfff" attr: "b" }
        shape_literal: "#7aa2f7"
        shape_match_pattern: "#9ece6a"
        shape_matching_brackets: { attr: "u" }
        shape_nothing: "#f7768e"
        shape_operator: "#e0af68"
        shape_or: { fg: "#bb9af7" attr: "b" }
        shape_pipe: { fg: "#bb9af7" attr: "b" }
        shape_range: { fg: "#e0af68" attr: "b" }
        shape_record: { fg: "#7dcfff" attr: "b" }
        shape_redirection: { fg: "#bb9af7" attr: "b" }
        shape_signature: { fg: "#9ece6a" attr: "b" }
        shape_string: "#9ece6a"
        shape_string_interpolation: { fg: "#7dcfff" attr: "b" }
        shape_table: { fg: "#7aa2f7" attr: "b" }
        shape_variable: "#bb9af7"
        shape_vardecl: "#bb9af7"
    }
}
