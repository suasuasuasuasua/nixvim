{
  # https://github.com/stevearc/oil.nvim
  plugins.oil = {
    enable = true;

    settings = {
      default_file_explorer = true;

      columns = [ "icon" ];

      view_options = {
        is_hidden_file.__raw = ''
          function(name, bufnr)
            local dir = require("oil").get_current_dir(bufnr)
            local is_dotfile = vim.startswith(name, ".") and name ~= ".."
            if not dir then return is_dotfile end
            if is_dotfile then
              return not _oil_git_status[dir].tracked[name]
            else
              return _oil_git_status[dir].ignored[name]
            end
          end
        '';
      };

      keymaps = {
        "<C-l>" = "actions.select";
        "<C-h>" = {
          __unkeyed-1 = "actions.parent";
          mode = "n";
        };
        "<C-x>" = {
          __unkeyed-1 = "actions.select";
          opts.horizontal = true;
        };
        "<C-s>" = false;
        "<C-v>" = {
          __unkeyed-1 = "actions.select";
          opts.vertical = true;
        };
        "<C-r>" = "actions.refresh";
        "y." = "actions.copy_entry_path";
        "<C-f>" = "actions.preview_scroll_down";
        "<C-b>" = "actions.preview_scroll_up";

        gd = {
          desc = "Toggle file detail view";
          callback.__raw = ''
            function()
              _oil_detail = not _oil_detail
              if _oil_detail then
                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
              else
                require("oil").set_columns({ "icon" })
              end
            end
          '';
        };

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

        "<leader>:" = {
          callback.__raw = ''function() _oil_run_on_selection({ prefix = "!", prompt = "Shell cmd ({} = file): " }) end'';
          mode = [
            "n"
            "v"
          ];
          desc = "Run shell command on selected files";
        };
        "<leader><leader>:" = {
          callback.__raw = ''function() _oil_run_on_selection({ prompt = "Ex cmd ({} = file): " }) end'';
          mode = [
            "n"
            "v"
          ];
          desc = "Run Ex command on selected files";
        };
      };
    };
  };

  plugins.oil-git-status.enable = true;

  extraConfigLua =
    # lua
    ''
      _oil_detail = false

      _oil_new_git_status = function()
        local function parse_output(proc)
          local result = proc:wait()
          local ret = {}
          if result.code == 0 then
            for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
              line = line:gsub("/$", "")
              ret[line] = true
            end
          end
          return ret
        end
        return setmetatable({}, {
          __index = function(self, key)
            local ignore_proc = vim.system(
              { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
              { cwd = key, text = true }
            )
            local tracked_proc = vim.system(
              { "git", "ls-tree", "HEAD", "--name-only" },
              { cwd = key, text = true }
            )
            local ret = {
              ignored = parse_output(ignore_proc),
              tracked = parse_output(tracked_proc),
            }
            rawset(self, key, ret)
            return ret
          end,
        })
      end
      _oil_git_status = _oil_new_git_status()

      local _oil_refresh = require("oil.actions").refresh
      local _oil_orig_refresh = _oil_refresh.callback
      _oil_refresh.callback = function(...)
        _oil_git_status = _oil_new_git_status()
        _oil_orig_refresh(...)
      end

      _oil_run_on_selection = function(opts)
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
      options.desc = "Open parent directory";
    }
  ];
}
