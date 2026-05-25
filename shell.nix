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
    commitizen
    git
    just
    markdownlint-cli
    marksman
    nil
    nixd
    nixfmt-rfc-style
    prettier
    treefmt
    vim-startuptime
  ];
}
