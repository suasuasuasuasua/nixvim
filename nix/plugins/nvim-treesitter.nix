{ pkgs, ... }:
{
  # Highlight, edit, and navigate code
  # https://nix-community.github.io/nixvim/plugins/treesitter/index.html
  plugins.treesitter = {
    enable = true;

    # By default, all available grammars packaged in the nvim-treesitter
    # package are installed.
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      c
      csv
      diff
      editorconfig
      git_config
      git_rebase
      gitattributes
      gitcommit
      gitignore
      html
      ini
      lua
      luadoc
      markdown
      markdown_inline
      nix
      query
      regex
      ssh_config
      tmux
      toml
      vim
      vimdoc
      yaml
    ];

    settings = {
      # Highlight code snippets in nix
      nixvimInjections = true;

      highlight = {
        enable = true;

        # Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        additional_vim_regex_highlighting = true;
      };

      indent.enable = true;
    };

    # NOTE: do not lazy load in the future
  };

  extraPackages = [
    pkgs.gcc
    pkgs.nodejs
    pkgs.tree-sitter
  ];
}
