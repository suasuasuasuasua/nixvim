{
  lib,
  config,
  ...
}:
let
  name = "oil";
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
    # https://github.com/stevearc/oil.nvim
    plugins.oil = {
      enable = true;

      settings = {
        # Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        # Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
        default_file_explorer = true;

        # Id is automatically added at the beginning, and name at the end
        # See :help oil-columns
        columns = [
          "icon"
          # "permissions"
          # "size"
          # "mtime"
        ];

        # Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = true;

        win_options = {
          signcolumn = "yes:2"; # for git sign columns
          winblend = 0;
        };

        # Configuration for the floating window in oil.open_float
        float = {
          # Padding around the floating window
          padding = 12;
          # max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          max_width = 0;
          max_height = 0;
          border = "rounded";
          win_options = {
            signcolumn = "yes:2"; # for git sign columns
            winblend = 0;
          };
          # optionally override the oil buffers window title with custom function: fun(winid: integer): string
          get_win_title = null;
          # preview_split: Split direction: "auto", "left", "right", "above", "below".
          preview_split = "auto";
        };

        keymaps = {
          # open the files and navigate to the parent
          "l" = "actions.select";
          "h" = {
            __unkeyed-1 = "actions.parent";
            mode = "n";
          };

          # remap horizontal and vertical splits
          "<C-h>" = false;
          "<C-x>" = {
            __unkeyed-1 = "actions.select";
            opts = {
              horizontal = true;
            };
          };
          "<C-s>" = false;
          "<C-v>" = {
            __unkeyed-1 = "actions.select";
            opts = {
              vertical = true;
            };
          };

          # remap refresh to ctrl-r
          "<C-l>" = false;
          "<C-r>" = "actions.refresh";
          # copy the current file path
          "y." = "actions.copy_entry_path";

          # scroll the preview window
          "<C-d>" = "actions.preview_scroll_down";
          "<C-u>" = "actions.preview_scroll_up";
        };
      };

      # NOTE: not recommended according to GitHub
      lazyLoad = {
        enable = false;
      };
    };

    plugins.oil-git-status = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "-";
        action = "<CMD>Oil<CR>";
        options = {
          desc = "Open parent directory";
        };
      }
      {
        mode = "n";
        key = "_";
        action = "<CMD>Oil --float<CR>";
        options = {
          desc = "Open parent directory";
        };
      }
    ];
  };
}
