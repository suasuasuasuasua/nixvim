{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "neo-tree";
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
    # Neo-tree is a Neovim plugin to browse the file system
    # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html?highlight=neo-tree#pluginsneo-treepackage
    plugins.neo-tree = {
      enable = true;

      closeIfLastWindow = true;

      documentSymbols = {
        followCursor = true;
      };

      filesystem = {
        followCurrentFile.enabled = false;
        window.mappings = {
          # close neo-tree window
          "\\" = "close_window";

          # move left in the tree with 'h'
          h.__raw =
            # lua
            ''
              -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Tips#navigation-with-hjkl
              function(state)
                local node = state.tree:get_node()
                if node.type == 'directory' and node:is_expanded() then
                  require'neo-tree.sources.filesystem'.toggle_directory(state, node)
                else
                  require'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
                end
              end
            '';
          # move right in the tree with 'h'
          l.__raw =
            # lua
            ''
              -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Tips#navigation-with-hjkl
              function(state)
                local node = state.tree:get_node()
                if node.type == 'directory' then
                  if not node:is_expanded() then
                    require'neo-tree.sources.filesystem'.toggle_directory(state, node)
                  elseif node:has_children() then
                    require'neo-tree.ui.renderer'.focus_node(state, node:get_child_ids()[1])
                  end
                end
              end
            '';

          # open files without losing focus on sidebar
          "<tab>".__raw =
            # lua
            ''
              -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Tips#navigation-with-hjkl
              function (state)
                local node = state.tree:get_node()
                if require('neo-tree.utils').is_expandable(node) then
                  state.commands["toggle_node"](state)
                else
                  state.commands['open'](state)
                  vim.cmd('Neotree reveal')
                  -- vim.cmd('Neotree float toggle reveal_force_cwd dir=' .. vim.fn.getcwd()) -- I use this one.
                end
              end
            '';

          # open files in native system explorer
          # NOTE: should have a default program to open the file extension
          o.__raw =
            if pkgs.stdenv.isLinux then
              # lua
              ''
                function(state)
                  local node = state.tree:get_node()
                  local path = node:get_id()
                  -- Linux: open file in default application
                  vim.fn.jobstart({ "xdg-open", path }, { detach = true })
                end
              ''
            else if pkgs.stdenv.isDarwin then
              # lua
              ''
                function(state)
                  local node = state.tree:get_node()
                  local path = node:get_id()
                  -- macOs: open file in default application in the background.
                  vim.fn.jobstart({ "open", path }, { detach = true })
                end
              ''
            else
              # lua
              ''
                function(state)
                  vim.cmd("echo not implemented for windows...")
                end
              '';

          # expand all nodes
          Z = "expand_all_nodes";
        };
      };
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      {
        key = "\\";
        action = "<cmd>Neotree reveal<cr>";
        options = {
          desc = "NeoTree reveal";
          silent = true;
        };
      }
    ];
  };
}
