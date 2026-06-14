{
  # Collection of various small independent plugins/modules
  # https://nix-community.github.io/nixvim/plugins/mini.html
  plugins.mini = {
    enable = true;

    mockDevIcons = true;
    modules = {
      # better around/inside textobjects
      ai = { };

      # opinionated basic options/mappings/autocommands
      basics = { };

      # bracket text objects and motions
      bracketed = { };

      # key binding hints
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

      # completion
      completion = {
        delay = {
          completion = 10;
          info = 10;
          signature = 5;
        };
      };

      # highlight word under cursor
      cursorword = {
        delay = 10;
      };

      # diff signs in sign column (replaces gitsigns)
      diff = {
        view = {
          style = "sign";
          signs = {
            add = "+";
            change = "~";
            delete = "_";
          };
        };
      };

      # extra pickers for mini.pick
      extra = { };

      # git integration (replaces neogit blame/diff keymaps)
      git = { };

      # highlight patterns in buffers
      hipatterns = {
        highlighters = {
          fixme = {
            pattern = "FIXME";
            group = "MiniHipatternsFixme";
          };
          hack = {
            pattern = "HACK";
            group = "MiniHipatternsHack";
          };
          todo = {
            pattern = "TODO";
            group = "MiniHipatternsTodo";
          };
          note = {
            pattern = "NOTE";
            group = "MiniHipatternsNote";
          };
          hex_color.__raw = "require('mini.hipatterns').gen_highlighter.hex_color()";
        };
      };

      # icons (replaces web-devicons)
      icons = { };

      # indentation scope
      indentscope = {
        draw = {
          delay = 10;
          animation.__raw = "require('mini.indentscope').gen_animation.none()";
        };
      };

      # input (replaces vim.ui.input)
      # input = { }; # TODO: not available in nixvim yet

      # enhanced f/F/t/T motions
      jump = {
        delay.highlight = 10;
      };

      # miscellaneous helpers (setup_auto_root called in luaConfig.post)
      misc = { };

      # move lines/selections
      move = { };

      # notifications
      notify = { };

      # autopairs
      pairs = {
        modes.command = true;
      };

      # fuzzy finder
      pick = { };

      # snippets
      snippets = {
        snippets = [
          {
            __raw = "require('mini.snippets').gen_loader.from_lang()";
          }
        ];
      };

      # split/join code blocks
      splitjoin = { };

      # statusline
      statusline = { };

      # surround
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

      # trailing whitespace
      trailspace = { };

      # visit tracking
      visits = { };
    };

    luaConfig.post =
      # lua
      ''
        -- mini.icons
        MiniIcons.tweak_lsp_kind()

        -- mini.snippets
        MiniSnippets.start_lsp_server()

        -- mini.misc: auto-detect project root
        MiniMisc.setup_auto_root()

        -- mini.pick: registry picker
        local pick = require('mini.pick')
        pick.registry.registry = function()
          local items = vim.tbl_keys(pick.registry)
          table.sort(items)
          local source = { items = items, name = 'Registry', choose = function() end }
          local chosen_picker_name = pick.start { source = source }
          if chosen_picker_name == nil then return end
          return pick.registry[chosen_picker_name]()
        end

        -- mini.surround: remap Visual mode surround and line surround
        vim.keymap.del('x', 'ys')

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

  plugins.friendly-snippets.enable = true;

  keymaps = [
    # mini.surround: Visual mode surround and line surround
    {
      mode = "x";
      key = "S";
      action = ":<C-u>lua MiniSurround.add('visual')<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "yss";
      action = "ys_";
      options.remap = true;
    }

    # mini.diff: hunk navigation and reset
    {
      mode = "n";
      key = "]c";
      action.__raw = ''
        function()
          if vim.wo.diff then vim.cmd.normal { ']c', bang = true }
          else require('mini.diff').goto_hunk 'next'
          end
        end
      '';
      options.desc = "Jump to next git [c]hange";
    }
    {
      mode = "n";
      key = "[c";
      action.__raw = ''
        function()
          if vim.wo.diff then vim.cmd.normal { '[c', bang = true }
          else require('mini.diff').goto_hunk 'prev'
          end
        end
      '';
      options.desc = "Jump to previous git [c]hange";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>hr";
      action = "gH";
      options = {
        remap = true;
        desc = "git [r]eset hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>hp";
      action.__raw = "function() require('mini.diff').toggle_overlay() end";
      options.desc = "git [p]review hunk (overlay)";
    }
    {
      mode = "n";
      key = "<leader>tD";
      action.__raw = "function() require('mini.diff').toggle_overlay() end";
      options.desc = "[T]oggle git [D]iff overlay";
    }

    # mini.git: blame and diff keymaps
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>hb";
      action.__raw = "function() MiniGit.show_at_cursor() end";
      options.desc = "git [b]lame line / show at cursor";
    }
    {
      mode = "n";
      key = "<leader>hd";
      action = "<cmd>Git diff --cached -- %<CR>";
      options.desc = "git [d]iff against index";
    }
    {
      mode = "n";
      key = "<leader>hD";
      action = "<cmd>Git diff HEAD -- %<CR>";
      options.desc = "git [D]iff against last commit";
    }

    # mini.pick: pickers
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
      action.__raw = "function() require('mini.pick').builtin.files { cwd = vim.fn.getcwd() } end";
      options.desc = "[S]earch [F]iles";
    }
    {
      mode = "n";
      key = "<leader>ss";
      action.__raw = "function() MiniExtra.pickers.visit_paths() end";
      options.desc = "[S]earch Recent Files (by visit frequency)";
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
      action.__raw = "require('mini.pick').registry.registry";
      options.desc = "[S]earch [S]elect Registry";
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
