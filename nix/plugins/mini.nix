{
  # Collection of various small independent plugins/modules
  # https://nix-community.github.io/nixvim/plugins/mini.html
  plugins.mini = {
    enable = true;

    mockDevIcons = true;
    modules = {
      # better around/inside textobjects
      ai = { };

      # key binding hints (replaces which-key)
      clue = {
        triggers = [
          {
            mode = [
              "n"
              "x"
            ];
            keys = "<Leader>";
          }
          {
            mode = "n";
            keys = "[";
          }
          {
            mode = "n";
            keys = "]";
          }
          {
            mode = "i";
            keys = "<C-x>";
          }
          {
            mode = [
              "n"
              "x"
            ];
            keys = "g";
          }
          {
            mode = [
              "n"
              "x"
            ];
            keys = "'";
          }
          {
            mode = [
              "n"
              "x"
            ];
            keys = "`";
          }
          {
            mode = [
              "n"
              "x"
            ];
            keys = ''"'';
          }
          {
            mode = [
              "i"
              "c"
            ];
            keys = "<C-r>";
          }
          {
            mode = "n";
            keys = "<C-w>";
          }
          {
            mode = [
              "n"
              "x"
            ];
            keys = "z";
          }
        ];
        clues.__raw = ''
          {
            require('mini.clue').gen_clues.square_brackets(),
            require('mini.clue').gen_clues.builtin_completion(),
            require('mini.clue').gen_clues.g(),
            require('mini.clue').gen_clues.marks(),
            require('mini.clue').gen_clues.registers(),
            require('mini.clue').gen_clues.windows(),
            require('mini.clue').gen_clues.z(),
          }
        '';
        window = {
          delay = 10;
          scroll_down = "<C-d>";
          scroll_up = "<C-u>";
        };
      };

      # command-line replacement
      cmdline = { };

      # completion (replaces blink-cmp/nvim-cmp)
      completion = {
        delay = {
          completion = 10;
          info = 10;
          signature = 5;
        };
      };

      # extra pickers for mini.pick
      extra = { };

      # icons (replaces web-devicons)
      icons = { };

      # input (replaces vim.ui.input)
      # input = { }; # TODO: not here yet

      # indentation scope (replaces indent-blankline)
      indentscope = {
        draw = {
          delay = 10;
          animation.__raw = "require('mini.indentscope').gen_animation.none()";
        };
      };

      # notifications
      notify = { };

      # autopairs (replaces nvim-autopairs)
      pairs = {
        modes = {
          command = true;
        };
      };

      # fuzzy finder (replaces telescope)
      pick = { };

      # snippets (replaces luasnip)
      snippets = {
        snippets = [
          {
            __raw = "require('mini.snippets').gen_loader.from_lang()";
          }
        ];
      };

      # statusline (replaces lualine)
      statusline = { };

      # surround (replaces nvim-surround)
      surround = {
        mappings = {
          add = "ys";
          delete = "ds";
          find = "";
          find_left = "";
          highlight = "";
          replace = "cs";
          suffix_last = "";
          suffix_next = "";
        };
        search_method = "cover_or_next";
      };

      # trailing whitespace (replaces trim.nvim)
      trailspace = { };
    };

    luaConfig.post =
      # lua
      ''
        -- mini.icons: mock web-devicons and tweak LSP kinds
        MiniIcons.tweak_lsp_kind()

        -- mini.snippets: start LSP server for snippet completion
        MiniSnippets.start_lsp_server()

        -- mini.pick: custom registry pickers
        local pick = require('mini.pick')
        pick.registry.registry = function()
          local items = vim.tbl_keys(pick.registry)
          table.sort(items)
          local source = { items = items, name = 'Registry', choose = function() end }
          local chosen_picker_name = pick.start { source = source }
          if chosen_picker_name == nil then return end
          return pick.registry[chosen_picker_name]()
        end
        pick.registry.files = function(local_opts)
          local_opts = local_opts or {}
          local cwd = local_opts.cwd or vim.fn.getcwd()
          if vim.fn.executable('rg') == 1 then
            local command = { 'rg', '--files', '--hidden', '--glob', '!.git' }
            return pick.builtin.cli({ command = command }, { source = { name = 'Files', cwd = cwd } })
          end
          return pick.builtin.files(local_opts, { source = { cwd = cwd } })
        end

        -- mini.surround: remap Visual mode surround and line surround
        vim.keymap.del('x', 'ys')
        vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
        vim.keymap.set('n', 'yss', 'ys_', { remap = true })

        -- mini.files: file explorer with git-status filter
        local function parse_git_output(proc)
          local result = proc:wait()
          local ret = {}
          if result.code == 0 then
            for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
              line = line:gsub('/$', "")
              ret[line] = true
            end
          end
          return ret
        end

        local function new_git_status()
          return setmetatable({}, {
            __index = function(self, key)
              local ignore_proc = vim.system(
                { 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' },
                { cwd = key, text = true }
              )
              local tracked_proc = vim.system(
                { 'git', 'ls-tree', 'HEAD', '--name-only' },
                { cwd = key, text = true }
              )
              local ret = {
                ignored = parse_git_output(ignore_proc),
                tracked = parse_git_output(tracked_proc),
              }
              rawset(self, key, ret)
              return ret
            end,
          })
        end
        local git_status = new_git_status()

        local show_all = false
        local filter_show = function(_) return true end
        local filter_git = function(fs_entry)
          local dir = vim.fs.dirname(fs_entry.path)
          local is_dotfile = vim.startswith(fs_entry.name, '.') and fs_entry.name ~= '..'
          if is_dotfile then
            return git_status[dir].tracked[fs_entry.name] == true
          else
            return not git_status[dir].ignored[fs_entry.name]
          end
        end

        require('mini.files').setup({
          options = { use_as_default_explorer = false },
          content = { filter = filter_git },
        })

        local toggle_dotfiles = function()
          show_all = not show_all
          local new_filter = show_all and filter_show or filter_git
          MiniFiles.refresh({ content = { filter = new_filter } })
        end
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MiniFilesBufferCreate',
          callback = function(args)
            vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = args.data.buf_id })
          end,
        })
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MiniFilesExplorerOpen',
          callback = function() git_status = new_git_status() end,
        })
        vim.keymap.set('n', '-', function()
          local path = vim.api.nvim_buf_get_name(0)
          MiniFiles.open(path ~= "" and path or vim.fn.getcwd())
        end, { desc = 'Open parent directory' })
      '';
  };

  # friendly-snippets provides a variety of premade snippets for mini.snippets
  # https://github.com/rafamadriz/friendly-snippets
  plugins.friendly-snippets.enable = true;

  # mini.pick keymaps
  keymaps = [
    {
      mode = "n";
      key = "<leader>sh";
      action.__raw = "require('mini.pick').registry.help";
      options.desc = "[S]earch [H]elp";
    }
    {
      mode = "n";
      key = "<leader>sk";
      action.__raw = "require('mini.pick').registry.keymaps";
      options.desc = "[S]earch [K]eymaps";
    }
    {
      mode = "n";
      key = "<leader>sf";
      action.__raw = "function() require('mini.pick').registry.files { cwd = vim.fn.getcwd() } end";
      options.desc = "[S]earch [F]iles";
    }
    {
      mode = "n";
      key = "<leader>ss";
      action.__raw = "require('mini.pick').registry.registry";
      options.desc = "[S]earch [S]elect Registry";
    }
    {
      mode = "n";
      key = "<leader>sg";
      action.__raw = "require('mini.pick').registry.grep_live";
      options.desc = "[S]earch by [G]rep";
    }
    {
      mode = "n";
      key = "<leader>sd";
      action.__raw = "require('mini.pick').registry.diagnostic";
      options.desc = "[S]earch [D]iagnostics";
    }
    {
      mode = "n";
      key = "<leader>sr";
      action.__raw = "require('mini.pick').registry.resume";
      options.desc = "[S]earch [R]esume";
    }
    {
      mode = "n";
      key = "<leader>s.";
      action.__raw = "require('mini.pick').registry.oldfiles";
      options.desc = ''[S]earch Recent Files ("." for repeat)'';
    }
    {
      mode = "n";
      key = "<leader>sc";
      action.__raw = "require('mini.pick').registry.commands";
      options.desc = "[S]earch [C]ommands";
    }
    {
      mode = "n";
      key = "<leader><leader>";
      action.__raw = "require('mini.pick').registry.buffers";
      options.desc = "[ ] Find existing buffers";
    }
    {
      mode = "n";
      key = "<leader>sn";
      action.__raw = "function() require('mini.pick').registry.files { cwd = vim.fn.stdpath('config') } end";
      options.desc = "[S]earch [N]eovim files";
    }
    {
      mode = "n";
      key = "<leader>s:";
      action.__raw = "function() require('mini.pick').registry.history { scope = ':' } end";
      options.desc = "[S]earch [:] command history";
    }
    {
      mode = "n";
      key = "<leader>s/";
      action.__raw = "function() require('mini.pick').registry.history { scope = '/' } end";
      options.desc = "[S]earch [/] search history";
    }
  ];
}
