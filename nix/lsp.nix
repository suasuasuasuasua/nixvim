{ lib, pkgs, ... }:
let
  inherit (lib) optionals;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  # vim.lsp.enable { 'clangd', 'gopls', 'lua_ls', 'nil_ls', 'pylsp', 'tinymist' }
  # vim.diagnostic.config { ... }
  plugins.lsp = {
    enable = true;

    servers = {
      clangd.enable = true;
      gopls.enable = true;
      lua_ls.enable = true;
      nil_ls.enable = true;
      pylsp.enable = true;
      tinymist.enable = true;
    };

    keymaps = {
      lspBuf = {
        grn = {
          action = "rename";
          desc = "LSP: [R]e[n]ame";
        };
        gra = {
          mode = [
            "n"
            "x"
          ];
          action = "code_action";
          desc = "LSP: [G]oto Code [A]ction";
        };
        grD = {
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

  autoGroups.lsp-attach.clear = true;

  plugins.treesitter.grammarPackages =
    with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      c
      cpp
      printf
      go
      gomod
      gosum
      lua
      luadoc
      nix
      python
    ];

  extraPackages = [
    pkgs.clang-tools
    pkgs.gopls
    pkgs.lua-language-server
    pkgs.nil
    pkgs.python313Packages.python-lsp-server
    pkgs.tinymist
  ]
  ++ optionals isLinux [ pkgs.inotify-tools ];
}
