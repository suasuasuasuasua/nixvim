{
  lib,
  config,
  ...
}:
let
  name = "gitsigns";
  cfg = config.nixvim.plugins.kickstart.${name};
in
{
  options.nixvim.plugins.kickstart.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # Adds git related signs to the gutter, as well as utilities for managing changes
    # See `:help gitsigns` to understand what the configuration keys do
    # https://nix-community.github.io/nixvim/plugins/gitsigns/index.html
    plugins.gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = {
            text = "+";
          };
          change = {
            text = "~";
          };
          delete = {
            text = "_";
          };
          topdelete = {
            text = "‾";
          };
          changedelete = {
            text = "~";
          };
        };
      };

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;
        settings = {
          # LazyFile is a shorthand that lazy.nvim uses
          event = [
            "BufReadPost"
            "BufWritePost"
            "BufNewFile"
          ];
          # NOTE: add gitsigns recommended keymaps if you are interested
          # https://nix-community.github.io/nixvim/keymaps/index.html
          keys = [
            # Navigation
            {
              __unkeyed-1 = "]c";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    if vim.wo.diff then
                      vim.cmd.normal { ']c', bang = true }
                    else
                      require('gitsigns').nav_hunk 'next'
                    end
                  end
                '';
              mode = "n";
              options = {
                desc = "Jump to next git [C]hange";
              };
            }
            {
              __unkeyed-1 = "[c";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    if vim.wo.diff then
                      vim.cmd.normal { '[c', bang = true }
                    else
                      require('gitsigns').nav_hunk 'prev'
                    end
                  end
                '';
              mode = "n";
              options = {
                desc = "Jump to previous git [C]hange";
              };
            }
            # Actions
            # visual mode
            {
              __unkeyed-1 = "<leader>hs";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                  end
                '';
              mode = "v";
              options = {
                desc = "stage git hunk";
              };
            }
            {
              __unkeyed-1 = "<leader>hr";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                  end
                '';
              mode = "v";
              options = {
                desc = "reset git hunk";
              };
            }
            # normal mode
            {
              __unkeyed-1 = "<leader>hs";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').stage_hunk()
                  end
                '';
              mode = "n";
              options = {
                desc = "git [s]tage hunk";
              };
            }
            {
              __unkeyed-1 = "<leader>hr";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').reset_hunk()
                  end
                '';
              mode = "n";
              options = {
                desc = "git [r]eset hunk";
              };
            }
            {
              __unkeyed-1 = "<leader>hS";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').stage_buffer()
                  end
                '';
              mode = "n";
              options = {
                desc = "git [S]tage buffer";
              };
            }
            {
              __unkeyed-1 = "<leader>hu";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').undo_stage_hunk()
                  end
                '';
              mode = "n";
              options = {
                desc = "git [u]ndo stage hunk";
              };
            }
            {
              __unkeyed-1 = "<leader>hR";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').reset_buffer()
                  end
                '';
              mode = "n";
              options = {
                desc = "git [R]eset buffer";
              };
            }
            {
              __unkeyed-1 = "<leader>hp";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').preview_hunk()
                  end
                '';
              mode = "n";
              options = {
                desc = "git [p]review hunk";
              };
            }
            {
              __unkeyed-1 = "<leader>hb";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').blame_line()
                  end
                '';
              mode = "n";
              options = {
                desc = "git [b]lame line";
              };
            }
            {
              __unkeyed-1 = "<leader>hd";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').diffthis()
                  end
                '';
              mode = "n";
              options = {
                desc = "git [d]iff against index";
              };
            }
            {
              __unkeyed-1 = "<leader>hD";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').diffthis '@'
                  end
                '';
              mode = "n";
              options = {
                desc = "git [D]iff against last commit";
              };
            }
            # Toggles
            {
              __unkeyed-1 = "<leader>tb";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').toggle_current_line_blame()
                  end
                '';
              mode = "n";
              options = {
                desc = "[T]oggle git show [b]lame line";
              };
            }
            {
              __unkeyed-1 = "<leader>tD";
              __unkeyed-3.__raw =
                # lua
                ''
                  function()
                    require('gitsigns').toggle_deleted()
                  end
                '';
              mode = "n";
              options = {
                desc = "[T]oggle git show [D]eleted";
              };
            }
          ];
        };
      };
    };
  };
}
