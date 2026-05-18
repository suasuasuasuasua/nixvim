{
  lib,
  config,
  ...
}:
let
  name = "oil";
  cfg = config.nixvim.plugins.${name};
in
{
  options.nixvim.plugins.${name} = {
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
          "<C-l>" = "actions.select";
          "<C-h>" = {
            __unkeyed-1 = "actions.parent";
            mode = "n";
          };

          # remap horizontal and vertical splits
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
          "<C-r>" = "actions.refresh";
          # copy the current file path
          "y." = "actions.copy_entry_path";

          # scroll the preview window (matching dotfiles: C-f/C-b)
          "<C-f>" = "actions.preview_scroll_down";
          "<C-b>" = "actions.preview_scroll_up";

          # toggle detailed file view (permissions, size, mtime)
          "gd" = {
            desc = "Toggle file detail view";
            callback.__raw = ''
              function()
                local cols = require("oil").get_columns()
                if #cols > 1 then
                  require("oil").set_columns({ "icon" })
                else
                  require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                end
              end
            '';
          };

          # find files in current oil directory via mini.pick
          "<leader>sf" = {
            __unkeyed-1.__raw = ''
              function()
                require("mini.pick").builtin.files {
                  cwd = require("oil").get_current_dir()
                }
              end
            '';
            mode = "n";
            nowait = true;
            desc = "Find files in the current directory";
          };

          # run shell/Ex commands on selected files
          "<leader>:" = {
            callback.__raw = ''
              function()
                oil_run_on_selection({
                  prefix = "!",
                  prompt = "Shell cmd ({} = file): ",
                })
              end
            '';
            mode = [
              "n"
              "v"
            ];
            desc = "Run shell command on selected files";
          };
          "<leader><leader>:" = {
            callback.__raw = ''
              function()
                oil_run_on_selection({ prompt = "Ex cmd ({} = file): " })
              end
            '';
            mode = [
              "n"
              "v"
            ];
            desc = "Run Ex command on selected files";
          };
        };
      };
    };

    plugins.oil-git-status = {
      enable = true;
    };

    # Define oil_run_on_selection as a global so oil keymaps can reference it
    extraConfigLua = ''
      _G.oil_run_on_selection = function(opts)
        opts = opts or {}
        local oil = require("oil")
        local bufnr = vim.api.nvim_get_current_buf()

        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end

        local dir = oil.get_current_dir()
        local paths = {}
        for lnum = start_line, end_line do
          local entry = oil.get_entry_on_line(bufnr, lnum)
          if entry then
            table.insert(paths, vim.fn.fnameescape(dir .. entry.name))
          end
        end
        if #paths == 0 then return end

        local prefix = opts.prefix or ""
        vim.ui.input({ prompt = opts.prompt or "Cmd ({} = file): " }, function(cmd)
          if not cmd or cmd == "" then return end
          cmd = prefix .. cmd
          for _, path in ipairs(paths) do
            local expanded = cmd:find("{}", 1, true)
                and cmd:gsub("{}", path)
                or (cmd .. " " .. path)
            vim.cmd(expanded)
            require("oil.actions").refresh.callback()
          end
        end)
      end
    '';

    keymaps = [
      {
        mode = "n";
        key = "-";
        action = "<CMD>Oil<CR>";
        options = {
          desc = "Open parent directory";
        };
      }
    ];
  };
}
