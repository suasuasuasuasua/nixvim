{
  description = "suasuasuasuasua's neovim config (nixCats)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # diffview-plus.nvim (fork of sindrets/diffview.nvim; not yet in nixpkgs)
    "plugins-diffview-plus" = {
      url = "github:dlyongemallo/diffview-plus.nvim";
      flake = false;
    };

    # nvim-tmux-navigation (alexghergh's version; not in nixpkgs)
    "plugins-nvim-tmux-navigation" = {
      url = "github:alexghergh/nvim-tmux-navigation";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      flake-parts,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = {
        allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "obsidian" ];
      };

      dependencyOverlays = [
        # makes pkgs.neovimPlugins.<name> available for non-nixpkgs inputs
        (utils.standardPluginOverlay inputs)
      ];

      categoryDefinitions =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          ...
        }@packageDef:
        {
          # Tools placed on $PATH inside the nvim wrapper (replaces mason)
          lspsAndRuntimeDeps = {
            general = with pkgs; [
              ripgrep
              fd
              stylua
            ];
            c = with pkgs; [
              clang-tools # provides clangd
            ];
            go = with pkgs; [
              gopls
              gotools
              go-tools
            ];
            lua = with pkgs; [ lua-language-server ];
            nix = with pkgs; [ nil ];
            python = with pkgs; [ python3Packages.python-lsp-server ];
            typst = with pkgs; [ tinymist ];
            dap = with pkgs; [
              delve # Go debugger
              lldb # provides lldb-dap for C/C++; wire up codelldb separately if needed
              python3Packages.debugpy
            ];
          };

          # Plugins loaded at startup
          startupPlugins = {
            general = with pkgs.vimPlugins; [
              mini-nvim
              friendly-snippets
              conform-nvim
              # treesitter with a base set of grammars; extend as needed
              (nvim-treesitter.withPlugins (
                p: with p; [
                  bash
                  c
                  diff
                  html
                  lua
                  luadoc
                  markdown
                  markdown-inline
                  query
                  vim
                  vimdoc
                ]
              ))
              grug-far-nvim
              guess-indent-nvim
              lazygit-nvim
              neogen
              nvim-bqf
              pkgs.neovimPlugins.nvim-tmux-navigation
              nvim-ufo
              promise-async
              overseer-nvim
              render-markdown-nvim
              tokyonight-nvim
              pkgs.neovimPlugins.diffview-plus
            ];

            dap = with pkgs.vimPlugins; [
              nvim-dap
              nvim-dap-ui
              nvim-nio
              nvim-dap-go
              nvim-dap-python
            ];

            # optional — enable per packageDefinitions
            neorg = with pkgs.vimPlugins; [ neorg ];
            oil = with pkgs.vimPlugins; [ oil-nvim ];
          };
        };

      packageDefinitions = {
        nvim =
          { pkgs, name, ... }:
          {
            settings = {
              wrapRc = true; # lua config is baked into the nix store
              aliases = [ "vim" ];
            };
            categories = {
              general = true;
              c = true;
              go = true;
              lua = true;
              nix = true;
              python = true;
              typst = true;
              dap = true;
              # opt-in
              neorg = false;
              oil = false;
            };
          };
      };

      defaultPackageName = "nvim";
    in

    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;
        devShells.default = pkgs.mkShell { packages = [ defaultPackage ]; };
      }
    );
}
