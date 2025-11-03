{...}: {
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
}
