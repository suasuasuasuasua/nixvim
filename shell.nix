{
  pkgs,
  config,
  ...
}:
pkgs.mkShellNoCC {
  # enable the shell hooks
  shellHook =
    # bash
    ''
      # install the git hooks
      ${config.pre-commit.installationScript}
      git remote update && git status -uno
    '';

  # define the programs available when running `nix develop`
  # add the packages from the git-hooks list too
  buildInputs = config.pre-commit.settings.enabledPackages;
  packages = with pkgs; [
    # commands
    just # command runner
    vim-startuptime # proflie vim and neovim

    # formatter
    treefmt
    nodePackages.prettier
    nixfmt-rfc-style # nix formatter

    # linters
    markdownlint-cli # markdown linter

    # lsp
    nil # lsp 1
    nixd # lsp 2
    marksman # markdown

    # source control
    commitizen # templated commits and bumping
    git # source control program
  ];
}
