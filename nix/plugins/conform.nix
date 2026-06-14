{ pkgs, ... }:
{
  # Autoformat
  # https://nix-community.github.io/nixvim/plugins/conform-nvim.html
  plugins.conform-nvim = {
    enable = true;
    settings = {
      notify_on_error = false;
      format_on_save.__raw = ''
        function(bufnr)
          local disable_filetypes = { c = true, cpp = true }
          if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
          else
            return { timeout_ms = 500, lsp_format = 'fallback' }
          end
        end
      '';
      formatters_by_ft = {
        lua = [ "stylua" ];
      };
    };
  };

  keymaps = [
    {
      mode = "";
      key = "<leader>f";
      action.__raw = ''
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end
      '';
      options.desc = "[F]ormat buffer";
    }
  ];

  extraPackages = [ pkgs.stylua ];
}
