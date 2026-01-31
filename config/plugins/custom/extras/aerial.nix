{
  lib,
  config,
  ...
}:
let
  name = "arial";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/stevearc/aerial.nvim
    plugins.aerial = {
      enable = true;

      luaConfig.post =
        # lua
        ''
          require("aerial").setup({
            -- optionally use on_attach to set keymaps when aerial has attached to a buffer
            on_attach = function(bufnr)
              -- Jump forwards/backwards with '{' and '}'
              vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
              vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
            end,
          })
        '';

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;

        settings = {
          event = [ "DeferredUIEnter" ];
          keys = [
            {
              __unkeyed-1 = "<leader>a";
              __unkeyed-3 = "<CMD>AerialToggle!<CR>";
              mode = "n";
              desc = "Toggle [A]erial";
            }
          ];
        };
      };
    };
  };
}
