{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixvim.lsp;
  lang = cfg.languages;
  inherit (lib)
    mkOption
    mkIf
    mkMerge
    optionals
    ;
  inherit (lib.types) bool;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  # vim.lsp.enable { 'clangd', 'gopls', 'lua_ls', 'nil_ls', 'pylsp' }
  # vim.diagnostic.config { ... }
  options.nixvim.lsp = {
    enable = mkOption {
      type = bool;
      default = true;
      description = "Enable LSP for neovim";
    };

    languages = {
      clangd.enable = mkOption {
        type = bool;
        default = true;
        description = "Enable clangd LSP for neovim";
      };
      gopls.enable = mkOption {
        type = bool;
        default = true;
        description = "Enable gopls LSP for neovim";
      };
      lua_ls.enable = mkOption {
        type = bool;
        default = true;
        description = "Enable lua_ls LSP for neovim";
      };
      nil_ls.enable = mkOption {
        type = bool;
        default = true;
        description = "Enable nil_ls LSP for neovim";
      };
      pylsp.enable = mkOption {
        type = bool;
        default = true;
        description = "Enable pylsp LSP for neovim";
      };
      tinymist.enable = mkOption {
        type = bool;
        default = true;
        description = "Enable tinymist LSP for neovim";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # https://nix-community.github.io/nixvim/plugins/lsp/index.html
      plugins.lsp = {
        enable = true;

        servers = { };

        keymaps = {
          lspBuf = {
            "grn" = {
              action = "rename";
              desc = "LSP: [R]e[n]ame";
            };
            "gra" = {
              mode = [
                "n"
                "x"
              ];
              action = "code_action";
              desc = "LSP: [G]oto Code [A]ction";
            };
            "grD" = {
              action = "declaration";
              desc = "LSP: [G]oto [D]eclaration";
            };
          };

          # LSP navigation via mini.pick (matches dotfiles mini.lua LspAttach keymaps)
          extra = [
            {
              mode = "n";
              key = "grr";
              action.__raw = "function() require('mini.extra').pickers.lsp({ scope = 'references' }) end";
              options.desc = "LSP: [G]oto [R]eferences";
            }
            {
              mode = "n";
              key = "gri";
              action.__raw = "function() require('mini.extra').pickers.lsp({ scope = 'implementation' }) end";
              options.desc = "LSP: [G]oto [I]mplementation";
            }
            {
              mode = "n";
              key = "grd";
              action.__raw = "function() require('mini.extra').pickers.lsp({ scope = 'definition' }) end";
              options.desc = "LSP: [G]oto [D]efinition";
            }
            {
              mode = "n";
              key = "gO";
              action.__raw = "function() require('mini.extra').pickers.lsp({ scope = 'document_symbol' }) end";
              options.desc = "LSP: Open Document Symbols";
            }
            {
              mode = "n";
              key = "gW";
              action.__raw = "function() require('mini.extra').pickers.lsp({ scope = 'workspace_symbol' }) end";
              options.desc = "LSP: Open Workspace Symbols";
            }
            {
              mode = "n";
              key = "grt";
              action.__raw = "function() require('mini.extra').pickers.lsp({ scope = 'type_definition' }) end";
              options.desc = "LSP: [G]oto [T]ype Definition";
            }
          ];
        };

        # This function gets run when an LSP attaches to a particular buffer.
        onAttach =
          # lua
          ''
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client:supports_method('textDocument/documentHighlight', event.buf) then
              local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
                end,
              })
            end

            if client and client:supports_method('textDocument/inlayHint', event.buf) then
              vim.keymap.set('n', '<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, { buffer = event.buf, desc = 'LSP: [T]oggle Inlay [H]ints' })
            end
          '';
      };

      diagnostic.settings = {
        update_in_insert = false;
        severity_sort = true;
        float = {
          border = "rounded";
          source = "if_many";
        };
        underline = {
          severity = {
            min.__raw = "vim.diagnostic.severity.WARN";
          };
        };
        virtual_text = true;
        virtual_lines = false;
      };

      autoGroups."lsp-attach".clear = true;

      extraPackages = optionals isLinux (with pkgs; [ inotify-tools ]);
    })

    # clangd — C/C++ language server
    (mkIf (cfg.enable && lang.clangd.enable) {
      plugins = {
        lsp.servers.clangd.enable = true;
        treesitter.grammarPackages =
          with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            c
            cpp
            printf
          ];
      };
      extraPackages = with pkgs; [ clang-tools ];
    })

    # gopls — Go language server
    (mkIf (cfg.enable && lang.gopls.enable) {
      plugins = {
        lsp.servers.gopls.enable = true;
        treesitter.grammarPackages =
          with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            go
            gomod
            gosum
          ];
      };
      extraPackages = with pkgs; [ go ];
    })

    # lua_ls — Lua language server (settings in lsp/lua_ls.nix)
    (mkIf (cfg.enable && lang.lua_ls.enable) {
      plugins = {
        lsp.servers.lua_ls.enable = true;
        treesitter.grammarPackages =
          with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            lua
            luadoc
          ];
      };
    })

    # nil_ls — Nix language server
    (mkIf (cfg.enable && lang.nil_ls.enable) {
      plugins = {
        lsp.servers.nil_ls.enable = true;
        treesitter.grammarPackages =
          with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            nix
          ];
      };
      extraPackages = with pkgs; [ nil ];
    })

    # pylsp — Python language server
    (mkIf (cfg.enable && lang.pylsp.enable) {
      plugins = {
        lsp.servers.pylsp.enable = true;
        treesitter.grammarPackages =
          with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            python
          ];
      };
    })

    # tinymist — Typst language server (settings in lsp/tinymist.nix)
    (mkIf (cfg.enable && lang.tinymist.enable) {
      plugins.lsp.servers.tinymist.enable = true;
    })
  ];
}
