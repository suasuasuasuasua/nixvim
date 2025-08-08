{
  lib,
  config,
  ...
}:
let
  name = "nvim-ufo";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    plugins.nvim-ufo = {
      # https://github.com/kevinhwang91/nvim-ufo
      enable = true;

      luaConfig.post =
        # lua
        ''
          -- Option 3: treesitter as a main provider instead
          -- (Note: the `nvim-treesitter` plugin is *not* needed.)
          -- ufo uses the same query files for folding (queries/<lang>/folds.scm)
          -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
          require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
              return {'treesitter', 'indent'}
            end
          })
        '';

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;

        settings = {
          # LazyFile is a shorthand that lazy.nvim uses
          event = [
            "BufReadPost"
            "BufWritePost"
            "BufNewFile"
          ];
          # NOTE: doesn't work well with the folding for some reason
          keys = [
            {
              __unkeyed-1 = "zR";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('ufo').openAllFolds()
                  end
                '';
              mode = "n";
              desc = "Open all Folds (UFO)";
            }
            {
              __unkeyed-1 = "zM";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('ufo').closeAllFolds()
                  end
                '';
              mode = "n";
              desc = "Close all Folds (UFO)";
            }
            # NOTE: confusing to use
            # {
            #   __unkeyed-1 = "zr";
            #   __unkeyed-3.__raw =
            #     # lua
            #     ''
            #       function()
            #         require('ufo').openFoldsExceptKinds()
            #       end
            #     '';
            #   mode = "n";
            #   desc = "Open a fold level (UFO)";
            # }
            # {
            #   __unkeyed-1 = "zm";
            #   __unkeyed-3.__raw =
            #     # lua
            #     ''
            #       function()
            #         require('ufo').closeFoldsWith()
            #       end
            #     '';
            #   mode = "n";
            #   desc = "Close a fold level (UFO)";
            # }
            {
              __unkeyed-1 = "K";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                      local winid = require('ufo').peekFoldedLinesUnderCursor()
                      if not winid then
                          -- choose one of coc.nvim and nvim lsp
                          vim.fn.CocActionAsync('definitionHover') -- coc.nvim
                          vim.lsp.buf.hover()
                      end
                  end
                '';
              mode = "n";
              desc = "Close a fold level (UFO)";
            }
          ];
        };
      };
    };
  };
}
